#!/bin/bash
set -euo pipefail

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a /var/log/odoo_setup.log
}

log "Starting SSH configuration..."

# Backup the original sshd_config file
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Enhance SSH security
log "Enhancing SSH security..."
sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
echo "AllowUsers ${NON_ROOT_USER}" >>/etc/ssh/sshd_config

# Restart SSH service
log "Restarting SSH service..."
if command -v systemctl &>/dev/null; then
    systemctl enable ssh
    systemctl restart ssh
else
    service ssh restart
fi

# Verify SSH configuration
if sshd -t; then
    log "SSH configuration is valid."
else
    log "Error: SSH configuration is invalid. Rolling back changes..."
    mv /etc/ssh/sshd_config.bak /etc/ssh/sshd_config
    if command -v systemctl &>/dev/null; then
        systemctl restart ssh
    else
        service ssh restart
    fi
    exit 1
fi

log "SSH configuration completed successfully. New settings:"
log "- SSH port changed to 2222"
log "- Root login disabled"
log "- Password authentication disabled"
log "- Only user ${NON_ROOT_USER} is allowed to SSH"
