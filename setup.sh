#!/bin/bash

echo "Setting up Car Shop Django Application..."

# Build and start the containers
echo "Building Docker containers..."
docker-compose up --build -d

# Wait for the container to be ready
echo "Waiting for container to be ready..."
sleep 10

# Run migrations
echo "Running database migrations..."
docker-compose exec web python manage.py migrate

# Create superuser
echo "Creating superuser..."
docker-compose exec web python scripts/create_superuser.py

# Populate sample data
echo "Populating sample data..."
docker-compose exec web python scripts/populate_sample_data.py

# Collect static files
echo "Collecting static files..."
docker-compose exec web python manage.py collectstatic --noinput

echo "Setup complete!"
echo "Access the application at: http://localhost:8000"
echo "Access the admin panel at: http://localhost:8000/admin"
echo "Admin credentials: admin / admin123"
