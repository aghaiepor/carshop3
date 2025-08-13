#!/bin/bash

echo "Deploying Car Shop to production..."

# Stop existing containers
docker-compose -f docker-compose.prod.yml down

# Build and start production containers
echo "Building and starting production containers..."
docker-compose -f docker-compose.prod.yml up --build -d

# Wait for container to be ready
echo "Waiting for container to be ready..."
sleep 15

# Create superuser if needed
echo "Creating superuser..."
docker-compose -f docker-compose.prod.yml exec -T web python scripts/create_superuser.py

# Populate sample data if needed
echo "Populating sample data..."
docker-compose -f docker-compose.prod.yml exec -T web python scripts/populate_sample_data.py

echo "Production deployment complete!"
echo "Your site is now available at: http://localhost (port 80)"
echo "Admin panel: http://localhost/admin"
echo "Admin credentials: admin / admin123"
echo ""
echo "To check container status: docker-compose -f docker-compose.prod.yml ps"
echo "To view logs: docker-compose -f docker-compose.prod.yml logs -f web"
