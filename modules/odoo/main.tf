# ------------------------------------------------------------
# Terraform Provider Configuration for the Odoo Server Module
# ------------------------------------------------------------
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

# ------------------------------------------------------------
# DigitalOcean Droplet Resource Configuration
# ------------------------------------------------------------
resource "digitalocean_droplet" "odoo" {
  name   = var.droplet_name
  region = var.region
  size   = var.size
  image  = "ubuntu-22-04-x64"

  user_data = templatefile("${path.module}/cloud-init.yaml", {
    domain_name       = var.domain_name,
    subdomain_name    = var.subdomain_name,
    non_root_user     = var.non_root_user,
    non_root_password = var.non_root_password,
    admin_passwd      = var.admin_passwd,
    db_host           = var.db_host,
    db_user           = var.db_user,
    root_password     = var.root_password,
    db_password       = var.db_password,
    ssh_public_key    = var.ssh_public_key
    specific_ip       = var.specific_ip
  })

  ssh_keys = [var.ssh_key_id]
}

# ------------------------------------------------------------
# Associate the Droplet with a DigitalOcean Project
# ------------------------------------------------------------
resource "digitalocean_project_resources" "odoo_project" {
  project   = var.project_id
  resources = [digitalocean_droplet.odoo.urn]
}

# ------------------------------------------------------------
# Cloudflare DNS Record Configuration
# ------------------------------------------------------------
resource "cloudflare_record" "root_record" {
  zone_id = var.cloudflare_zone_id
  name    = "@"
  type    = "A"
  value   = digitalocean_droplet.odoo.ipv4_address
  ttl     = var.dns_ttl
}

resource "cloudflare_record" "subdomain_record" {
  zone_id = var.cloudflare_zone_id
  name    = var.subdomain_name
  type    = "A"
  value   = digitalocean_droplet.odoo.ipv4_address
  ttl     = var.dns_ttl
}

# ------------------------------------------------------------
# Output: Odoo Server IP Address
# ------------------------------------------------------------
output "odoo_ip" {
  value = digitalocean_droplet.odoo.ipv4_address
}
