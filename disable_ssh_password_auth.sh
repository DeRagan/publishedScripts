#!/bin/bash

# Define the SSH configuration file
SSH_CONFIG_FILE="/etc/ssh/sshd_config"

# Check if the SSH configuration file exists
if [ ! -f "$SSH_CONFIG_FILE" ]; then
  echo "SSH configuration file $SSH_CONFIG_FILE not found."
  exit 1
fi

# Backup the original SSH configuration file
cp "$SSH_CONFIG_FILE" "$SSH_CONFIG_FILE.bak"

# Disable password authentication, enable key-based authentication, and set ChallengeResponseAuthentication to no
sudo sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' "$SSH_CONFIG_FILE"
sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' "$SSH_CONFIG_FILE"
sudo sed -i 's/^PermitRootLogin prohibit-password/PermitRootLogin no/' "$SSH_CONFIG_FILE"
sudo sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/' "$SSH_CONFIG_FILE"
sudo sed -i 's/^ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' "$SSH_CONFIG_FILE"

# Restart the SSH service
sudo systemctl restart ssh

echo "Password SSH access has been disabled, and ChallengeResponseAuthentication is set to no. Only key-based authentication is allowed."

# Clean up the backup file
rm "$SSH_CONFIG_FILE.bak"

exit 0
