import os

project_structure = {
    "server-db-hardening-portfolio": {
        "README.md": "# Server & Database Hardening Portfolio Project\n\nThis project demonstrates server and database hardening best practices.\n",
        "LICENSE": "MIT License\n\nCopyright (c) 2025",
        ".gitignore": "*.log\n*.bak\n*.tmp\n.env\n*.swp\n",
        "server": {
            "secure-ssh.sh": "#!/bin/bash\n# Secure SSH Configuration\n",
            "ufw-setup.sh": "#!/bin/bash\n# Set up UFW firewall rules\n",
            "nginx-hardening.md": "# Nginx Hardening Guide\n",
            "fail2ban-setup.sh": "#!/bin/bash\n# Install and configure Fail2Ban\n",
            "hardening-checklist.md": "# Server Hardening Checklist\n",
        },
        "database": {
            "backups-cron.sh": "#!/bin/bash\n# Cron job script for database backups\n",
            "postgres": {
                "postgres-hardening.md": "# PostgreSQL Hardening Guide\n",
            },
            "mysql": {
                "mysql-hardening.md": "# MySQL Hardening Guide\n",
            },
            "oracle": {
                "oracle-hardening.md": "# Oracle Hardening Guide\n",
                "secure-oracle-init.sql": "-- SQL script to lock unused accounts and create limited user\n",
                "audit-settings.sql": "-- SQL to enable auditing in Oracle\n",
                "password-policy.sql": "-- SQL to enforce password policies in Oracle\n",
                "listener.ora.example": "# Example listener.ora file with security settings\n",
            },
        },
        "ansible-playbooks": {
            "hardening-playbook.yml": "# Ansible playbook for server and database hardening\n",
        },
    }
}

def create_structure(base_path, structure):
    for name, content in structure.items():
        path = os.path.join(base_path, name)
        if isinstance(content, dict):
            os.makedirs(path, exist_ok=True)
            create_structure(path, content)
        else:
            with open(path, "w") as f:
                f.write(content)

# Run the function
create_structure(".", project_structure)
print("✅ Project structure created in your current directory.")

