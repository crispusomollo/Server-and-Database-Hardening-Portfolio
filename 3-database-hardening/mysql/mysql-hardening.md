# MySQL Hardening Guide

A checklist of steps to secure your MySQL or MariaDB server.

---

## 1. 🔐 Run `mysql_secure_installation`

This built-in script helps lock down the server:

```bash
sudo mysql_secure_installation
```

- Set a strong root password

- Remove anonymous users

- Disallow root remote login

- Remove test database

- Reload privilege tables

## 2. 👤 Create Limited Users
Avoid using root or admin in apps.
``
CREATE USER 'app_user'@'localhost' IDENTIFIED BY 'StrongPassword123!';
GRANT SELECT, INSERT, UPDATE ON yourdb.* TO 'app_user'@'localhost';
```

3. 🧱 Restrict Remote Access

In your my.cnf or mysqld.cnf:
``
[mysqld]
bind-address = 127.0.0.1
```

Restart MySQL after changes:
```
sudo systemctl restart mysql
```

## 4. 🔍 Enable Logging
In my.cnf:
```
[mysqld]
log_error = /var/log/mysql/error.log
general_log = 1
general_log_file = /var/log/mysql/mysql.log
```

## 5. 🔁 Enforce Password Policies (MySQL 5.7+)
Enable the password validation plugin:
```
SHOW VARIABLES LIKE 'validate_password%';
```

Set password strength requirements:
```
SET GLOBAL validate_password.policy = MEDIUM;
SET GLOBAL validate_password.length = 12;
```

6. 🔐 Disable LOCAL INFILE (prevents file-based injection)
```
[mysqld]
local-infile=0
```

Then:
```
sudo systemctl restart mysql
```
