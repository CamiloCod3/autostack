#!/bin/bash
set -euo pipefail

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a /var/log/odoo_setup.log
}

log "Starting security updates setup..."

# Update package lists and install necessary packages
log "Updating package lists and installing security packages..."
apt-get update && apt-get install -y unattended-upgrades apt-listchanges

log "Configuring unattended-upgrades for security-only updates..."
distro_id=$(lsb_release -is)
distro_codename=$(lsb_release -cs)

# Enable unattended-upgrades
echo "unattended-upgrades unattended-upgrades/enable_auto_updates boolean true" | debconf-set-selections
dpkg-reconfigure -f noninteractive unattended-upgrades || {
    log "Failed to reconfigure unattended-upgrades"
    exit 1
}

# Configure unattended-upgrades for security-only updates
cat >/etc/apt/apt.conf.d/50unattended-upgrades <<EOL
Unattended-Upgrade::Allowed-Origins {
    "${distro_id}:${distro_codename}-security";
};

Unattended-Upgrade::Automatic-Reboot "true";
Unattended-Upgrade::Automatic-Reboot-Time "03:00";
Unattended-Upgrade::Automatic-Reboot-WithUsers "true";
Unattended-Upgrade::Remove-Unused-Kernel-Packages "true";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
Unattended-Upgrade::Remove-New-Unused-Dependencies "true";
EOL

log "Configuring dpkg to handle conflicts automatically..."
cat >/etc/apt/apt.conf.d/99force-conf <<EOL
Dpkg::Options {
   "--force-confdef";
   "--force-confold";
};
EOL

log "Setting up daily cron job for security updates..."
cat >/etc/cron.daily/apt-security-updates <<EOL
#!/bin/sh
/usr/bin/unattended-upgrade -v
EOL
chmod +x /etc/cron.daily/apt-security-updates

log "Configuring automatic update of package lists..."
echo 'APT::Periodic::Update-Package-Lists "1";' >/etc/apt/apt.conf.d/20auto-upgrades
echo 'APT::Periodic::Unattended-Upgrade "1";' >>/etc/apt/apt.conf.d/20auto-upgrades

log "Security-only updates setup completed."
