#!/bin/bash
# Master Verification Script for Server & Database Hardening
# Checks automated hardening and provides reminders for manual checks

echo "======================================"
echo " MASTER HARDENING VERIFICATION SCRIPT "
echo "======================================"

# -------------------------
# 1. Ubuntu Server Verification
# -------------------------
echo -e "\n--- Ubuntu Server Verification ---"

# SSH root login
if grep -q "PermitRootLogin no" /etc/ssh/sshd_config; then
    echo "[✔] SSH root login disabled"
else
    echo "[✖] SSH root login still enabled"
fi

# Password authentication
if grep -q "PasswordAuthentication no" /etc/ssh/sshd_config; then
    echo "[✔] SSH password authentication disabled"
else
    echo "[✖] SSH password authentication enabled"
fi

# UFW firewall
UFW_STATUS=$(sudo ufw status | grep Status | awk '{print $2}')
if [ "$UFW_STATUS" == "active" ]; then
    echo "[✔] Firewall is active"
else
    echo "[✖] Firewall is inactive"
fi

# Fail2Ban
if systemctl is-active --quiet fail2ban; then
    echo "[✔] Fail2Ban service is running"
else
    echo "[✖] Fail2Ban service is not running"
fi

# -------------------------
# 2. Web Server Verification
# -------------------------
echo -e "\n--- Web Server Verification ---"

# Nginx
if [ -f /etc/nginx/conf.d/security-headers.conf ]; then
    echo "[✔] Nginx security headers configuration exists"
else
    echo "[✖] Nginx security headers not found"
fi

# Apache
if [ -f /etc/apache2/conf-available/security-headers.conf ]; then
    echo "[✔] Apache security headers configuration exists"
else
    echo "[✖] Apache security headers not found"
fi

# -------------------------
# 3. MySQL Verification
# -------------------------
echo -e "\n--- MySQL Verification ---"
MYSQL_ROOT_PASSWORD="StrongPassword123!"
MYSQL_CHECK=$(mysql -u root -p$MYSQL_ROOT_PASSWORD -e "SELECT User, Host FROM mysql.user;" 2>/dev/null)

if [[ $MYSQL_CHECK == *"root"* ]]; then
    echo "[✔] Root user exists with configured password"
else
    echo "[✖] MySQL root user verification failed"
fi

# -------------------------
# 4. PostgreSQL Verification
# -------------------------
echo -e "\n--- PostgreSQL Verification ---"
PG_VERSION=$(psql -V | awk '{print $3}' | cut -d '.' -f1,2)
PG_CONF="/etc/postgresql/$PG_VERSION/main/postgresql.conf"
PG_HBA="/etc/postgresql/$PG_VERSION/main/pg_hba.conf"

if grep -q "listen_addresses = 'localhost'" $PG_CONF; then
    echo "[✔] PostgreSQL listening on localhost only"
else
    echo "[✖] PostgreSQL may be listening on external addresses"
fi

if grep -q "md5" $PG_HBA || grep -q "scram-sha-256" $PG_HBA; then
    echo "[✔] PostgreSQL authentication configured securely"
else
    echo "[✖] PostgreSQL authentication may not be secure"
fi

# -------------------------
# 5. MongoDB Verification
# -------------------------
echo -e "\n--- MongoDB Verification ---"
MONGO_CONF="/etc/mongod.conf"

if grep -q "authorization: \"enabled\"" $MONGO_CONF; then
    echo "[✔] MongoDB authentication enabled"
else
    echo "[✖] MongoDB authentication not enabled"
fi

if grep -q "bindIp: 127.0.0.1" $MONGO_CONF; then
    echo "[✔] MongoDB bound to localhost only"
else
    echo "[✖] MongoDB may be exposed to network"
fi

# -------------------------
# 6. Oracle Verification
# -------------------------
echo -e "\n--- Oracle Verification ---"
echo "Automated checks limited; please manually verify:"
echo "  - SYS and SYSTEM passwords enforced"
echo "  - Default accounts locked (DBSNMP, OUTLN, ORDSYS, APEX_PUBLIC_USER)"
echo "  - Auditing enabled"
echo "  - Listener configuration secured"

# -------------------------
# 7. SQL Server Verification
# -------------------------
echo -e "\n--- SQL Server Verification ---"
echo "Automated checks limited; please manually verify:"
echo "  - SA password enforced and password policy enabled"
echo "  - Default accounts disabled/renamed"
echo "  - Auditing enabled for sensitive actions"
echo "  - Unused features/services disabled"

echo -e "\n======================================"
echo "Verification complete. Review manual checks for Oracle & SQL Server."
echo "======================================"

