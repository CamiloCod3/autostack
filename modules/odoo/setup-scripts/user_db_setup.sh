#!/bin/bash
set -euo pipefail

# Log function for output messages
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a /var/log/odoo_setup.log
}

# Create non-root user
create_non_root_user() {
    log "Creating non-root user: ${NON_ROOT_USER}"
    useradd -m -d /opt/"${NON_ROOT_USER}" -s /bin/bash "${NON_ROOT_USER}"
    echo "${NON_ROOT_USER}:${NON_ROOT_PASSWORD}"
    usermod -aG sudo "${NON_ROOT_USER}"
}

# Create PostgreSQL user
create_db_user() {
    log "Creating PostgreSQL user: ${DB_USER}"
    sudo -u postgres psql -c "CREATE USER ${DB_USER} WITH SUPERUSER PASSWORD '${DB_PASSWORD}';"
}

# Set up directories
setup_directories() {
    log "Setting up Odoo directories"
    mkdir -p /opt/odoo17/custom-addons /var/log/odoo17
    chown -R "${NON_ROOT_USER}:${NON_ROOT_USER}" /opt/odoo17 /var/log/odoo17
}

# Main execution
create_non_root_user
create_db_user
setup_directories

log "User and database setup completed"
