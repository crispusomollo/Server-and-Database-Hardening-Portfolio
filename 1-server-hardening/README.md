# Server Hardening — Ubuntu 22.04 LTS
**Path:** `1-server-hardening/docs/server-hardening.md`

## Overview
This document describes recommended server hardening practices for **Ubuntu 22.04 LTS**. It covers package updates, service minimization, SSH hardening, firewall setup with `ufw`, automatic security updates, file system permissions, and intrusion prevention with `fail2ban`.

## Goals
- Minimize attack surface
- Enforce secure remote access (SSH)
- Harden system update & patching process
- Provide repeatable commands and verification steps

## Prerequisites
- Ubuntu 22.04 server with a non-root user that has `sudo` access
- Basic familiarity with `systemd`, `ufw`, and `apt`
- Backups / snapshot before applying changes

## Quick checklist (commands)
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Disable unused services (example)
sudo systemctl disable --now cups snapd avahi-daemon

# Install and enable firewall
sudo apt install -y ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow OpenSSH
sudo ufw enable

# Install and enable fail2ban and unattended upgrades
sudo apt install -y fail2ban unattended-upgrades
sudo systemctl enable --now fail2ban
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

**SSH Hardening (recommended /etc/ssh/sshd_config changes)**

- Disable root login (PermitRootLogin no)

- Disable password authentication if using keys (PasswordAuthentication no)

- Allow only specific users (AllowUsers <your-user>)

- Lower MaxAuthTries, set LoginGraceTime, and set IdleTimeout

- Use PubkeyAuthentication yes and strong keypairs (RSA 4096 / ED25519)


**Example changes:**

```bash

# recommended edits to /etc/ssh/sshd_config
sudo sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/^#PermitEmptyPasswords.*/PermitEmptyPasswords no/' /etc/ssh/sshd_config
# optionally restrict to specific users:
# echo "AllowUsers chris" | sudo tee -a /etc/ssh/sshd_config
sudo systemctl reload sshd
```

**Note:** Before disabling password auth, confirm your SSH key login works.

**Firewall (UFW) guidance**

- Default deny incoming, default allow outgoing
- Allow SSH and any service ports you need (Nginx: 80/443)
- Log suspicious activity:

```bash
sudo ufw logging on
sudo ufw allow 22/tcp    # or 'OpenSSH'
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable
```

**System Updates and Patching**

- Configure unattended-upgrades for security updates
- Keep kernel and packages patched, schedule maintenance for kernel upgrades

**Fail2Ban**

Install and create /etc/fail2ban/jail.local to protect SSH and web services

Example snippet:

```ini
[sshd]
enabled = true
port    = ssh
filter  = sshd
logpath = /var/log/auth.log
maxretry = 5
bantime = 3600
```

Then restart:

```bash
sudo systemctl restart fail2ban
```

**File system & permissions**

- Ensure /etc/ssh/sshd_config is root-owned and not writable by others
- Minimize use of world-writable directories; review SUID/SGID files
- Use auditd for high-sensitivity hosts if required

**Logging & Monitoring**

- Centralize logs (syslog/rsyslog, or remote ELK/Graylog)
- Monitor auth logs for brute force attempts
- Configure retention and secure log archive

## Verification
Run these checks after hardening:

```bash

# SSH
grep -E "PermitRootLogin|PasswordAuthentication" /etc/ssh/sshd_config

# UFW
sudo ufw status verbose

# Fail2Ban
sudo fail2ban-client status sshd

# Update status
sudo unattended-upgrades --dry-run
```

## Rollback strategy

- Keep a snapshot/backup before mass changes
- Keep alternate access (console or cloud provider SSH session) in case of lockout

## References & further reading

- Ubuntu Server Guide (official)
- CIS Benchmarks (Ubuntu 22.04)

fail2ban docs
