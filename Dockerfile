FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
  PYTHONUNBUFFERED=1

# سیستم موردنیاز برای ODBC
RUN apt-get update && apt-get install -y --no-install-recommends \
  curl gnupg ca-certificates apt-transport-https \
  && rm -rf /var/lib/apt/lists/*

# Add Microsoft package repository using keyrings (Debian 12/bookworm)
RUN set -eux; \
  mkdir -p /etc/apt/keyrings; \
  curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg; \
  chmod 644 /etc/apt/keyrings/microsoft.gpg; \
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/debian/12/prod bookworm main" > /etc/apt/sources.list.d/mssql-release.list; \
  apt-get update; \
  ACCEPT_EULA=Y apt-get install -y --no-install-recommends msodbcsql18 unixodbc unixodbc-dev; \
  rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# نصب entrypoint و اسکریپت انتظار DB
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY scripts/wait_for_mssql_and_init.py /app/scripts/wait_for_mssql_and_init.py
RUN chmod +x /usr/local/bin/entrypoint.sh

# کپی سورس
COPY . .

# مسیرهای استاتیک و مدیا
RUN mkdir -p /app/staticfiles /app/media

EXPOSE 8000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
