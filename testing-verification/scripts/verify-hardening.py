#!/usr/bin/env python3
import os

def check_ssh_config():
    with open("/etc/ssh/sshd_config") as f:
        config = f.read()
    if "PermitRootLogin no" in config:
        print("[✔] SSH root login disabled")
    else:
        print("[✖] SSH root login enabled")

def check_firewall():
    status = os.popen("sudo ufw status | grep Status").read()
    if "active" in status:
        print("[✔] Firewall is active")
    else:
        print("[✖] Firewall is inactive")

if __name__ == "__main__":
    check_ssh_config()
    check_firewall()

