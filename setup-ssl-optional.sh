#!/bin/bash

echo "Setting up optional SSL certificates for bibonbast.ir..."

# Check if SSL certificates already exist
if [ -f "certbot/conf/live/bibonbast.ir/fullchain.pem" ]; then
    echo "SSL certificates already exist!"
    exit 0
fi

# Generate SSL certificate (optional)
echo "Generating SSL certificate for bibonbast.ir..."
docker-compose -f docker-compose.prod.yml run --rm certbot \
    certbot certonly --webroot --webroot-path /var/www/certbot \
    --email admin@bibonbast.ir \
    --agree-tos --no-eff-email \
    -d bibonbast.ir -d www.bibonbast.ir

if [ $? -eq 0 ]; then
    echo "SSL certificate generated successfully!"
    echo "Restarting nginx to load SSL certificates..."
    docker-compose -f docker-compose.prod.yml restart nginx
    
    # Start certbot for automatic renewal
    docker-compose -f docker-compose.prod.yml up -d certbot
    
    echo "HTTPS is now available at:"
    echo "  🔒 https://bibonbast.ir"
    echo "  🔒 https://www.bibonbast.ir"
else
    echo "SSL certificate generation failed. HTTP will still work."
    echo "You can try again later with: ./setup-ssl-optional.sh"
fi
