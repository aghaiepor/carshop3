FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# سیستم موردنیاز برای ODBC
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl gnupg ca-certificates apt-transport-https \
    && rm -rf /var/lib/apt/lists/*

# افزودن مخزن مایکروسافت (Debian 12 برای slim)
RUN set -eux; \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -; \
    curl https://packages.microsoft.com/config/debian/12/prod.list > /etc/apt/sources.list.d/mssql-release.list; \
    apt-get update; \
    ACCEPT_EULA=Y apt-get install -y --no-install-recommends msodbcsql18 unixodbc; \
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
