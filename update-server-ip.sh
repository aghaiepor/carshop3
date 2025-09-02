#!/bin/bash

# Script to update server IP to 82.152.98.211
NEW_IP="82.152.98.211"

echo "Updating server configuration for IP: $NEW_IP"

# Update nginx.conf
sed -i "s/server_name [0-9.]*;/server_name $NEW_IP;/g" nginx.conf

# Update docker-compose.prod.yml
sed -i "s/ALLOWED_HOSTS=[^,]*/ALLOWED_HOSTS=$NEW_IP/g" docker-compose.prod.yml

# Update Django settings if needed
sed -i "s/'192\.3\.154\.52'/'$NEW_IP'/g" carshop/settings.py

# Regenerate SSL certificate for new IP
echo "Regenerating SSL certificate for $NEW_IP..."
rm -rf ssl/
mkdir -p ssl
openssl genrsa -out ssl/server.key 2048
openssl req -new -key ssl/server.key -out ssl/server.csr -subj "/C=US/ST=State/L=City/O=Organization/CN=$NEW_IP"
openssl x509 -req -days 365 -in ssl/server.csr -signkey ssl/server.key -out ssl/server.crt
chmod 600 ssl/server.key
chmod 644 ssl/server.crt
rm ssl/server.csr

echo "Configuration updated for IP: $NEW_IP"
echo "Run ./deploy-server-82.sh to apply changes"
