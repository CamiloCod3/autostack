#!/bin/bash
set -euo pipefail

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a /var/log/system_setup.log
}

log "Starting system setup..."

# Update package lists, add Python 3.11 PPA
log "Updating package lists and adding Python 3.11 PPA..."
apt-get update && add-apt-repository ppa:deadsnakes/ppa -y && apt-get update

# Install system packages and necessary tools
log "Installing required system packages and Python 3.11..."
apt-get install -y sudo openssh-server nginx postgresql-client git \
python3.11 python3.11-venv python3.11-dev python3.11-distutils build-essential wget \
libpq-dev libjpeg-dev zlib1g-dev libxml2-dev libxslt1-dev \
libxslt-dev libzip-dev libldap2-dev libsasl2-dev node-less \
libssl-dev libffi-dev npm xfonts-75dpi xfonts-base certbot python3-certbot-nginx \
software-properties-common unattended-upgrades apt-listchanges

# Restart necessary services
log "Restarting nginx and PostgreSQL..."
systemctl restart nginx || { log "Failed to restart Nginx"; exit 1; }
systemctl restart postgresql || { log "Failed to restart PostgreSQL"; exit 1; }

# Pin Python 3.11 to prevent unwanted upgrades
log "Pinning Python 3.11 version..."
cat <<EOF >/etc/apt/preferences.d/python-pinning
Package: python3.11
Pin: version 3.11*
Pin-Priority: 1001
EOF

# Set Python 3.11 as the default
log "Setting Python 3.11 as default Python version..."
update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1

# Install Wkhtmltopdf (for Odoo PDF generation)
log "Installing Wkhtmltopdf..."
apt-get install -y wkhtmltopdf || {
    log "Warning: Wkhtmltopdf installation failed."
}

# Install DigitalOcean Droplet Agent
log "Installing DigitalOcean Droplet Agent..."
if wget -qO- https://repos-droplet.digitalocean.com/install.sh | sudo bash; then
    log "Droplet Agent installed successfully."
else
    log "Failed to install Droplet Agent."
    exit 1
fi

# Verify that Droplet Agent is running
if systemctl is-active --quiet droplet-agent; then
    log "Droplet Agent is running."
else
    log "Droplet Agent is not running."
    exit 1
fi

# Clean up installation files
log "Cleaning up..."
apt-get clean
apt-get autoremove -y

log "System setup completed successfully."
