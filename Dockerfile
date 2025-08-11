FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    DEBIAN_FRONTEND=noninteractive

# 1) System deps, ODBC runtime, and pyodbc via apt (avoids compiling wheels)
# 2) Install Microsoft ODBC Driver 18 using keyrings-based repo config
RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    curl gnupg ca-certificates apt-transport-https dirmngr \
    # ODBC runtime + headers and Python bindings from Debian
    unixodbc unixodbc-dev python3-pyodbc \
    # Pillow runtime libs so it doesn't compile
    libjpeg62-turbo libpng16-16 libfreetype6; \
  mkdir -p /etc/apt/keyrings; \
  curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg; \
  printf "Types: deb\nURIs: https://packages.microsoft.com/debian/12/prod/\nSuites: bookworm\nComponents: main\nSigned-By: /etc/apt/keyrings/microsoft.gpg\n" > /etc/apt/sources.list.d/mssql-release.sources; \
  apt-get update; \
  ACCEPT_EULA=Y apt-get install -y --no-install-recommends msodbcsql18; \
  rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python deps
COPY requirements.txt ./
RUN python -m pip install --upgrade pip setuptools wheel && \
    pip install --no-cache-dir -r requirements.txt

# Entrypoint and wait script
COPY scripts/wait_for_mssql_and_init.py /app/scripts/wait_for_mssql_and_init.py
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh && sed -i -e 's/\r$//' /usr/local/bin/entrypoint.sh

# Copy app source
COPY . .

# Static/media folders
RUN mkdir -p /app/staticfiles /app/media

EXPOSE 8000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
