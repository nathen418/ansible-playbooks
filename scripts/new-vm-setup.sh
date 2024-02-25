#!/bin/bash

# Install all updates
sudo apt-get update
sudo apt-get upgrade -y

# Automatically remove outdated programs
sudo apt-get autoremove -y

# Install the wazuh agent and connect to the wazuh server
wget https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.6.0-1_amd64.deb && sudo WAZUH_MANAGER='wazuh.comp.playantares.com' dpkg -i ./wazuh-agent_4.6.0-1_amd64.deb
sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent

# Set the timezone
sudo timedatectl set-timezone America/Chicago

# Enable and configure ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
echo "y" | sudo ufw enable

# Add current user to Docker user group
sudo usermod -aG docker $USER

# Disable root SSH
sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config

# Extend ubuntu default fs to fill the disk
sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
sudo resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv
