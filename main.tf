terraform {
  cloud {
    organization = "autolead_team"
    workspaces {
      name = "odoo_terraform"
    }
  }

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

provider "digitalocean" {
  token = var.digitalocean_token
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# Odoo Server Module Configuration
module "odoo_server" {
  source = "./modules/odoo"

  # Providers
  providers = {
    digitalocean = digitalocean
    cloudflare   = cloudflare
  }

  # Variables passed to the module
  specific_ip          = var.specific_ip
  project_id           = var.project_id
  ssh_private_key_path = var.ssh_private_key_path
  setup_profile        = var.setup_profile
  droplet_name         = var.droplet_name
  domain_name          = var.domain_name
  root_domain          = var.root_domain
  subdomain_name       = var.subdomain_name
  ssh_key_id           = var.ssh_key_id
  ssh_public_key       = var.ssh_public_key
  non_root_user        = var.non_root_user
  non_root_password    = var.non_root_password
  db_host              = var.db_host
  root_password        = var.root_password
  admin_passwd         = var.admin_passwd
  db_user              = var.db_user
  db_password          = var.db_password
  cloudflare_zone_id   = var.cloudflare_zone_id
  dns_ttl              = var.dns_ttl

  region    = local.region
  size      = local.droplet_size
  swap_size = local.swap_size
}

# Cloudflare DNS Records for Root Domain
resource "cloudflare_record" "root_record" {
  zone_id = var.cloudflare_zone_id
  name    = var.root_domain
  type    = "A"
  value   = module.odoo_server.odoo_ip
  ttl     = var.dns_ttl

  depends_on = [module.odoo_server]
}

# Cloudflare DNS Records for Subdomain
resource "cloudflare_record" "subdomain_record" {
  zone_id = var.cloudflare_zone_id
  name    = var.subdomain_name
  type    = "A"
  value   = module.odoo_server.odoo_ip
  ttl     = var.dns_ttl

  depends_on = [module.odoo_server]
}

# Outputs
output "odoo_ip" {
  value = module.odoo_server.odoo_ip
}

output "root_domain_record" {
  value = cloudflare_record.root_record.name
}

output "subdomain_record" {
  value = cloudflare_record.subdomain_record.name
}
