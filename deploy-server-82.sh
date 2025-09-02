#!/bin/bash

echo "🚀 Deploying Car Shop on Ubuntu Server 82.152.98.211"
echo "===================================================="

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    echo "❌ Don't run as root. Run as regular user with sudo access."
    exit 1
fi

# Fix permissions first
./fix-permissions.sh

# Check Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker not found. Installing..."
    sudo ./install-docker-ubuntu.sh
    echo "🔄 Please run 'newgrp docker' then run this script again"
    exit 1
fi

if ! docker info >/dev/null 2>&1; then
    echo "🔄 Starting Docker daemon..."
    sudo systemctl start docker
    sudo systemctl enable docker
    sleep 5
fi

# Check Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose not found. Installing..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Open firewall ports
echo "🔥 Opening firewall ports..."
sudo ufw allow 80/tcp 2>/dev/null || true
sudo ufw allow 443/tcp 2>/dev/null || true

# Generate SSL certificate
echo "🔐 Generating SSL certificate..."
mkdir -p ssl
if [ ! -f "ssl/server.crt" ]; then
    openssl genrsa -out ssl/server.key 2048
    openssl req -new -key ssl/server.key -out ssl/server.csr -subj "/C=US/ST=State/L=City/O=Organization/CN=82.152.98.211"
    openssl x509 -req -days 365 -in ssl/server.csr -signkey ssl/server.key -out ssl/server.crt
    chmod 600 ssl/server.key
    chmod 644 ssl/server.crt
    rm ssl/server.csr
    echo "✅ SSL certificate generated"
fi

# Stop existing containers
echo "🛑 Stopping existing containers..."
docker-compose -f docker-compose.prod.yml down 2>/dev/null || true

# Clean up Docker system
echo "🧹 Cleaning Docker system..."
docker system prune -f 2>/dev/null || true

# Build and start containers
echo "🔨 Building and starting containers..."
docker-compose -f docker-compose.prod.yml up --build -d

# Wait for containers
echo "⏳ Waiting for containers to start..."
sleep 30

# Check container status
echo "📊 Container status:"
docker-compose -f docker-compose.prod.yml ps

# Create superuser
echo "👤 Creating superuser..."
docker-compose -f docker-compose.prod.yml exec -T web python scripts/create_superuser.py 2>/dev/null || echo "Superuser creation failed or already exists"

# Populate sample data
echo "📝 Adding sample data..."
docker-compose -f docker-compose.prod.yml exec -T web python scripts/populate_sample_data.py 2>/dev/null || echo "Sample data failed or already exists"

# Test the deployment
echo ""
echo "🧪 Testing deployment..."
sleep 10

HTTP_TEST=$(curl -s -o /dev/null -w "%{http_code}" http://82.152.98.211 2>/dev/null || echo "Failed")
HTTPS_TEST=$(curl -s -k -o /dev/null -w "%{http_code}" https://82.152.98.211 2>/dev/null || echo "Failed")

echo "HTTP Status: $HTTP_TEST"
echo "HTTPS Status: $HTTPS_TEST"

echo ""
echo "🎉 Deployment Complete!"
echo "======================="
echo ""
echo "🌐 Your site URLs:"
echo "   HTTP:  http://82.152.98.211 (redirects to HTTPS)"
echo "   HTTPS: https://82.152.98.211"
echo "   Admin: https://82.152.98.211/admin"
echo ""
echo "👤 Admin Login: admin / admin123"
echo ""
echo "⚠️  Browser Warning: Click 'Advanced' → 'Proceed to 82.152.98.211'"
echo "    (This is normal for self-signed certificates)"
echo ""
echo "🔍 Troubleshoot: ./troubleshoot-server.sh"
echo "📊 Check status: ./check-status-82.sh"
echo "📋 View logs: docker-compose -f docker-compose.prod.yml logs -f"
