#!/bin/bash
set -euo pipefail

# Log function for output messages
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [UFW SETUP] $*"
}

log "Starting UFW configuration..."

# Pull values directly from environment variables set via Terraform
log "Specific IP for access: ${SPECIFIC_IP}"
log "Database host: ${DB_HOST}"

log "Allowing custom SSH port 2222..."
ufw allow 2222/tcp

log "Setting default UFW rules (deny incoming, allow outgoing)..."
ufw default deny incoming
ufw default allow outgoing

# Allow HTTP/HTTPS traffic for Cloudflare IP ranges
log "Fetching and allowing Cloudflare IP ranges for ports 80 and 443..."
cloudflare_ips=$(curl -s https://www.cloudflare.com/ips-v4)
for ip in $cloudflare_ips; do
    ufw allow proto tcp from "$ip" to any port 80,443
done

# Allow GitHub IP ranges for certain services
log "Fetching and allowing GitHub IP ranges for ports 80 and 443..."
github_ips=$(curl -s https://api.github.com/meta | jq -r '.actions[]')
for ip in $github_ips; do
    ufw allow proto tcp from "$ip" to any port 80,443
done

# Allow specific IP for SSH, HTTP, and HTTPS
log "Allowing specific IP ${SPECIFIC_IP} for ports 80, 443, and 2222..."
ufw allow from "$SPECIFIC_IP" to any port 80,443,2222

# Allow PostgreSQL traffic if DB_HOST is not local
if [[ "${DB_HOST}" != "localhost" && "${DB_HOST}" != "127.0.0.1" ]]; then
    log "Allowing PostgreSQL traffic from external host ${DB_HOST}..."
    ufw allow from "${DB_HOST}" to any port 5432 || {
        log "Failed to add rule for ${DB_HOST}"
        exit 1
    }
else
    log "Using local PostgreSQL, no external DB_HOST rule needed."
fi

# Set outbound rules
log "Setting outbound rules..."
ufw allow out 80/tcp
ufw allow out 443/tcp
ufw allow out 5432/tcp  # PostgreSQL
ufw allow out 53/udp    # DNS
ufw allow out 123/udp   # NTP (time synchronization)

# Enable UFW
log "Enabling UFW..."
ufw --force enable

# Set UFW logging level to low
log "Setting UFW logging to low..."
ufw logging low

log "UFW setup completed successfully."
