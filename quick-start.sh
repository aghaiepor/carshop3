#!/bin/bash

echo "🚗 DJANGO CAR SHOP - QUICK START"
echo "================================"

# Make scripts executable
chmod +x *.sh

# Check if Docker is working
if ! docker --version >/dev/null 2>&1; then
    echo "❌ Docker not found! Installing..."
    sudo apt update
    sudo apt install docker.io -y
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker $USER
    echo "✅ Docker installed. Please run: newgrp docker"
    echo "Then run this script again."
    exit 1
fi

# Fix Docker Compose issues
if ! docker compose version >/dev/null 2>&1 && ! docker-compose --version >/dev/null 2>&1; then
    echo "🔧 Fixing Docker Compose..."
    ./fix-docker-issues.sh
    echo "Please run: newgrp docker"
    echo "Then run this script again."
    exit 1
fi

# Use simple configuration
echo "📋 Using simple SQLite configuration..."
cp docker-compose.simple.yml docker-compose.yml
cp Dockerfile.simple Dockerfile
cp requirements.simple.txt requirements.txt

# Deploy
echo "🚀 Starting deployment..."
./deploy-simple.sh

echo ""
echo "🎉 DEPLOYMENT COMPLETE!"
echo "======================"
echo "🌐 Open: http://localhost:8000"
echo "👤 Admin: http://localhost:8000/admin"
echo "🔑 Login: admin / admin123"
echo ""
echo "📊 Check logs: docker compose logs -f"
echo "🛑 Stop: docker compose down"
