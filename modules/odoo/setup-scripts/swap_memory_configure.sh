#!/bin/bash
set -euo pipefail

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a /var/log/swap_setup.log
}

log "Starting swap setup..."

# Set the swap size from the environment variable passed by Terraform
# Fallback to a default size if not set
SWAP_SIZE="${SWAP_SIZE:-2G}"

log "Allocating swap space of size $SWAP_SIZE..."
fallocate -l "$SWAP_SIZE" /swapfile || {
    log "Failed to create swap file."
    exit 1
}

# Set permissions for the swap file
chmod 600 /swapfile

# Set up the swap space
log "Setting up swap space..."
mkswap /swapfile || {
    log "Failed to set up swap space."
    exit 1
}

# Enable the swap space
log "Enabling swap..."
swapon /swapfile || {
    log "Failed to enable swap space."
    exit 1
}

# Add the swapfile entry to /etc/fstab to make swap permanent
echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab

log "Swap setup completed successfully with $SWAP_SIZE of swap space."
