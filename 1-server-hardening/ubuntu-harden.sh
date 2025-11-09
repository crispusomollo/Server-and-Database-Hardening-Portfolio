#!/bin/bash
# Ubuntu 22.04 Server Hardening Script

echo "Updating system..."
sudo apt update && sudo apt upgrade -y

echo "Disabling unused services..."
SERVICES=("apache2" "cups" "snapd")
for svc in "${SERVICES[@]}"; do
    sudo systemctl disable $svc
    sudo systemctl stop $svc
done

echo "Configuring firewall..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw enable

echo "SSH hardening..."
sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart sshd

echo "Enabling automatic security updates..."
sudo apt install -y unattended-upgrades apt-listchanges
sudo dpkg-reconfigure --priority=low unattended-upgrades

echo "Setting up fail2ban..."
sudo apt install -y fail2ban
sudo systemctl enable --now fail2ban

echo "Server hardening complete."

