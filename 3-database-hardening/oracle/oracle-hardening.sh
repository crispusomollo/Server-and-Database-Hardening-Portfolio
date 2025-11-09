#!/bin/bash
# Oracle Hardening Script - semi-automated for Linux
# Note: Some steps require DBA intervention.

ORACLE_HOME="/opt/oracle/product/19c/dbhome_1"
ORACLE_SID="ORCLCDB"
ADMIN_USER="sys"
ADMIN_PASS="StrongPassword123!"

echo "Starting Oracle DB hardening..."

# 1. Connect as SYSDBA and enforce password for SYS and SYSTEM users
echo "Enforcing strong passwords for SYS and SYSTEM users..."
sqlplus / as sysdba <<EOF
ALTER USER SYS IDENTIFIED BY '${ADMIN_PASS}';
ALTER USER SYSTEM IDENTIFIED BY '${ADMIN_PASS}';
EXIT;
EOF

# 2. Lock or remove default accounts that are not used
echo "Locking default accounts..."
sqlplus / as sysdba <<EOF
ALTER USER DBSNMP ACCOUNT LOCK;
ALTER USER OUTLN ACCOUNT LOCK;
ALTER USER ORDSYS ACCOUNT LOCK;
ALTER USER APEX_PUBLIC_USER ACCOUNT LOCK;
EXIT;
EOF

# 3. Enable auditing (basic example)
echo "Enabling standard auditing..."
sqlplus / as sysdba <<EOF
AUDIT ALL BY SYS;
AUDIT ALL BY SYSTEM;
EXIT;
EOF

# 4. Secure listener configuration (manual step)
echo "Check and secure Oracle listener configuration manually:"
echo "- Edit listener.ora to restrict allowed hosts"
echo "- Consider enabling password or OS authentication"

echo "Oracle hardening completed. Please review manual steps."

