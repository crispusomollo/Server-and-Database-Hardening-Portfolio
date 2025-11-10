## Database Hardening — PostgreSQL, MySQL, MongoDB, Oracle, SQL Server
**Path:** `3-database-hardening/docs/db-hardening.md`

### Overview
This module provides practical hardening steps for PostgreSQL, MySQL (MariaDB-compatible), MongoDB, Oracle, and Microsoft SQL Server. The included scripts automate common tasks where possible; some enterprise DB actions remain manual and must be performed by a DBA.

### Goals
- Enforce strong authentication and password policies
- Use encryption (TLS) for client-server connections
- Restrict network exposure (bind to localhost or private network)
- Remove or lock default/demo accounts and databases
- Enable auditing and logging for sensitive actions

---

### PostgreSQL (recommended)
#### Key config files:
- `/etc/postgresql/<version>/main/postgresql.conf`
- `/etc/postgresql/<version>/main/pg_hba.conf`

#### Recommended settings
- Use `listen_addresses = 'localhost'` (or private interface)
- Enforce `ssl = on` and provide certs
- Use `scram-sha-256` for authentication
- Remove default trust/peer entries for network hosts

#### Example verification
```bash
sudo -u postgres psql -c "SELECT rolname, rolcanlogin FROM pg_roles;"
sudo -u postgres psql -c "SHOW ssl;"
```

### MySQL / MariaDB

#### Recommended steps

- Run mysql_secure_installation or perform equivalent SQL (remove anonymous users, drop test DB, restrict root host)
- Use caching_sha2_password (MySQL 8+) or strong auth plugin
- Set require_secure_transport = ON to force TLS
- Bind to 127.0.0.1 or private interface

#### Verification
```bash
mysql -u root -p -e "SELECT User, Host FROM mysql.user;"
mysql -u root -p -e "SHOW VARIABLES LIKE 'require_secure_transport';"
```

### MongoDB

#### Recommended steps

- Enable authorization: "enabled" in /etc/mongod.conf
- Bind to 127.0.0.1 or VPC private IPs
- Create an admin user and enable TLS for production
- Disable HTTP status interface if exposed

#### Verification
```bash
mongo --eval "db.getUsers()" admin
grep -E "authorization" /etc/mongod.conf
```

### Oracle (high level / DBA tasks)

#### Recommended steps (DBA)

- Enforce strong passwords and profiles
- Lock or remove default accounts (e.g., DBSNMP, OUTLN, APEX_PUBLIC_USER, ORDSYS) if unused
- Enable unified auditing (and ship audit logs to secure storage)
- Secure listener.ora and use OS authentication where appropriate
- Apply Oracle Critical Patch Updates promptly

#### Verification (examples for DBA)

```sql
-- as SYSDBA:
SELECT username, account_status FROM dba_users WHERE username IN ('DBSNMP','OUTLN','APEX_PUBLIC_USER','ORDSYS');
SELECT * FROM unified_audit_trail WHERE action_time > SYSDATE - 7;
SQL Server (high level / DBA tasks)
```

#### Recommended steps (DBA)

- Enforce Windows/SQL strong authentication and password policies
- Disable or rename sa, disable guest where unused
- Enable server-level auditing and track privileged actions
- Remove unused features, disable xp_cmdshell, and harden surface area
- Apply security patches and use secure backups

#### Verification (examples)
```sql
-- via sqlcmd or SSMS
SELECT name, is_policy_checked, is_expiration_checked FROM sys.sql_logins;
EXEC sp_configure 'xp_cmdshell';
```

#### Auditing & Logging (all DBs)

- Centralize DB logs (secure transport) and set retention policies
- Alert on suspicious activities (failed logins, privilege escalations)
- Regularly review audit logs and rotate/archive to secure storage

#### Backup & Recovery

- Ensure backups are encrypted and tested regularly
- Limit restore access to a small number of admins

#### Additional tools

- Use vulnerability scanners (DB-specific) and CIS Benchmarks
- Use MFA for DBA access (where supported)

#### Final verification checklist

- [ ] No anonymous/default accounts
- [ ] Strong password policy in place
- [ ] TLS forced for client connections
- [ ] Audit logging enabled
- [ ] DB accessible only from allowed network ranges

