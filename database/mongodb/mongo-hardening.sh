#!/bin/bash
# MongoDB Hardening Script - Ubuntu 22.04

echo "Starting MongoDB hardening..."

# Enable authentication
sudo sed -i '/#security:/a\security:\n  authorization: "enabled"' /etc/mongod.conf

# Bind MongoDB to localhost only
sudo sed -i "s/bindIp: 127.0.0.1/bindIp: 127.0.0.1/" /etc/mongod.conf

sudo systemctl restart mongod

echo "Creating admin user..."
mongo <<EOF
use admin
db.createUser({
  user: "admin",
  pwd: "StrongPassword123!",
  roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
})
EOF

echo "MongoDB hardening complete."

