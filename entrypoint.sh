#!/bin/sh
set -e
set -x

echo "Starting entrypoint..."

mkdir -p /app/media /app/staticfiles

# If using MSSQL, wait until the DB is ready to accept connections
if [ "$DB_ENGINE" = "mssql" ]; then
  echo "Waiting for SQL Server at ${DB_HOST:-sqlserver}:${DB_PORT:-1433} ..."
  python - << 'PYCODE'
import os, time, sys
import pyodbc

host = os.environ.get('DB_HOST', 'sqlserver')
port = os.environ.get('DB_PORT', '1433')
server = f"{host},{port}"
user = os.environ.get('DB_USER', 'sa')
password = os.environ.get('DB_PASSWORD', 'YourStrong!Passw0rd')

conn_str = (
  "DRIVER={ODBC Driver 18 for SQL Server};"
  f"SERVER={server};UID={user};PWD={password};"
  "TrustServerCertificate=Yes;"
)

for i in range(60):
  try:
    with pyodbc.connect(conn_str, timeout=5) as conn:
      print("SQL Server is reachable.")
      break
  except Exception as e:
    print(f"Waiting for SQL Server... ({i+1}/60): {e}")
    time.sleep(2)
else:
  print("SQL Server not reachable after waiting.", file=sys.stderr)
  sys.exit(1)
PYCODE
fi

echo "Running migrations..."
python manage.py migrate --noinput

echo "Collecting static..."
python manage.py collectstatic --noinput || true

echo "Starting server..."
exec python manage.py runserver 0.0.0.0:8000
