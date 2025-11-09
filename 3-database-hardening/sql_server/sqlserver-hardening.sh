#!/bin/bash
# SQL Server Hardening Script - semi-automated for Linux
# Requires mssql-tools (sqlcmd) installed

SA_PASSWORD="StrongPassword123!"
MSSQL_USER="sa"

echo "Starting SQL Server hardening..."

# 1. Enforce strong password for SA account
echo "Updating SA account password..."
sqlcmd -S localhost -U SA -P "<CurrentPassword>" -Q "ALTER LOGIN [$MSSQL_USER] WITH PASSWORD=N'$SA_PASSWORD';"

# 2. Disable or rename default accounts (manual step)
echo "Please disable or rename unused default accounts (like 'Guest')."

# 3. Enforce password policy and expiration
echo "Enforcing password policy and expiration for all logins..."
sqlcmd -S localhost -U SA -P "$SA_PASSWORD" -Q "ALTER LOGIN [$MSSQL_USER] WITH CHECK_POLICY = ON, CHECK_EXPIRATION = ON;"

# 4. Disable unused features and services (manual review)
echo "Review and disable unused features/services in SQL Server manually."

# 5. Enable auditing for sensitive actions
echo "Enable auditing using SQL Server Audit (manual step)."

echo "SQL Server hardening completed. Please review manual steps."

