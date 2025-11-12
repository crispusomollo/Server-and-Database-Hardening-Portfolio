#!/usr/bin/env bash
#
# verify-all-hardening.sh
# Comprehensive verification for Server & Database Hardening Portfolio
# Exits non-zero on any failure (CI-friendly)

set -euo pipefail
LOG_FILE="./verification-results.log"
echo "===== HARDENING VERIFICATION STARTED $(date) =====" > "$LOG_FILE"

# Track failure state
FAILED=0

# Helper function for section headers
section() {
  echo -e "\n\033[1;34m[+] $1\033[0m"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Helper for checks
check() {
  local desc="$1"
  local cmd="$2"

  echo -ne " • $desc ... "
  if eval "$cmd" &>/dev/null; then
    echo -e "\033[1;32mPASSED\033[0m"
    echo "[OK] $desc" >> "$LOG_FILE"
  else
    echo -e "\033[1;31mFAILED\033[0m"
    echo "[FAIL] $desc" >> "$LOG_FILE"
    FAILED=1
  fi
}

# ----------------------------
# 1. Server Hardening Checks
# ----------------------------
section "Server Hardening Verification"

check "Firewall (UFW) is active" "sudo ufw status | grep -q 'active'"
check "SSH root login disabled" "grep -E '^PermitRootLogin no' /etc/ssh/sshd_config"
check "Password authentication disabled" "grep -E '^PasswordAuthentication no' /etc/ssh/sshd_config"
check "Automatic updates enabled" "systemctl is-enabled unattended-upgrades | grep -q enabled"

# ----------------------------
# 2. Web Server Hardening Checks
# ----------------------------
section "Web Server Hardening Verification"

if command -v nginx >/dev/null 2>&1; then
  check "Nginx config syntax OK" "sudo nginx -t"
  check "Nginx security headers set" "grep -q 'X-Frame-Options' /etc/nginx/nginx.conf"
elif command -v apache2 >/dev/null 2>&1; then
  check "Apache config syntax OK" "sudo apache2ctl configtest"
  check "Apache security headers module loaded" "apache2ctl -M | grep -q headers_module"
else
  echo "No web server detected. Skipping web checks." | tee -a "$LOG_FILE"
fi

# ----------------------------
# 3. Database Hardening Checks
# ----------------------------
section "Database Hardening Verification"

if command -v psql >/dev/null 2>&1; then
  check "PostgreSQL pg_hba.conf uses scram-sha-256" "grep -q 'scram-sha-256' /etc/postgresql/*/main/pg_hba.conf"
fi

if command -v mysql >/dev/null 2>&1; then
  check "MySQL 'secure_file_priv' set" "mysql -e 'SHOW VARIABLES LIKE \"secure_file_priv\";' | grep -q '/'"
fi

if command -v mongod >/dev/null 2>&1; then
  check "MongoDB authorization enabled" "grep -q 'authorization: enabled' /etc/mongod.conf"
fi

# ----------------------------
# 4. Docker Hardening Checks
# ----------------------------
section "Docker Hardening Verification"

if command -v docker >/dev/null 2>&1; then
  check "Docker daemon configured with TLS" "grep -q 'tlsverify' /etc/docker/daemon.json"
  check "User namespace remapping active" "grep -q 'userns-remap' /etc/docker/daemon.json"
else
  echo "Docker not installed. Skipping Docker checks." | tee -a "$LOG_FILE"
fi

# ----------------------------
# 5. Automation Checks
# ----------------------------
section "Automation Verification (Ansible Playbooks)"

if [ -d "./5-automation/playbooks" ]; then
  check "All Ansible playbooks are syntactically valid" "ansible-playbook --syntax-check 5-automation/playbooks/*.yml"
else
  echo "No automation playbooks directory found." | tee -a "$LOG_FILE"
fi

# ----------------------------
# 6. Logging & Alerting Checks
# ----------------------------
section "Logging & Alerting Verification"

check "Fail2Ban service active" "systemctl is-active fail2ban | grep -q active"
check "Syslog service running" "systemctl is-active rsyslog | grep -q active"

# ----------------------------
# Final Report
# ----------------------------
section "Verification Summary"
if [ "$FAILED" -ne 0 ]; then
  echo -e "\033[1;31mSome hardening checks FAILED. Review $LOG_FILE.\033[0m"
  echo "===== HARDENING VERIFICATION FAILED =====" >> "$LOG_FILE"
  exit 1
else
  echo -e "\033[1;32mAll hardening checks PASSED successfully!\033[0m"
  echo "===== HARDENING VERIFICATION COMPLETED SUCCESSFULLY =====" >> "$LOG_FILE"
  exit 0
fi

