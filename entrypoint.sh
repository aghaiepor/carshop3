#!/bin/sh
set -e
set -x

echo "Starting entrypoint..."

# Ensure dirs exist
mkdir -p /app/media /app/staticfiles

echo "Making migrations (if needed)..."
python manage.py makemigrations cars

echo "Running migrations..."
python manage.py migrate --noinput

echo "Collecting static..."
python manage.py collectstatic --noinput

echo "Starting server..."
exec python manage.py runserver 0.0.0.0:8000
