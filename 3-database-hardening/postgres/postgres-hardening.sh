#!/bin/bash
# PostgreSQL Hardening Script - Ubuntu 22.04

PG_VERSION=$(psql -V | awk '{print $3}' | cut -d '.' -f1,2)
PG_CONF="/etc/postgresql/$PG_VERSION/main/postgresql.conf"
PG_HBA="/etc/postgresql/$PG_VERSION/main/pg_hba.conf"

echo "Starting PostgreSQL hardening..."

# Set strong password for postgres user
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'StrongPassword123!';"

# Restrict listening addresses to localhost
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = 'localhost'/" $PG_CONF

# Enforce SSL connections
sudo sed -i "s/#ssl = off/ssl = on/" $PG_CONF

# Restrict authentication to strong methods
sudo sed -i "s/local\s\+all\s\+all\s\+peer/local all all md5/" $PG_HBA
sudo sed -i "s/host\s\+all\s\+all\s\+127\.0\.0\.1\/32\s\+md5/host all all 127.0.0.1/32 scram-sha-256/" $PG_HBA
sudo sed -i "s/host\s\+all\s\+all\s\+::1\/128\s\+md5/host all all ::1/128 scram-sha-256/" $PG_HBA

sudo systemctl restart postgresql
echo "PostgreSQL hardening complete."

