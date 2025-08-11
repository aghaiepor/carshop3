#!/bin/sh
set -e

echo "[entrypoint] Starting..."

# Ensure dirs exist
mkdir -p /app/media /app/staticfiles

# If using MSSQL, wait for it and ensure DB exists
if [ "${DB_ENGINE}" = "mssql" ]; then
  echo "[entrypoint] Waiting for SQL Server and ensuring database exists..."
  python /app/scripts/wait_for_mssql_and_init.py
else
  echo "[entrypoint] DB_ENGINE is '${DB_ENGINE:-}' (not 'mssql'), skipping MSSQL wait."
fi

echo "[entrypoint] Running migrations..."
python manage.py migrate --noinput

echo "[entrypoint] Collecting static..."
python manage.py collectstatic --noinput || true

echo "[entrypoint] Starting server on 0.0.0.0:8000 ..."
exec python manage.py runserver 0.0.0.0:8000
