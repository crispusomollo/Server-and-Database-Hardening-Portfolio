#!/bin/bash
echo "Checking firewall status..."
sudo ufw status

echo "Checking SSH configuration..."
grep -E "PermitRootLogin|PasswordAuthentication" /etc/ssh/sshd_config

echo "Listing active services..."
sudo systemctl list-units --type=service --state=running

