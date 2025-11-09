#!/bin/bash

echo "[*] Installing Fail2Ban..."

sudo apt update
sudo apt install -y fail2ban
# apt-get install -y fail2ban

cat <<EOF | sudo tee /etc/fail2ban/jail.local
[sshd]
enabled = true
port = 2222
logpath = /var/log/auth.log
bantime = 600
findtime = 600
maxretry = 5
EOF

sudo systemctl restart fail2ban
sudo systemctl enable fail2ban
