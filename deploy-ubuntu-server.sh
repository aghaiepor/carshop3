#!/bin/bash

echo "Deploying Car Shop on Ubuntu Server 192.3.154.52 with HTTPS redirect..."

# Generate SSL certificate
echo "Generating SSL certificate..."
chmod +x generate-ssl-cert.sh
./generate-ssl-cert.sh

# Stop any existing containers
docker-compose -f docker-compose.prod.yml down

# Build and start production containers
echo "Building and starting containers..."
docker-compose -f docker-compose.prod.yml up --build -d

# Wait for containers to be ready
echo "Waiting for containers to be ready..."
sleep 20

# Check container status
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
echo "🌐 Your site is now available at:"
echo "  📱 HTTP:  http://192.3.154.52 (redirects to HTTPS)"
echo "  🔒 HTTPS: https://192.3.154.52"
echo "  🔧 Admin: https://192.3.154.52/admin"
echo ""
echo "⚠️  Note: You'll see a security warning because we're using a self-signed certificate."
echo "   Click 'Advanced' and 'Proceed to 192.3.154.52' to continue."
echo ""
echo "👤 Admin credentials: admin / admin123"
echo ""
echo "📊 To check logs: docker-compose -f docker-compose.prod.yml logs -f"
