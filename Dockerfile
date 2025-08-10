FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
  PYTHONUNBUFFERED=1 \
  PIP_NO_CACHE_DIR=1

# Base OS deps + build tools for pyodbc + ODBC headers
RUN apt-get update && apt-get install -y --no-install-recommends \
  curl gnupg ca-certificates apt-transport-https \
  build-essential g++ make python3-dev pkg-config \
  unixodbc unixodbc-dev \
  && rm -rf /var/lib/apt/lists/*

# Microsoft ODBC Driver 18 (Debian 12/bookworm) via keyrings
RUN set -eux; \
  mkdir -p /etc/apt/keyrings; \
  curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg; \
  chmod 0644 /etc/apt/keyrings/microsoft.gpg; \
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/debian/12/prod bookworm main" > /etc/apt/sources.list.d/mssql-release.list; \
  apt-get update; \
  ACCEPT_EULA=Y apt-get install -y --no-install-recommends msodbcsql18; \
  rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python deps first for better layer caching
COPY requirements.txt .
RUN pip install --prefer-binary -r requirements.txt

# Entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# App source
COPY . .

# Ensure static/media dirs exist
RUN mkdir -p /app/staticfiles /app/media

EXPOSE 8000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
