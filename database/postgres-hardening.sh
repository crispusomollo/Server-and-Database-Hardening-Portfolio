#!/bin/bash
# PostgreSQL Hardening Script

PG_VERSION=$(psql -V | awk '{print $3}' | cut -d '.' -f1,2)

echo "Setting strong password for postgres user..."
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'StrongPassword123!';"

echo "Configuring listen_addresses..."
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = 'localhost'/" /etc/postgresql/$PG_VERSION/main/postgresql.conf

echo "Enforcing SSL connections..."
sudo sed -i "s/#ssl = off/ssl = on/" /etc/postgresql/$PG_VERSION/main/postgresql.conf

sudo systemctl restart postgresql
echo "PostgreSQL hardening complete."

