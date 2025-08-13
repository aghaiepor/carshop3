#!/bin/bash

echo "=== Ubuntu Server Car Shop Status Check ==="
echo "Server IP: 192.3.154.52"
echo ""

# Check container status
echo "📦 Container Status:"
docker-compose -f docker-compose.prod.yml ps
echo ""

# Check HTTP redirect (should return 301)
echo "🔄 HTTP Redirect Test:"
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://192.3.154.52 2>/dev/null || echo "Failed")
if [ "$HTTP_STATUS" = "301" ]; then
    echo "✅ HTTP redirects to HTTPS (Status: 301)"
else
    echo "❌ HTTP redirect not working (Status: $HTTP_STATUS)"
fi

# Check HTTPS connectivity
echo ""
echo "🔒 HTTPS Status:"
HTTPS_STATUS=$(curl -s -k -o /dev/null -w "%{http_code}" https://192.3.154.52 2>/dev/null || echo "Failed")
if [ "$HTTPS_STATUS" = "200" ]; then
    echo "✅ HTTPS is working (Status: 200)"
else
    echo "❌ HTTPS not working (Status: $HTTPS_STATUS)"
fi

# Check SSL certificate
echo ""
echo "📜 SSL Certificate Info:"
if [ -f "ssl/server.crt" ]; then
    echo "✅ SSL certificate exists"
    echo "Certificate details:"
    openssl x509 -in ssl/server.crt -text -noout | grep -E "(Subject:|Not Before|Not After)"
else
    echo "❌ SSL certificate not found"
fi

# Check nginx configuration
echo ""
echo "⚙️  Nginx Status:"
NGINX_STATUS=$(docker-compose -f docker-compose.prod.yml exec nginx nginx -t 2>&1 || echo "Failed")
if echo "$NGINX_STATUS" | grep -q "successful"; then
    echo "✅ Nginx configuration is valid"
else
    echo "❌ Nginx configuration has issues"
fi

echo ""
echo "=== Access Information ==="
echo "🌐 Main Site:  https://192.3.154.52"
echo "🔧 Admin Panel: https://192.3.154.52/admin"
echo "👤 Admin Login: admin / admin123"
echo ""
echo "⚠️  Browser Security Warning:"
echo "   Since we're using a self-signed certificate, your browser will show"
echo "   a security warning. Click 'Advanced' → 'Proceed to 192.3.154.52'"
