#!/bin/bash
set -euo pipefail

# Function for logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $*" | tee -a /var/log/fail2ban_setup.log
}

# Function for logging errors
error_log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $*" | tee -a /var/log/fail2ban_setup.log >&2
}

log "Starting Fail2Ban setup for SSH on port 2222..."

# Install Fail2Ban without checking if it is installed
log "Installing Fail2Ban..."
if ! apt-get update && apt-get install -y fail2ban; then
    error_log "Failed to install Fail2Ban. Aborting setup."
    exit 1
fi

# Create a Fail2Ban configuration for SSH on port 2222
log "Creating Fail2Ban jail for SSH on port 2222..."
cat >/etc/fail2ban/jail.d/custom-ssh.conf <<'EOL'
[sshd]
enabled = true
port = 2222
filter = sshd
logpath = /var/log/auth.log
maxretry = 5
bantime = 3600
findtime = 600
EOL

log "Fail2Ban jail for SSH on port 2222 created."

# Restart Fail2Ban service
log "Restarting Fail2Ban service..."
if systemctl restart fail2ban; then
    log "Successfully restarted Fail2Ban."
else
    error_log "Failed to restart Fail2Ban."
    exit 1
fi

# Check Fail2Ban status
log "Checking Fail2Ban status..."
if fail2ban-client status sshd &>/dev/null; then
    log "Fail2Ban SSH jail is active and running for port 2222."
else
    error_log "Fail2Ban SSH jail failed to start. Please check configuration and logs."
    exit 1
fi

log "Fail2Ban setup for SSH on port 2222 completed successfully."
