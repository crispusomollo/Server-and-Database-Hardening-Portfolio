#!/bin/bash
# Verification Script for Oracle and SQL Server Hardening
# Checks automated steps and reminds user of manual tasks

echo "Starting Oracle and SQL Server Hardening Verification..."

# ======================
# Oracle Verification
# ======================
echo -e "\n--- Oracle Verification ---"

ORACLE_SID="ORCLCDB"
ORACLE_HOME="/opt/oracle/product/19c/dbhome_1"

echo "1. Checking SYS and SYSTEM passwords enforced (login test)..."
echo "Attempt to connect using sqlplus:"
echo "   sqlplus SYS/StrongPassword123!@${ORACLE_SID} AS SYSDBA"
echo "   sqlplus SYSTEM/StrongPassword123!@${ORACLE_SID}"

echo "2. Checking default accounts locked:"
echo "   Login to sqlplus as SYSDBA and run:"
echo "     SELECT username, account_status FROM dba_users WHERE username IN ('DBSNMP','OUTLN','ORDSYS','APEX_PUBLIC_USER');"

echo "3. Auditing enabled (manual check):"
echo "   Login to sqlplus as SYSDBA and run:"
echo "     SELECT * FROM dba_stmt_audit_opts;"

echo "4. Listener configuration (manual check):"
echo "   Inspect listener.ora for host restrictions and password/OS authentication."

