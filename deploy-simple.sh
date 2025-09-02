#!/bin/bash

echo "🚀 DEPLOYING DJANGO CAR SHOP"
echo "============================"

# Check if we can use docker compose (new) or docker-compose (old)
if docker compose version >/dev/null 2>&1; then
    COMPOSE_CMD="docker compose"
    echo "✅ Using Docker Compose V2"
elif docker-compose --version >/dev/null 2>&1; then
    COMPOSE_CMD="docker-compose"
    echo "✅ Using Docker Compose V1"
else
    echo "❌ No working docker-compose found!"
    echo "Please run: ./fix-docker-issues.sh"
    exit 1
fi

# Stop any existing containers
echo "1. Stopping existing containers..."
$COMPOSE_CMD down 2>/dev/null || true

# Clean up old containers and images
echo "2. Cleaning up..."
docker system prune -f

# Build and start services
echo "3. Building and starting services..."
$COMPOSE_CMD up --build -d

# Wait a bit for services to start
echo "4. Waiting for services to start..."
sleep 10

# Check status
echo "5. Checking container status..."
$COMPOSE_CMD ps

# Show logs
echo "6. Recent logs:"
$COMPOSE_CMD logs --tail=20

echo ""
echo "🌐 Your site should be available at:"
echo "   http://localhost:8000"
echo ""
echo "📊 To check logs: $COMPOSE_CMD logs -f"
echo "🛑 To stop: $COMPOSE_CMD down"
