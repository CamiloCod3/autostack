#!/bin/bash
set -euo pipefail

# Function to display ASCII art
ascii_art() {
    echo " █████╗ ██╗   ██╗████████╗ ██████╗ ███████╗████████╗ █████╗  ██████╗██╗  ██╗"
    echo "██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗██╔════╝╚══██╔══╝██╔══██╗██╔════╝██║ ██╔╝"
    echo "███████║██║   ██║   ██║   ██║   ██║███████╗   ██║   ███████║██║     █████╔╝ "
    echo "██╔══██║██║   ██║   ██║   ██║   ██║╚════██║   ██║   ██╔══██║██║     ██╔═██╗ "
    echo "██║  ██║╚██████╔╝   ██║   ╚██████╔╝███████║   ██║   ██║  ██║╚██████╗██║  ██╗"
    echo "╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝ ╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝"
    echo "=========================================="
    echo "Welcome to the Deployment Setup!"
    echo "----------------------------------------------"
    echo "This script will guide you through setting up"
    echo "your server with Terraform and security features."
    echo "----------------------------------------------"
    echo "Ready? Let's get started! 🚀"
    echo "=========================================="
}

# Function to log messages with timestamp
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

# Function to initialize Terraform
initialize_terraform() {
    log "Initializing Terraform..."
    if ! terraform init -input=false; then
        log "Terraform initialization failed. Please check your configuration."
        exit 1
    fi
}

# Function to run Terraform plan
plan_terraform() {
    log "Running Terraform plan..."
    if ! terraform plan -input=false; then
        log "Terraform plan failed. Please check your configuration."
        exit 1
    fi
}

# Function to apply Terraform changes
apply_terraform() {
    log "Applying Terraform changes..."
    if ! terraform apply -auto-approve -input=false; then
        log "Terraform apply failed. Please check your configuration."
        exit 1
    fi
}

# Prompt user for setup profile choice (minimal, standard, hardcore)
select_setup_profile() {
    log "Select the setup profile:"
    echo "1) Minimal"
    echo "2) Standard"
    echo "3) Hardcore"
    read -r profile_choice

    case $profile_choice in
        1)
            export TF_VAR_setup_profile="minimal"
            log "Setup profile set to Minimal."
        ;;
        2)
            export TF_VAR_setup_profile="standard"
            log "Setup profile set to Standard."
        ;;
        3)
            export TF_VAR_setup_profile="hardcore"
            log "Setup profile set to Hardcore."
        ;;
        *)
            log "Invalid selection. Exiting."
            exit 1
        ;;
    esac
}

# Check if Terraform is installed
check_terraform() {
    if ! command -v terraform &> /dev/null; then
        log "ERROR: Terraform is not installed. Please install Terraform before running this script."
        exit 1
    fi
}

# Validate Terraform configuration
validate_terraform() {
    log "Validating Terraform configuration..."
    terraform validate || { log "Terraform validation failed."; exit 1; }
}

# Format Terraform configuration files
format_terraform() {
    log "Formatting Terraform configuration files..."
    terraform fmt -recursive
}

# Main function to orchestrate the setup
main() {
    ascii_art
    log "Starting Autostack setup script for Terraform..."

    check_terraform
    select_setup_profile
    initialize_terraform
    validate_terraform
    format_terraform
    plan_terraform
    
    log "Do you want to apply the Terraform changes? (y/n)"
    read -r apply_choice
    if [[ $apply_choice == "y" ]]; then
        apply_terraform
    else
        log "Skipping apply phase. You can apply changes later using 'terraform apply'."
    fi

    log "Autostack setup complete for Terraform."
}

# Run the main function
main
