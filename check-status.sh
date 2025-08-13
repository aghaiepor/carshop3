#!/bin/bash

echo "=== Car Shop Status Check ==="
echo ""

# Check container status
echo "📦 Container Status:"
docker-compose -f docker-compose.prod.yml ps
echo ""

# Check HTTP connectivity
echo "🌐 HTTP Status:"
if curl -s -o /dev/null -w "%{http_code}" http://bibonbast.ir | grep -q "200"; then
    echo "✅ HTTP (bibonbast.ir): Working"
else
    echo "❌ HTTP (bibonbast.ir): Not responding"
fi

if curl -s -o /dev/null -w "%{http_code}" http://www.bibonbast.ir | grep -q "200"; then
    echo "✅ HTTP (www.bibonbast.ir): Working"
else
    echo "❌ HTTP (www.bibonbast.ir): Not responding"
fi

# Check HTTPS connectivity
echo ""
echo "🔒 HTTPS Status:"
if curl -s -k -o /dev/null -w "%{http_code}" https://bibonbast.ir 2>/dev/null | grep -q "200"; then
    echo "✅ HTTPS (bibonbast.ir): Working"
else
    echo "❌ HTTPS (bibonbast.ir): Not available or not responding"
fi

if curl -s -k -o /dev/null -w "%{http_code}" https://www.bibonbast.ir 2>/dev/null | grep -q "200"; then
    echo "✅ HTTPS (www.bibonbast.ir): Working"
else
    echo "❌ HTTPS (www.bibonbast.ir): Not available or not responding"
fi

# Check SSL certificate status
echo ""
echo "📜 SSL Certificate Status:"
if [ -f "certbot/conf/live/bibonbast.ir/fullchain.pem" ]; then
    echo "✅ SSL certificates exist"
    docker-compose -f docker-compose.prod.yml exec certbot certbot certificates 2>/dev/null || echo "Certbot not running"
else
    echo "❌ No SSL certificates found"
fi

echo ""
echo "=== Access URLs ==="
echo "🌐 HTTP:  http://bibonbast.ir"
echo "🌐 HTTP:  http://www.bibonbast.ir"
echo "🔒 HTTPS: https://bibonbast.ir (if SSL available)"
echo "🔒 HTTPS: https://www.bibonbast.ir (if SSL available)"
echo "🔧 Admin: http://bibonbast.ir/admin"
