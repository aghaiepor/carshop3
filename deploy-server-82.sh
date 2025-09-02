#!/bin/bash

echo "🚀 Deploying Car Shop on Ubuntu Server 82.152.98.211 with HTTPS redirect..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please run ./install-docker-ubuntu.sh first"
    exit 1
fi

# Generate SSL certificate for new IP
echo "🔐 Generating SSL certificate for 82.152.98.211..."
mkdir -p ssl
if [ ! -f "ssl/server.crt" ] || ! openssl x509 -in ssl/server.crt -text -noout | grep -q "82.152.98.211"; then
    echo "Generating new SSL certificate..."
    rm -f ssl/server.*
    openssl genrsa -out ssl/server.key 2048
    openssl req -new -key ssl/server.key -out ssl/server.csr -subj "/C=US/ST=State/L=City/O=Organization/CN=82.152.98.211"
    openssl x509 -req -days 365 -in ssl/server.csr -signkey ssl/server.key -out ssl/server.crt
    chmod 600 ssl/server.key
    chmod 644 ssl/server.crt
    rm ssl/server.csr
    echo "✅ SSL certificate generated for 82.152.98.211"
else
    echo "✅ SSL certificate already exists for 82.152.98.211"
fi

# Stop any existing containers
echo "🛑 Stopping existing containers..."
docker-compose -f docker-compose.prod.yml down 2>/dev/null || true

# Build and start production containers
echo "🔨 Building and starting containers..."
docker-compose -f docker-compose.prod.yml up --build -d

# Wait for containers to be ready
echo "⏳ Waiting for containers to be ready..."
sleep 25

# Check container status
echo "📊 Checking container status..."
docker-compose -f docker-compose.prod.yml ps

# Create superuser
echo "👤 Creating superuser..."
docker-compose -f docker-compose.prod.yml exec -T web python scripts/create_superuser.py

# Populate sample data
echo "📝 Populating sample data..."
docker-compose -f docker-compose.prod.yml exec -T web python scripts/populate_sample_data.py

echo ""
echo "🎉 Deployment complete!"
echo ""
echo "🌐 Your site is now available at:"
echo "  📱 HTTP:  http://82.152.98.211 (redirects to HTTPS)"
echo "  🔒 HTTPS: https://82.152.98.211"
echo "  🔧 Admin: https://82.152.98.211/admin"
echo ""
echo "⚠️  Browser Security Warning:"
echo "   You'll see a security warning because we're using a self-signed certificate."
echo "   Click 'Advanced' and 'Proceed to 82.152.98.211' to continue."
echo ""
echo "👤 Admin credentials: admin / admin123"
echo ""
echo "📊 To check logs: docker-compose -f docker-compose.prod.yml logs -f"
echo "🔍 To check status: ./check-status-82.sh"
