#!/bin/bash

echo "🔍 Django Car Shop Server Troubleshooting"
echo "=========================================="
echo ""

# Check if we're on Ubuntu
echo "📋 System Information:"
lsb_release -a 2>/dev/null || echo "Not Ubuntu or lsb_release not available"
echo "IP Address: $(hostname -I | awk '{print $1}')"
echo ""

# Check Docker installation
echo "🐳 Docker Status:"
if command -v docker &> /dev/null; then
    echo "✅ Docker is installed"
    docker --version
    
    if docker info >/dev/null 2>&1; then
        echo "✅ Docker daemon is running"
    else
        echo "❌ Docker daemon is not running"
        echo "Starting Docker..."
        sudo systemctl start docker
        sudo systemctl enable docker
    fi
else
    echo "❌ Docker is not installed"
    echo "Installing Docker..."
    ./install-docker-ubuntu.sh
fi

echo ""

# Check Docker Compose
echo "🔧 Docker Compose Status:"
if command -v docker-compose &> /dev/null; then
    echo "✅ Docker Compose is installed"
    docker-compose --version
else
    echo "❌ Docker Compose is not installed"
fi

echo ""

# Check project files
echo "📁 Project Files:"
if [ -f "docker-compose.prod.yml" ]; then
    echo "✅ docker-compose.prod.yml exists"
else
    echo "❌ docker-compose.prod.yml missing"
fi

if [ -f "Dockerfile" ]; then
    echo "✅ Dockerfile exists"
else
    echo "❌ Dockerfile missing"
fi

if [ -f "requirements.txt" ]; then
    echo "✅ requirements.txt exists"
else
    echo "❌ requirements.txt missing"
fi

echo ""

# Check containers
echo "📦 Container Status:"
docker-compose -f docker-compose.prod.yml ps 2>/dev/null || echo "No containers running"

echo ""

# Check ports
echo "🌐 Port Status:"
echo "Port 80 (HTTP):"
sudo netstat -tlnp | grep :80 || echo "Port 80 not in use"
echo "Port 443 (HTTPS):"
sudo netstat -tlnp | grep :443 || echo "Port 443 not in use"
echo "Port 8000 (Django):"
sudo netstat -tlnp | grep :8000 || echo "Port 8000 not in use"

echo ""

# Check firewall
echo "🔥 Firewall Status:"
sudo ufw status 2>/dev/null || echo "UFW not available"

echo ""

# Check logs if containers exist
echo "📋 Recent Logs:"
if docker-compose -f docker-compose.prod.yml ps | grep -q "Up"; then
    echo "Web container logs:"
    docker-compose -f docker-compose.prod.yml logs --tail=10 web 2>/dev/null || echo "No web logs"
    echo ""
    echo "Nginx container logs:"
    docker-compose -f docker-compose.prod.yml logs --tail=10 nginx 2>/dev/null || echo "No nginx logs"
else
    echo "No containers are running"
fi

echo ""
echo "🚀 Next Steps:"
echo "1. If Docker is not installed: sudo ./install-docker-ubuntu.sh"
echo "2. If files are missing: Make sure you're in the project directory"
echo "3. If containers are down: ./deploy-server-82.sh"
echo "4. If ports are blocked: sudo ufw allow 80 && sudo ufw allow 443"
