#!/usr/bin/env bash
set -euo pipefail

# Defaults if not provided
DB_ENGINE="${DB_ENGINE:-mssql}"
DB_HOST="${DB_HOST:-sqlserver}"
DB_PORT="${DB_PORT:-1433}"
DB_NAME="${DB_NAME:-carshop}"
DB_USER="${DB_USER:-sa}"
DB_PASSWORD="${DB_PASSWORD:-Your@StrongP4ssw0rd}"

echo "[entrypoint] DB_ENGINE=${DB_ENGINE}"

if [ "${DB_ENGINE}" = "mssql" ]; then
  echo "[entrypoint] Waiting for SQL Server and ensuring database exists..."
  python /app/scripts/wait_for_mssql_and_init.py
else
  echo "[entrypoint] Skipping MSSQL wait (DB_ENGINE=${DB_ENGINE})"
fi

echo "[entrypoint] Running migrations..."
python manage.py migrate --noinput

echo "[entrypoint] Collecting static files..."
python manage.py collectstatic --noinput

echo "[entrypoint] Starting dev server on 0.0.0.0:8000"
exec python manage.py runserver 0.0.0.0:8000
