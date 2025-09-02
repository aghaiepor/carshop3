#!/bin/bash

echo "Generating self-signed SSL certificate for 82.152.98.211..."

# Create SSL directory
mkdir -p ssl

# Generate private key
openssl genrsa -out ssl/server.key 2048

# Generate certificate signing request
openssl req -new -key ssl/server.key -out ssl/server.csr -subj "/C=US/ST=State/L=City/O=Organization/CN=82.152.98.211"

# Generate self-signed certificate
openssl x509 -req -days 365 -in ssl/server.csr -signkey ssl/server.key -out ssl/server.crt

# Set proper permissions
chmod 600 ssl/server.key
chmod 644 ssl/server.crt

# Clean up CSR file
rm ssl/server.csr

echo "SSL certificate generated successfully!"
echo "Certificate: ssl/server.crt"
echo "Private key: ssl/server.key"
