# ------------------------------------------------------------
# Variables for the Odoo Module (passed from root module)
# ------------------------------------------------------------

variable "droplet_name" {
  description = "The name of the DigitalOcean Droplet"
  type        = string
}

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

variable "ssh_public_key" {
  description = "The SSH public key for server authentication"
  type        = string
  sensitive   = true
}

variable "non_root_user" {
  description = "Non-root user for the server"
  type        = string
  sensitive   = true
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

# ------------------------------------------------------------
# Passed from Root Module (region, swap_size, and size)
# ------------------------------------------------------------
variable "region" {
  description = "The region where the Droplet will be deployed."
  type        = string
}

variable "swap_size" {
  description = "The swap size for the Droplet."
  type        = string
}

variable "size" {
  description = "The size of the Droplet to deploy."
  type        = string
}

variable "dns_ttl" {
  description = "The TTL value for DNS records."
  type        = number
}

variable "setup_profile" {
  description = "Choose between 'minimal', 'standard', or 'hardcore' setup profiles."
  type        = string
}

variable "ssh_private_key_path" {
  description = "Path to the SSH private key file used for accessing the droplet."
  type        = string
}

variable "specific_ip" {
  description = "The specific IP for firewall or configuration"
  type        = string
}
