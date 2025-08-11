FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    DEBIAN_FRONTEND=noninteractive

WORKDIR /app

# System deps + Microsoft ODBC Driver 18 + python3-pyodbc (avoid pip building pyodbc)
RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends curl gnupg ca-certificates apt-transport-https dirmngr bash \
    unixodbc unixodbc-dev python3-pyodbc \
    libjpeg62-turbo libpng16-16 libfreetype6; \
  mkdir -p /etc/apt/keyrings; \
  curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg; \
  printf "Types: deb\nURIs: https://packages.microsoft.com/debian/12/prod/\nSuites: bookworm\nComponents: main\nSigned-By: /etc/apt/keyrings/microsoft.gpg\n" > /etc/apt/sources.list.d/mssql-release.sources; \
  apt-get update; \
  ACCEPT_EULA=Y apt-get install -y --no-install-recommends \
    msodbcsql18 \
    build-essential; \
  rm -rf /var/lib/apt/lists/*

# Python deps
COPY requirements.txt /app/requirements.txt
RUN python -m pip install --upgrade pip setuptools wheel && \
    pip install --no-cache-dir -r /app/requirements.txt && \
    pip install --no-cache-dir mssql-django==1.6

# App files
COPY . /app

# Static/media folders
RUN mkdir -p /app/staticfiles /app/media

# Entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY scripts/wait_for_mssql_and_init.py /app/scripts/wait_for_mssql_and_init.py
RUN chmod +x /usr/local/bin/entrypoint.sh && sed -i -e 's/\r$//' /usr/local/bin/entrypoint.sh

EXPOSE 8000
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
