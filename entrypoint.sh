#!/bin/sh
set -e
set -x

echo "Starting entrypoint..."

# ساخت مسیرها
mkdir -p /app/media /app/staticfiles

# اگر دیتابیس SQL Server است، منتظر آماده شدن و ایجاد DB شو
if [ "${DB_ENGINE}" = "mssql" ]; then
  python /app/scripts/wait_for_mssql_and_init.py
fi

# مایگریشن و استاتیک
python manage.py migrate --noinput || (echo "migrate failed" && exit 1)
python manage.py collectstatic --noinput || true

# اجرای سرور
exec python manage.py runserver 0.0.0.0:8000
