#!/bin/bash

echo "🔄 Updating configuration for new server IP: 82.152.98.211"

# Stop existing containers
docker-compose -f docker-compose.prod.yml down 2>/dev/null || true

# Remove old SSL certificates
rm -rf ssl/

# Update configurations are already done in the files above
echo "✅ Configuration files updated"

# Deploy to new server
echo "🚀 Deploying to new server..."
chmod +x deploy-server-82.sh
chmod +x check-status-82.sh
./deploy-server-82.sh
