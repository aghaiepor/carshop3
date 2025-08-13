#!/bin/bash

echo "Deploying Car Shop for bibonbast.ir domain..."

# Stop existing containers
docker-compose -f docker-compose.prod.yml down

# Build and start production containers
echo "Building and starting containers for bibonbast.ir..."
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

echo "Deployment complete for bibonbast.ir!"
echo "Your site is now available at:"
echo "  - http://bibonbast.ir"
echo "  - http://www.bibonbast.ir"
echo "Admin panel:"
echo "  - http://bibonbast.ir/admin"
echo "  - http://www.bibonbast.ir/admin"
echo "Admin credentials: admin / admin123"
echo ""
echo "To view logs: docker-compose -f docker-compose.prod.yml logs -f web"
