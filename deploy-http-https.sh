#!/bin/bash

echo "Deploying Car Shop with both HTTP and HTTPS support for bibonbast.ir..."

# Create directories for SSL certificates (optional)
mkdir -p certbot/conf
mkdir -p certbot/www

# Stop any existing containers
docker-compose -f docker-compose.prod.yml down

# Start all services
echo "Starting services with HTTP and HTTPS support..."
docker-compose -f docker-compose.prod.yml up -d

# Wait for services to be ready
sleep 15

# Check if containers are running
echo "Checking container status..."
docker-compose -f docker-compose.prod.yml ps

# Create superuser
echo "Creating superuser..."
docker-compose -f docker-compose.prod.yml exec -T web python scripts/create_superuser.py

# Populate sample data
echo "Populating sample data..."
docker-compose -f docker-compose.prod.yml exec -T web python scripts/populate_sample_data.py

echo "Deployment complete!"
echo ""
echo "Your site is now available on both protocols:"
echo "  🌐 http://bibonbast.ir (HTTP)"
echo "  🌐 http://www.bibonbast.ir (HTTP)"
echo "  🔒 https://bibonbast.ir (HTTPS - if SSL certificates exist)"
echo "  🔒 https://www.bibonbast.ir (HTTPS - if SSL certificates exist)"
echo ""
echo "Admin panels:"
echo "  🔧 http://bibonbast.ir/admin"
echo "  🔧 https://bibonbast.ir/admin (if SSL available)"
echo ""
echo "Admin credentials: admin / admin123"
echo ""
echo "To check logs: docker-compose -f docker-compose.prod.yml logs -f"
