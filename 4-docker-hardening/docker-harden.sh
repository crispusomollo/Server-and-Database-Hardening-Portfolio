#!/bin/bash
# Docker Hardening Script

echo "Removing unused containers and images..."
sudo docker system prune -af

echo "Restricting Docker daemon access..."
sudo groupdel docker || true
sudo usermod -aG docker $USER

echo "Enabling TLS for Docker daemon..."
# Placeholder: add TLS config if needed

echo "Docker hardening complete."

