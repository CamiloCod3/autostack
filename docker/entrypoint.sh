#!/bin/bash
set -e

echo "Starting setup process..."

# Run autostack setup script
/root/autostack_setup.sh

# Optionally start SSH if enabled
if [[ "${START_SSH}" == "true" ]]; then
    echo "Starting SSH service..."
    service ssh start
else
    echo "SSH service is disabled by START_SSH=false"
fi

# Start Odoo
echo "Starting Odoo..."
exec su - "${NON_ROOT_USER}" -c "/opt/odoo17/venv/bin/python3 /opt/odoo17/odoo/odoo-bin -c /etc/odoo17.conf"
