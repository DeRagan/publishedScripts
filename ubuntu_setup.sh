#!/bin/bash

# Update the package list using APT
sudo apt update

# Upgrade all packages with the '-y' flag, which automatically answers yes to prompts
sudo apt upgrade -y

# Install proxmox QEMU guest agent
sudo apt install qemu-guest-agent -y

# Append an SSH public key to the authorized_keys file for SSH access
echo "## SSH Key for aoitsrvmgmt by aoitnetworks.com" | tee -a /home/aoitsrvmgmt/.ssh/authorized_keys
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPoZeXjFs9OefIc76bnWBdylFR2mJh74I3NeiZEw5sy5 aoitsrvmgmt@aoitnetworks" | tee -a /home/aoitsrvmgmt/.ssh/authorized_keys

# Set the correct permissions on the .ssh directory and authorized_keys file
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

# Add an include directive to load additional SSH configuration files in the main SSH configuration
echo "Include /etc/ssh/sshd_config.d/*.conf" | sudo tee -a /etc/ssh/sshd_config

# Remove conflicting files in the sshd_config.d directory
sudo rm /etc/ssh/sshd_config.d/*

# Configure SSH settings to enhance security by disabling root login
echo "ChallengeResponseAuthentication no" | sudo tee -a /etc/ssh/sshd_config.d/disable_root_login.conf
echo "PasswordAuthentication no" | sudo tee -a /etc/ssh/sshd_config.d/disable_root_login.conf
echo "UsePAM no" | sudo tee -a /etc/ssh/sshd_config.d/disable_root_login.conf
echo "PermitRootLogin no" | sudo tee -a /etc/ssh/sshd_config.d/disable_root_login.conf

# Restart the SSH service to apply the changes
sudo systemctl restart ssh
