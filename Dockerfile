FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# System deps + Microsoft ODBC Driver 18 + python3-pyodbc (avoid pip building pyodbc)
RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends curl gnupg ca-certificates apt-transport-https locales; \
  echo "en_US.UTF-8 UTF-8" > /etc/locale.gen; locale-gen; \
  mkdir -p /etc/apt/keyrings; \
  curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg; \
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/debian/12/prod bookworm main" > /etc/apt/sources.list.d/microsoft-prod.list; \
  apt-get update; \
  ACCEPT_EULA=Y apt-get install -y --no-install-recommends \
    msodbcsql18 \
    unixodbc unixodbc-dev python3-pyodbc \
    build-essential \
    libjpeg62-turbo libpng16-16 libfreetype6; \
  rm -rf /var/lib/apt/lists/*

# Python deps
COPY requirements.txt /app/requirements.txt
RUN python -m pip install --upgrade pip setuptools wheel && \
    pip install --no-cache-dir -r requirements.txt

# App files
COPY . /app

# Entrypoint
RUN chmod +x /app/entrypoint.sh

EXPOSE 8000
CMD ["/app/entrypoint.sh"]
