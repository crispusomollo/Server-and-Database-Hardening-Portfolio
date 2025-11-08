# PostgreSQL Hardening Guide

This guide outlines security best practices for hardening a PostgreSQL instance.

---

## 1. 🔐 Authentication & Access

### Use `md5` or `scram-sha-256` in `pg_hba.conf`

Edit the file, usually found at:
```
/etc/postgresql/14/main/pg_hba.conf


# Only allow localhost and use strong authentication
host    all             all             127.0.0.1/32            scram-sha-256
host    all             all             ::1/128                 scram-sha-256
```

Restart PostgreSQL after editing:
```
sudo systemctl restart postgresql
```

## 2. 🚫 Disable Remote Access
In postgresql.conf, set:
```
listen_addresses = 'localhost'
```
This ensures PostgreSQL doesn't accept connections from outside the server.

## 3. 👤 Restrict Superuser
Avoid using postgres user directly in applications.

Create a limited user:
```
CREATE USER app_user WITH ENCRYPTED PASSWORD 'StrongPassword123!';
GRANT CONNECT ON DATABASE yourdb TO app_user;
GRANT USAGE ON SCHEMA public TO app_user;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO app_user;
```

## 4. 🔁 Enforce Password Rotation
Use VALID UNTIL to expire passwords:
```
ALTER ROLE app_user VALID UNTIL '2025-12-31';
```

## 5. 🕵️ Enable Logging
Enable query and connection logs in postgresql.conf:
```
logging_collector = on
log_connections = on
log_disconnections = on
log_statement = 'mod'
```

## 6. 🔍 Run Security Check
Use PostgreSQL's pg_audit (optional, advanced):
```
CREATE EXTENSION pgaudit;
```
