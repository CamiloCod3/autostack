variable "droplet_name" {
  description = "The name of the DigitalOcean Droplet"
  type        = string
  default     = "odoo-server-droplet"
}

# Setup Profile
variable "setup_profile" {
  description = "Choose between 'minimal', 'standard', or 'hardcore' setup profiles."
  type        = string
  default     = "standard" # Default value
}

# Project ID for DigitalOcean
variable "project_id" {
  description = "The DigitalOcean Project ID"
  type        = string
}

variable "domain_name" {
  description = "The domain name for the Odoo server"
  type        = string
}

variable "root_domain" {
  description = "The root domain for the Odoo server"
  type        = string
}

variable "subdomain_name" {
  description = "The subdomain name for the Odoo server"
  type        = string
}

variable "ssh_key_id" {
  description = "The SSH key ID to be added to the droplet"
  type        = string
  sensitive   = true
}

# SSH Private Key Path
variable "ssh_private_key_path" {
  description = "Path to the SSH private key file used for accessing the droplet."
  type        = string
  default     = "~/.ssh/odoo1_rsa"
}

variable "ssh_public_key" {
  description = "The SSH public key for server authentication"
  type        = string
  sensitive   = true
}

variable "non_root_user" {
  description = "Non-root user for the server"
  type        = string
  sensitive   = true
  default     = "admin" # Default non-root user
}

variable "non_root_password" {
  description = "Password for the non-root user"
  type        = string
  sensitive   = true
}

variable "db_host" {
  description = "Database host for the Odoo instance"
  type        = string
  sensitive   = true
}

variable "root_password" {
  description = "Root password for the database"
  type        = string
  sensitive   = true
}

variable "admin_passwd" {
  description = "Admin password for Odoo"
  type        = string
  sensitive   = true
}

variable "db_user" {
  description = "Database user for Odoo"
  type        = string
}

variable "db_password" {
  description = "Database password for Odoo"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID for DNS records"
  type        = string
}

variable "dns_ttl" {
  description = "The TTL value for DNS records"
  type        = number
  default     = 3600
}

variable "digitalocean_token" {
  description = "The API token for DigitalOcean"
  type        = string
  sensitive   = true
}

variable "cloudflare_api_token" {
  description = "The API token for Cloudflare"
  type        = string
  sensitive   = true
}

variable "specific_ip" {
  description = "The IP address to allow in the UFW firewall."
  type        = string
  sensitive   = true
}


# Profile-based dynamic configurations using locals
locals {
  droplet_size = (
    var.setup_profile == "minimal" ? "s-1vcpu-1gb" :
    var.setup_profile == "standard" ? "s-1vcpu-2gb" :
    var.setup_profile == "hardcore" ? "s-4vcpu-8gb" : null
  )

  region = (
    var.setup_profile == "minimal" ? "nyc3" :
    var.setup_profile == "standard" ? "ams3" :
    var.setup_profile == "hardcore" ? "sfo3" : null
  )

  swap_size = (
    var.setup_profile == "minimal" ? "1G" :
    var.setup_profile == "standard" ? "2G" :
    var.setup_profile == "hardcore" ? "4G" : null
  )
}
