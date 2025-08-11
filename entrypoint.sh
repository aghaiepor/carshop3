#!/usr/bin/env bash
set -euo pipefail

cd /app

if [[ "${DB_ENGINE:-sqlite}" == "mssql" ]]; then
  echo "[entrypoint] Waiting for SQL Server and ensuring database exists..."
  python scripts/wait_for_mssql_and_init.py
fi

echo "[entrypoint] Applying migrations..."
python manage.py migrate --noinput

echo "[entrypoint] Collecting static files..."
python manage.py collectstatic --noinput

echo "[entrypoint] Starting Django development server..."
python manage.py runserver 0.0.0.0:8000
