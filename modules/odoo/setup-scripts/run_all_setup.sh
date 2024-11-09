#!/bin/bash
set -euo pipefail

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a /var/log/odoo_setup.log
}

SCRIPT_DIR="/root/setup-scripts"

# Make all scripts executable
chmod +x ${SCRIPT_DIR}/*.sh

# Run scripts in order
log "Starting system setup..."
bash ${SCRIPT_DIR}/system_setup.sh

log "Setting up security updates..."
bash ${SCRIPT_DIR}/security_updates_setup.sh

log "Configuring swap memory..."
bash ${SCRIPT_DIR}/swap_memory_configure.sh

log "Setting up users and database..."
bash ${SCRIPT_DIR}/user_db_setup.sh

log "Configuring SSH..."
bash ${SCRIPT_DIR}/user_ssh_configure.sh

log "Setting up sensitive files and configurations..."
bash ${SCRIPT_DIR}/sensitive_files_setup.sh

log "Configuring Fail2Ban..."
bash ${SCRIPT_DIR}/fail2ban_setup.sh

log "Setting up firewall (UFW)..."
bash ${SCRIPT_DIR}/firewall_setup.sh

log "Setting up Odoo installation..."
bash ${SCRIPT_DIR}/odoo_install.sh

log "All setup scripts completed successfully"

# Cleanup
log "Cleaning up..."
if [ "${REMOVE_SETUP_SCRIPTS:-false}" = "true" ]; then
    rm -rf ${SCRIPT_DIR}
    log "Setup scripts removed"
else
    log "Setup scripts retained"
fi

log "Setup process complete."
