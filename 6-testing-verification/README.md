## Testing & Verification (Logging & Alerting)

### Purpose

Automated checks + logging/alerting to detect regressions or misconfigurations.

### Verification strategy

Unit checks — verify each change:

- SSH config

- UFW active

- fail2ban running

- Nginx/Apache headers present

- DB users exist and remote access restricted

- Docker daemon config

**Integration** — run verify-all-hardening.sh to get a summary

**CI / GitHub Actions** — run verification on PRs and pushes


### Logging & alerting:

Centralize logs: rsyslog/Fluentd → ELK/EFK/Graylog

Alerts: use Prometheus + Alertmanager or integrate with existing SIEM

Fail2Ban notifications via email

Auditd rules to capture critical syscalls and file modifications


### Sample audit checks (script examples)

6-testing-verification/scripts/audit-server.sh
```
check open ports: ss -ltnp

check package update status

check permissions for critical files
```

6-testing-verification/scripts/audit-db.sh
```
check DB role listings

verify SSL/settings are enabled
```

**Example logging/alerting entries**

*Syslog* — forward /var/log/auth.log to central collector

*Fail2Ban* — configure action = %(action_mwl)s to send emails with logs

*Prometheus node_exporter + blackbox_exporter* for service availability; alert when service goes down


### Final audit checklist (quick)

 SSH root login disabled

 SSH password auth disabled

 UFW active & minimal open ports

 Fail2Ban installed & active

 Web server: TLS, headers, methods restricted

 DB: no anonymous/test users, strong auth, limited bind address

 Docker: userns, no privileged containers, daemon secured

 Automation: playbooks idempotent and stored in repo

 CI: verification workflow in place

 Logging/Alerting: central logs + alert rules for critical events

### Useful commands & references (quick)

Run master verification:
```
bash 6-testing-verification/scripts/verify-all-hardening.sh
```

**Linting & testing:**

Use shellcheck on bash scripts

Use ansible-lint for playbooks

**Secrets:**

Use *Ansible Vault* or environment secrets in CI (never commit plaintext passwords)
