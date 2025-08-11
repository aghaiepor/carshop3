#!/bin/sh
set -e

echo "Starting entrypoint..."

# Ensure dirs exist
mkdir -p /app/media /app/staticfiles

# If using MSSQL, wait for it and ensure DB exists
if [ "${DB_ENGINE}" = "mssql" ]; then
  echo "Waiting for SQL Server and ensuring database exists..."
  python /app/scripts/wait_for_mssql_and_init.py
fi

echo "Running migrations..."
python manage.py migrate --noinput

echo "Collecting static..."
python manage.py collectstatic --noinput || true

echo "Starting server..."
exec python manage.py runserver 0.0.0.0:8000
