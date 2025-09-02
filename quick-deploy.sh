#!/bin/bash

echo "🚀 Quick Deploy Django Car Shop"
echo "================================"

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    echo "⚠️  Don't run as root. Run as regular user with sudo access."
    exit 1
fi

# Make scripts executable
chmod +x *.sh

# Step 1: Install Docker if needed
if ! command -v docker &> /dev/null; then
    echo "📦 Installing Docker..."
    sudo ./install-docker-ubuntu.sh
    echo "🔄 Refreshing group membership..."
    newgrp docker << EOF
./deploy-server-82.sh
EOF
    exit 0
fi

# Step 2: Check Docker daemon
if ! docker info >/dev/null 2>&1; then
    echo "🔄 Starting Docker daemon..."
    sudo systemctl start docker
    sudo systemctl enable docker
    sleep 5
fi

# Step 3: Open firewall ports
echo "🔥 Opening firewall ports..."
sudo ufw allow 80/tcp 2>/dev/null || true
sudo ufw allow 443/tcp 2>/dev/null || true
sudo ufw allow 22/tcp 2>/dev/null || true

# Step 4: Clean up any existing containers
echo "🧹 Cleaning up existing containers..."
docker-compose -f docker-compose.prod.yml down 2>/dev/null || true
docker system prune -f 2>/dev/null || true

# Step 5: Deploy
echo "🚀 Deploying application..."
./deploy-server-82.sh

echo ""
echo "✅ Quick deploy completed!"
echo "🌐 Check your site at: https://82.152.98.211"
