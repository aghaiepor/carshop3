#!/bin/bash

echo "🔧 FIXING DOCKER COMPATIBILITY ISSUES"
echo "====================================="

# Check current versions
echo "1. Current Docker versions:"
docker --version 2>/dev/null || echo "   Docker not found"
docker-compose --version 2>/dev/null || echo "   Docker Compose not found"
echo ""

# Remove old docker-compose
echo "2. Removing old docker-compose..."
sudo apt remove docker-compose -y 2>/dev/null || true
sudo rm -f /usr/bin/docker-compose 2>/dev/null || true
sudo rm -f /usr/local/bin/docker-compose 2>/dev/null || true

# Install Docker Compose V2 (the new way)
echo "3. Installing Docker Compose V2..."
sudo apt update
sudo apt install docker-compose-plugin -y

# Alternative: Install latest docker-compose manually if plugin doesn't work
if ! docker compose version >/dev/null 2>&1; then
    echo "4. Installing docker-compose manually..."
    DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
    sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Start Docker service
echo "5. Starting Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

# Add user to docker group
echo "6. Adding user to docker group..."
sudo usermod -aG docker $USER

echo ""
echo "✅ Docker setup complete!"
echo "📝 Please run: newgrp docker"
echo "📝 Then try: docker compose version"
echo "📝 If that works, run: ./deploy-simple.sh"
