# Server & Database Hardening Portfolio

<p align="center">
  <img width="1281" height="716" alt="image" src="https://github.com/user-attachments/assets/646353da-d3fd-4f5b-b402-aeb53821453a" alt="Hardening Portfolio" width="800"/>
</p>

[![Build Status](https://img.shields.io/github/actions/workflow/status/crispusomollo/server-and-db-hardening-portfolio/main.yml?branch=main&label=CI&style=flat-square)](https://github.com/crispusomollo/server-db-hardening-portfolio/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)](LICENSE)
[![Verified Scripts](https://img.shields.io/badge/Verification-Passed-green?style=flat-square)](6-testing-verification/scripts/verify-all-hardening.sh)
[![Python Version](https://img.shields.io/badge/Python-3.11-blue?style=flat-square)](https://www.python.org/)
[![Docker](https://img.shields.io/badge/Docker-Supported-blue?style=flat-square)](https://www.docker.com/)
[![Ansible](https://img.shields.io/badge/automation-Ansible-blue.svg)](#ansible-automation)

This repository demonstrates **comprehensive hardening strategies** for servers, web servers, databases, and Docker environments, with automation and verification scripts included.

---

## Modules

1. **Server Hardening** – Ubuntu 22.04 LTS configuration, SSH, firewall, fail2ban, automatic updates.  
2. **Web Server Hardening** – Nginx/Apache security headers, TLS enforcement, HTTP method restrictions.  
3. **Database Hardening** – PostgreSQL, MySQL, MongoDB, Oracle, SQL Server hardening scripts.  
4. **Docker Hardening** – Restrict privileges, TLS, clean unused containers/images.  
5. **Automation** – Ansible playbooks for repeatable hardening tasks.  
6. **Testing & Verification** – Scripts to verify hardening, logging, and alerting.

---

## Getting Started

1. Clone the repository:

```bash
git clone https://github.com/crispusomollo/Server-and-Database-Hardening-Portfolio.git
cd Server-and-Database-Hardening-Portfolio
```

2. Run any hardening script, for example:

```
bash server-hardening/scripts/ubuntu-harden.sh
```

3. Run verification scripts:

```
bash testing-verification/scripts/verify-all-hardening.sh
```

## Tech Stack

OS: Ubuntu 22.04 LTS

Web Server: Nginx / Apache

Databases: PostgreSQL, MySQL, MongoDB, Oracle, SQL Server

Scripting: Bash, Python, Ansible

Docker (optional)

## Contributing

Feel free to fork, submit PRs, or suggest improvements.
Please follow best practices for security and do not commit sensitive credentials.

## License

This project is licensed under the MIT License – see LICENSE for details.
