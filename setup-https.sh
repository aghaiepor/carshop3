#!/bin/bash

echo "Setting up HTTPS for bibonbast.ir..."

# Create directories for SSL certificates
mkdir -p certbot/conf
mkdir -p certbot/www

# Stop any existing containers
docker-compose -f docker-compose.prod.yml down

# Start nginx and web services (without SSL first)
echo "Starting services for initial SSL certificate generation..."
docker-compose -f docker-compose.prod.yml up -d web nginx

# Wait for services to be ready
sleep 10

# Generate SSL certificate
echo "Generating SSL certificate for bibonbast.ir..."
docker-compose -f docker-compose.prod.yml run --rm certbot \
    certbot certonly --webroot --webroot-path /var/www/certbot \
    --email admin@bibonbast.ir \
    --agree-tos --no-eff-email \
    -d bibonbast.ir -d www.bibonbast.ir

# Restart nginx to load SSL certificates
echo "Restarting nginx with SSL configuration..."
docker-compose -f docker-compose.prod.yml restart nginx

# Start certbot for automatic renewal
docker-compose -f docker-compose.prod.yml up -d certbot

# Create superuser
echo "Creating superuser..."
sleep 5
docker-compose -f docker-compose.prod.yml exec -T web python scripts/create_superuser.py

# Populate sample data
echo "Populating sample data..."
docker-compose -f docker-compose.prod.yml exec -T web python scripts/populate_sample_data.py

echo "HTTPS setup complete!"
echo ""
echo "Your site is now available with SSL:"
echo "  🔒 https://bibonbast.ir"
echo "  🔒 https://www.bibonbast.ir"
echo "  🔧 https://bibonbast.ir/admin"
echo ""
echo "HTTP requests will automatically redirect to HTTPS"
echo "Admin credentials: admin / admin123"
echo ""
echo "SSL certificate will auto-renew every 12 hours"
echo "To check SSL status: docker-compose -f docker-compose.prod.yml logs nginx"
