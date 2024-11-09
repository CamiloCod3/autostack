#!/bin/bash
set -euo pipefail

# Function to log messages
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a /var/log/odoo_setup.log
}

log "Starting Odoo 17 setup..."

# Validate that required environment variables are set by Terraform
if [[ -z "${ADMIN_PASSWD:-}" || -z "${DB_USER:-}" || -z "${DB_PASSWORD:-}" || -z "${DB_HOST:-}" || -z "${NON_ROOT_USER:-}" ]]; then
    log "Error: One or more required environment variables are missing."
    exit 1
fi

# Create the Odoo directory structure
log "Creating Odoo directory structure..."
mkdir -p /opt/odoo17/custom-addons /var/log/odoo17
chown -R "${NON_ROOT_USER}:${NON_ROOT_USER}" /opt/odoo17 /var/log/odoo17

# Clone the Odoo 17 repository
log "Cloning Odoo 17 source code..."
rm -rf /opt/odoo17/odoo # Remove any existing directory to avoid issues
sudo -u "${NON_ROOT_USER}" git clone https://github.com/odoo/odoo --depth 1 --branch 17.0 /opt/odoo17/odoo || {
    log "Failed to clone Odoo repository"
    exit 1
}

# Set up Python virtual environment and install dependencies
log "Setting up Python virtual environment for Python 3.11..."
sudo -u "${NON_ROOT_USER}" python3.11 -m venv /opt/odoo17/venv
sudo -u "${NON_ROOT_USER}" /opt/odoo17/venv/bin/pip install --upgrade pip wheel
sudo -u "${NON_ROOT_USER}" /opt/odoo17/venv/bin/pip install -r /opt/odoo17/odoo/requirements.txt || {
    log "Failed to install Python dependencies"
    exit 1
}

# Create Odoo configuration file
log "Creating Odoo configuration file..."
cat >/etc/odoo17.conf <<EOL
[options]
admin_passwd = ${ADMIN_PASSWD}
db_host = ${DB_HOST}
db_port = ${DB_PORT:-5432}
db_user = ${DB_USER}
db_password = ${DB_PASSWORD}
xmlrpc_port = 8069
logfile = /var/log/odoo17/odoo17.log
addons_path = /opt/odoo17/odoo/addons,/opt/odoo17/custom-addons
EOL

# Test PostgreSQL database connection
log "Testing database connection..."
PGPASSWORD="${DB_PASSWORD}" psql -h "${DB_HOST}" -U "${DB_USER}" -d postgres -c '\l' || {
    log "Failed to connect to the database"
    exit 1
}

# Create systemd service file for Odoo
log "Creating systemd service file for Odoo..."
cat >/etc/systemd/system/odoo17.service <<EOF
[Unit]
Description=Odoo 17
After=network.target postgresql.service

[Service]
Type=simple
User=${NON_ROOT_USER}
ExecStart=/opt/odoo17/venv/bin/python3 /opt/odoo17/odoo/odoo-bin -c /etc/odoo17.conf
StandardOutput=journal+console

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and start Odoo service
log "Enabling and starting Odoo systemd service..."
systemctl daemon-reload
systemctl enable odoo17
systemctl start odoo17

log "Systemd service for Odoo configured and started successfully."
log "Odoo 17 setup completed successfully."
