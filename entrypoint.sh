#!/usr/bin/env bash
set -euo pipefail

# Default envs for safety
export DB_ENGINE="${DB_ENGINE:-sqlite}"
export DB_HOST="${DB_HOST:-sqlserver}"
export DB_PORT="${DB_PORT:-1433}"
export DB_NAME="${DB_NAME:-carshop}"
export DB_USER="${DB_USER:-sa}"
export DB_PASSWORD="${DB_PASSWORD:-${SA_PASSWORD:-YourStrong!Passw0rd#2024}}"
export DJANGO_DEBUG="${DJANGO_DEBUG:-1}"

# Wait for MSSQL and create DB if needed
if [ "${DB_ENGINE}" = "mssql" ]; then
  echo "[entrypoint] Waiting for SQL Server at ${DB_HOST}:${DB_PORT} ..."
  python /app/scripts/wait_for_mssql_and_init.py
else
  echo "[entrypoint] Using SQLite (no DB wait)."
fi

echo "[entrypoint] Running migrations..."
python manage.py migrate --noinput

echo "[entrypoint] Collecting static..."
python manage.py collectstatic --noinput

echo "[entrypoint] Starting Django dev server on 0.0.0.0:8000"
exec python manage.py runserver 0.0.0.0:8000
