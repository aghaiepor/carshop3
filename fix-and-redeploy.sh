#!/bin/bash

echo "Fixing and redeploying Car Shop..."

# Stop existing containers
docker-compose -f docker-compose.prod.yml down

# Remove any existing containers and images to ensure clean build
docker-compose -f docker-compose.prod.yml rm -f
docker system prune -f

# Build and start production containers
echo "Building and starting containers with fixed settings..."
docker-compose -f docker-compose.prod.yml up --build -d

# Wait for container to be ready
echo "Waiting for container to be ready..."
sleep 20

# Check if container is running
echo "Checking container status..."
docker-compose -f docker-compose.prod.yml ps

# Create superuser if needed
echo "Creating superuser..."
docker-compose -f docker-compose.prod.yml exec -T web python scripts/create_superuser.py

# Populate sample data if needed
echo "Populating sample data..."
docker-compose -f docker-compose.prod.yml exec -T web python scripts/populate_sample_data.py

echo "Deployment fixed and complete!"
echo "Your site is now available at: http://localhost"
echo "Admin panel: http://localhost/admin"
echo "Admin credentials: admin / admin123"
echo ""
echo "To view logs: docker-compose -f docker-compose.prod.yml logs -f web"
