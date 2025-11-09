# Oracle Hardening Guide

## 1. 🔐 Listener Hardening
- Set `ADMIN_RESTRICTIONS_LISTENER=ON` in `listener.ora`
- Add a password with `lsnrctl set password`
- Use `tcp.validnode_checking = YES` in `sqlnet.ora` to restrict IPs
```
chmod 600 $ORACLE_HOME/network/admin/listener.ora
lsnrctl reload
```

## 2. 👤 User Hardening
- Lock and expire default accounts:
  ```sql
  ALTER USER SCOTT ACCOUNT LOCK;
  ALTER USER HR ACCOUNT LOCK;
  ALTER USER OE ACCOUNT LOCK;
  ALTER USER SH ACCOUNT LOCK;
  ```
- Check unlocked accounts:
```
SELECT username, account_status FROM dba_users WHERE account_status = 'OPEN';
```

## 3. 🔒 Password Policies
Use profile to enforce limits:
```
ALTER PROFILE DEFAULT LIMIT
  FAILED_LOGIN_ATTEMPTS 5
  PASSWORD_LIFE_TIME 90
  PASSWORD_REUSE_TIME 180
  PASSWORD_LOCK_TIME 1/24;
```

## 4. 📄 Auditing

Enable basic auditing:
```
AUDIT SESSION;
AUDIT SELECT TABLE, INSERT TABLE, UPDATE TABLE, DELETE TABLE BY ACCESS;
```

## 5. ✅ Disable UTL_* Packages (if not used)
```
REVOKE EXECUTE ON UTL_SMTP FROM PUBLIC;
REVOKE EXECUTE ON UTL_HTTP FROM PUBLIC;
```

## 6. 📦 Backup Strategy
Use RMAN or Data Pump with encryption

Store backups off-server (e.g., SFTP)
