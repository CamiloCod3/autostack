#!/bin/bash
set -euo pipefail

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a /var/log/sensitive_setup.log
}

log "Starting Nginx and Odoo sensitive configuration..."

# Ensure DOMAIN_NAME and SUBDOMAIN_NAME are set via Terraform
if [[ -z "${DOMAIN_NAME:-}" || -z "${SUBDOMAIN_NAME:-}" ]]; then
    log "Error: Domain name or subdomain name is missing."
    exit 1
fi

# Define the NGINX config file path
NGINX_CONF="/etc/nginx/sites-available/odoo.conf"

# Write the Nginx configuration file
log "Setting up Nginx and Odoo configuration..."

cat <<EOF >"$NGINX_CONF"
server {
    listen 443 ssl;
    server_name ${DOMAIN_NAME} ${SUBDOMAIN_NAME};

    ssl_certificate /etc/letsencrypt/live/${DOMAIN_NAME}/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/${DOMAIN_NAME}/privkey.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    ssl_ciphers HIGH:!aNULL:!MD5;

    # Security headers
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
    add_header X-Content-Type-Options "nosniff";
    add_header Referrer-Policy "no-referrer-when-downgrade";

    location / {
        proxy_pass http://localhost:8069;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    location /longpolling {
        proxy_pass http://localhost:8072;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}

server {
    listen 80;
    server_name ${DOMAIN_NAME} ${SUBDOMAIN_NAME};
    return 301 https://\$host\$request_uri;
}
EOF

# Restart Nginx to apply the new configuration
log "Restarting Nginx..."
if ! systemctl restart nginx; then
    log "Error: Failed to restart Nginx"
    exit 1
fi

log "Nginx configuration for Odoo has been updated and applied."
