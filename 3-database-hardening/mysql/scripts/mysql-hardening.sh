#!/bin/bash
# MySQL Hardening Script - Ubuntu 22.04
# This script applies standard MySQL security best practices.

MYSQL_ROOT_PASSWORD="StrongPassword123!"

echo "Starting MySQL hardening..."

# Ensure MySQL service is running
sudo systemctl start mysql

# Apply secure installation steps
mysql -u root <<EOF
-- Set root password
ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY '${MYSQL_ROOT_PASSWORD}';
-- Remove anonymous users
DELETE FROM mysql.user WHERE User='';
-- Disallow remote root login
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost','127.0.0.1','::1');
-- Remove test database
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';
-- Reload privilege tables
FLUSH PRIVILEGES;
EOF

# Enforce strong authentication plugin
mysql -u root -p${MYSQL_ROOT_PASSWORD} <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY '${MYSQL_ROOT_PASSWORD}';
EOF

echo "MySQL hardening complete."
echo "Root password: ${MYSQL_ROOT_PASSWORD}"

