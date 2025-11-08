# Server & Database Hardening Portfolio

[![MIT License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Ansible](https://img.shields.io/badge/automation-Ansible-blue.svg)](#ansible-automation)
[![Docker](https://img.shields.io/badge/container-Docker-blue.svg)](#docker-containers)

This project showcases practical server and database hardening techniques, scripts, and automation.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Folder Structure](#folder-structure)
- [Server Hardening](#server-hardening)
- [Database Hardening](#database-hardening)
  - [PostgreSQL](#postgresql)
  - [MySQL](#mysql)
  - [Oracle](#oracle)
- [Automation with Ansible](#automation-with-ansible)
- [Docker Containers for Dev/Test](#docker-containers-for-devtest)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

---

## Project Overview

This portfolio demonstrates security best practices applied to:

- Server: SSH hardening, firewall (UFW), Fail2Ban, Nginx
- Databases: PostgreSQL, MySQL, Oracle
- Backup scripts for databases
- Automation using Ansible
- Development/testing environment with Docker containers

---

## Folder Structure
```
server-db-hardening-portfolio/
├── README.md
├── LICENSE
├── .gitignore
├── server/
├── database/
│ ├── backups-cron.sh
│ ├── postgres/
│ ├── mysql/
│ └── oracle/
├── ansible-playbooks/
└── docker/
```

---

## Server Hardening

Scripts for:

- SSH config (`secure-ssh.sh`)
- UFW firewall setup (`ufw-setup.sh`)
- Fail2Ban (`fail2ban-setup.sh`)
- Nginx hardening notes

---

## Database Hardening

### PostgreSQL

- Authentication & access controls
- Password policies
- Logging
- Backup scripts

### MySQL

- Running `mysql_secure_installation`
- User management
- Bind address restriction
- Password policies
- Backup scripts

### Oracle

- Locking default accounts
- Password profiles
- Auditing settings
- Listener restrictions

---

## Automation with Ansible

Ansible playbook included to automate server and database hardening.

See `ansible-playbooks/hardening-playbook.yml`.

---

## Docker Containers for Dev/Test

Docker Compose setups for PostgreSQL, MySQL, and Oracle XE are included to help replicate the environment quickly.

---

## Usage

1. Clone the repository:

```bash
git clone https://github.com/yourusername/server-db-hardening-portfolio.git
cd server-db-hardening-portfolio
```
2. Run server hardening scripts or use Ansible playbook for automation.

3. Use the backup scripts with cron for daily backups.

4. Start Docker containers for development and testing.

## Contributing
Contributions, issues, and feature requests are welcome!

Please open an issue or submit a pull request.

## License
This project is licensed under the MIT License.



