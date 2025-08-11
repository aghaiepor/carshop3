FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
  PYTHONUNBUFFERED=1 \
  PIP_NO_CACHE_DIR=1 \
  DEBIAN_FRONTEND=noninteractive \
  PIP_DEFAULT_TIMEOUT=120

# System deps:
# - build tools and ODBC headers
# - pyodbc from apt
# - image libs so Pillow uses wheels (no compile)
RUN apt-get update && apt-get install -y --no-install-recommends \
  curl gnupg ca-certificates apt-transport-https \
  build-essential g++ make python3-dev pkg-config \
  unixodbc unixodbc-dev python3-pyodbc \
  libjpeg62-turbo-dev zlib1g-dev libfreetype6-dev liblcms2-dev \
  libopenjp2-7-dev libtiff5-dev libwebp-dev tk \
  && rm -rf /var/lib/apt/lists/*

# Microsoft ODBC Driver 18 (Debian 12/bookworm) via keyrings
RUN set -eux; \
  mkdir -p /etc/apt/keyrings; \
  curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg; \
  chmod 0644 /etc/apt/keyrings/microsoft.gpg; \
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/debian/12/prod bookworm main" > /etc/apt/sources.list.d/mssql-release.list; \
  apt-get update; \
  ACCEPT_EULA=Y apt-get install -y --no-install-recommends msodbcsql17; \
  rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Upgrade pip tooling and install Python deps
COPY requirements.txt .
RUN python -m pip install --upgrade pip setuptools wheel && \
    pip install --prefer-binary --no-cache-dir -r requirements.txt

# Entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# App source
COPY . .

# Ensure static/media dirs exist
RUN mkdir -p /app/staticfiles /app/media

EXPOSE 8000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
