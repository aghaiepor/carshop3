#!/bin/bash

echo "🔧 Fixing file permissions..."

# Make all shell scripts executable
chmod +x *.sh

# Fix directory permissions
chmod 755 . 2>/dev/null || true
chmod -R 755 cars/ 2>/dev/null || true
chmod -R 755 carshop/ 2>/dev/null || true
chmod -R 755 templates/ 2>/dev/null || true
chmod -R 755 scripts/ 2>/dev/null || true

# Create necessary directories
mkdir -p media staticfiles ssl logs

# Fix media and static permissions
chmod 755 media staticfiles ssl logs 2>/dev/null || true

# Fix SSL permissions if they exist
if [ -f "ssl/server.key" ]; then
    chmod 600 ssl/server.key
fi
if [ -f "ssl/server.crt" ]; then
    chmod 644 ssl/server.crt
fi

echo "✅ Permissions fixed!"
