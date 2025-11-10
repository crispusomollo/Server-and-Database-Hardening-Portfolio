## Automation — Ansible Playbooks & Usage
**Path:** `5-automation/docs/automation-guide.md`

### Overview
This doc describes how to use the repository’s Ansible playbooks to automate hardening tasks across multiple hosts. It covers inventory setup, running playbooks, vault usage for secrets, and recommended structure.

### Key components
- `ansible/inventory.ini` — host groups and variables
- `ansible/playbooks/server-hardening.yml` — server hardening tasks
- `ansible/playbooks/webserver-hardening.yml` — Nginx/Apache tasks
- `ansible/playbooks/db-hardening.yml` — DB-related tasks (where feasible)

### Prerequisites
- Control machine with Ansible (>= 2.10)
- SSH key-based auth to managed nodes
- `ansible-vault` for secrets (recommended)

### Example inventory
```
[servers]
web1 ansible_host=10.0.1.10 ansible_user=ubuntu
db1 ansible_host=10.0.1.20 ansible_user=ubuntu

[all:vars]
ansible_python_interpreter=/usr/bin/python3
```

## Example usage

1. Lint/playbook syntax:

```bash
ansible-lint ansible/playbooks/server-hardening.yml
ansible-playbook --syntax-check ansible/playbooks/server-hardening.yml
```

2. Run a hardening playbook:

```bash
ansible-playbook -i ansible/inventory.ini ansible/playbooks/server-hardening.yml --ask-become-pass
```

3. Use ansible-vault for secrets:

```bash
ansible-vault create group_vars/all/vault.yml
# Store DB root passwords, TLS passphrases, etc.
```

**Example Playbook Pattern (idempotent)**

Each playbook should:

- Update apt caches
- Install required packages (fail2ban, ufw, etc.)
- Drop/disable unwanted services
- Deploy config templates with template: or copy:
- Restart/reload services


### Safety & rollbacks

- Add --check dry-run when testing
- Use tags to target specific tasks (e.g., --tags ssh)
- Keep host snapshots or backups before mass changes

### Testing automation

- Run playbooks on staging first
- Use Molecule + Docker for unit-testing playbooks (advanced)


**Notes**

Not all DB hardening tasks can be fully automated safely — coordinate with DBAs for Oracle/SQL Server.

