#!/bin/bash
# MySQL Hardening Script - Ubuntu 22.04

MYSQL_ROOT_PASSWORD="StrongPassword123!"

echo "Starting MySQL hardening..."

sudo systemctl start mysql

# Apply hardening steps
mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY '${MYSQL_ROOT_PASSWORD}';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost','127.0.0.1','::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';
FLUSH PRIVILEGES;
EOF

echo "MySQL hardening complete."
echo "Root password: ${MYSQL_ROOT_PASSWORD}"

