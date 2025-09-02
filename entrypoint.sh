#!/bin/sh
set -e

echo "🚀 Starting Django Car Shop..."

# Create necessary directories
mkdir -p /app/media /app/staticfiles

# Wait a moment for any dependencies
sleep 2

echo "📦 Making migrations..."
python manage.py makemigrations cars --noinput || true

echo "🔄 Running migrations..."
python manage.py migrate --noinput

echo "📁 Collecting static files..."
python manage.py collectstatic --noinput --clear

echo "👤 Creating superuser if needed..."
python manage.py shell << EOF
from django.contrib.auth.models import User
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@example.com', 'admin123')
    print('Superuser created: admin/admin123')
else:
    print('Superuser already exists')
EOF

echo "🌟 Starting Django development server..."
exec python manage.py runserver 0.0.0.0:8000
