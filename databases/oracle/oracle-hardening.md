# Oracle Hardening Guide

## 🔐 Listener Hardening
- Set `ADMIN_RESTRICTIONS_LISTENER=ON` in `listener.ora`
- Add a password with `lsnrctl set password`
- Use `tcp.validnode_checking = YES` in `sqlnet.ora` to restrict IPs

## 👤 User Hardening
- Lock and expire default accounts:
  ```sql
  ALTER USER SCOTT ACCOUNT LOCK;
  ALTER USER HR ACCOUNT LOCK;
  ```
- Check unlocked accounts:

SELECT username, account_status FROM dba_users WHERE account_status = 'OPEN';

## 🔒 Password Policies
Use profile to enforce limits:
```
ALTER PROFILE DEFAULT LIMIT
  FAILED_LOGIN_ATTEMPTS 5
  PASSWORD_LIFE_TIME 90
  PASSWORD_REUSE_TIME 180;
```

## 📄 Auditing

Enable basic auditing:
```
AUDIT SESSION;
AUDIT SELECT TABLE, INSERT TABLE, UPDATE TABLE, DELETE TABLE BY ACCESS;
```

## 📦 Backup Strategy
Use RMAN or Data Pump with encryption

Store backups off-server (e.g., SFTP)
