#!/bin/bash

# Install necessary packages
sudo apt update
sudo apt install -y net-tools
# Copy devopsfetch script to /usr/local/bin
sudo cp devopsfetch.sh /usr/local/bin/devopsfetch
sudo chmod +x /usr/local/bin/devopsfetch

# Set up systemd service
sudo cp devopsfetch.service /etc/systemd/system/devopsfetch.service
sudo systemctl enable devopsfetch.service
sudo systemctl start devopsfetch.service

echo "Installation complete. Use 'sudo systemctl status devopsfetch' to check service status."

