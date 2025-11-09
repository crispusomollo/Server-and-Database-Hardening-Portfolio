import os
from pathlib import Path
import shutil

# Define the project structure and file content
project_structure = {
    "README.md": "# Server & Database Hardening Portfolio Project\n\nThis project demonstrates server and database hardening best practices.\n",
    "LICENSE": "MIT License\n\nCopyright (c) 2025",
    ".gitignore": "*.log\n*.bak\n*.tmp\n.env\n*.swp\n",
    "server/secure-ssh.sh": "#!/bin/bash\n# Secure SSH Configuration\n",
    "server/ufw-setup.sh": "#!/bin/bash\n# Set up UFW firewall rules\n",
    "server/nginx-hardening.md": "# Nginx Hardening Guide\n",
    "server/fail2ban-setup.sh": "#!/bin/bash\n# Install and configure Fail2Ban\n",
    "server/hardening-checklist.md": "# Server Hardening Checklist\n",
    "database/backups-cron.sh": "#!/bin/bash\n# Cron job script for database backups\n",
    "database/postgres/postgres-hardening.md": "# PostgreSQL Hardening Guide\n",
    "database/mysql/mysql-hardening.md": "# MySQL Hardening Guide\n",
    "database/oracle/oracle-hardening.md": "# Oracle Hardening Guide\n",
    "database/oracle/secure-oracle-init.sql": "-- SQL script to lock unused accounts and create limited user\n",
    "database/oracle/audit-settings.sql": "-- SQL to enable auditing in Oracle\n",
    "database/oracle/password-policy.sql": "-- SQL to enforce password policies in Oracle\n",
    "database/oracle/listener.ora.example": "# Example listener.ora file with security settings\n",
    "ansible-playbooks/hardening-playbook.yml": "# Ansible playbook for server and database hardening\n",
}

# Base folder
base_path = Path("server-db-hardening-portfolio")
base_path.mkdir(exist_ok=True)

# Create all files and folders
for relative_path, content in project_structure.items():
    file_path = base_path / relative_path
    file_path.parent.mkdir(parents=True, exist_ok=True)
    with open(file_path, "w") as f:
        f.write(content)

# Zip it
shutil.make_archive(base_path.name, 'zip', base_path)

print("✅ Project folder and ZIP file created!")

