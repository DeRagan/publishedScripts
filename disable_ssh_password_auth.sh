#!/bin/bash

# SSH Security Configuration Script
# This script enhances the security of your SSH server by configuring important settings.
# Before running this script, make sure you have added your SSH keys to your user account for secure authentication.

# Check if the user is root; the script should be run with sudo.
if [[ $EUID -ne 0 ]]; then
  echo "Please run this script with superuser privileges (sudo)."
  exit 1
fi

# Reminder for the user to add their SSH keys

echo "Before continuing, ensure that you have added your SSH keys for secure authentication."

read -p "Have you added your SSH keys? (y/n): " keys_added

if [ "$keys_added" != "y" ]; then
  echo "Please add your SSH keys before running this script."
  exit 1
fi

# Add an include directive to load additional SSH configuration files
sudo echo -e "Include /etc/ssh/sshd_config.d/*.conf" >> /etc/ssh/sshd_config

# Configure SSH settings to enhance security by disabling root login
sudo echo -e "ChallengeResponseAuthentication no" >> /etc/ssh/sshd_config.d/disable_root_login.conf
sudo echo -e "PasswordAuthentication no" >> /etc/ssh/sshd_config.d/disable_root_login.conf
sudo echo -e "UsePAM no" >> /etc/ssh/sshd_config.d/disable_root_login.conf
sudo echo -e "PermitRootLogin no" >> /etc/ssh/sshd_config.d/disable_root_login.conf

# Restart the SSH service to apply the changes
sudo systemctl restart ssh

echo "SSH security configuration applied. Root login is disabled, password authentication is disabled, and additional settings are included in separate files."
