#!/bin/bash
# Apache Hardening Script

echo "Enabling headers module..."
sudo a2enmod headers

echo "Adding security headers..."
sudo tee /etc/apache2/conf-available/security-headers.conf > /dev/null <<EOF
Header always set X-Frame-Options "SAMEORIGIN"
Header always set X-Content-Type-Options "nosniff"
Header always set X-XSS-Protection "1; mode=block"
Header always set Content-Security-Policy "default-src 'self'"
EOF

sudo a2enconf security-headers
sudo systemctl reload apache2
echo "Apache hardening complete."


