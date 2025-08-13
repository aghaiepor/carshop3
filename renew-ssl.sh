#!/bin/bash

echo "Renewing SSL certificates..."

# Renew certificates
docker-compose -f docker-compose.prod.yml exec certbot certbot renew --quiet

# Reload nginx to use new certificates
docker-compose -f docker-compose.prod.yml exec nginx nginx -s reload

echo "SSL certificates renewed and nginx reloaded!"
