#!/bin/bash
# Nginx Hardening Script

NGINX_CONF="/etc/nginx/nginx.conf"

echo "Disabling server tokens..."
sudo sed -i 's/server_tokens on;/server_tokens off;/' $NGINX_CONF

echo "Adding security headers..."
sudo tee /etc/nginx/conf.d/security-headers.conf > /dev/null <<EOF
add_header X-Frame-Options "SAMEORIGIN";
add_header X-Content-Type-Options "nosniff";
add_header X-XSS-Protection "1; mode=block";
add_header Content-Security-Policy "default-src 'self'";
EOF

echo "Enforcing strong TLS..."
sudo sed -i 's/ssl_protocols TLSv1 TLSv1.1 TLSv1.2;/ssl_protocols TLSv1.2 TLSv1.3;/' $NGINX_CONF
sudo sed -i 's/ssl_ciphers HIGH:!aNULL:!MD5;/ssl_ciphers ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384;/'

sudo systemctl reload nginx
echo "Nginx hardening complete."

