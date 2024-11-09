---

## Getting Started with Odoo Server Deployment

This guide provides step-by-step instructions to deploy an Odoo server on **DigitalOcean** using **Terraform** and **Cloudflare** for DNS management.

### Prerequisites

Before you start, ensure you have:

- [Terraform](https://www.terraform.io/downloads.html) installed
- A [DigitalOcean account](https://cloud.digitalocean.com/registrations/new) with an API token
- A [Cloudflare account](https://dash.cloudflare.com/sign-up) with an API token and zone ID for DNS management
- An SSH key pair for secure server access

### Setting Up Your `terraform.tfvars` File

Create a `terraform.tfvars` file in the project directory to securely store sensitive variables. Update the values as needed:

```hcl
# DigitalOcean API token for managing cloud resources
digitalocean_token = "your_digitalocean_api_token"

# Cloudflare credentials for DNS management
cloudflare_api_token = "your_cloudflare_api_token"
cloudflare_zone_id   = "your_cloudflare_zone_id"

# SSH configuration
ssh_key_id           = "your_ssh_key_id"          # ID of your DigitalOcean SSH key
ssh_private_key_path = "~/.ssh/your_private_key"  # Path to your private SSH key
ssh_public_key       = "your_ssh_public_key"      # Public key content
specific_ip          = "your_ip_address"          # IP address allowed for SSH access

# Server and user settings
non_root_user        = "admin"                    # Non-root user for secure access
non_root_password    = "secure_password"          # Password for non-root user
db_host              = "localhost"                # Database host (typically localhost)
root_password        = "secure_root_password"     # Root password for server
admin_passwd         = "secure_odoo_admin_pass"   # Admin password for Odoo

# Database credentials
db_user              = "odoo_db_user"             # Database username for Odoo
db_password          = "secure_db_password"       # Database password

# Cloudflare DNS configuration
root_domain          = "example.com"              # Main domain
subdomain_name       = "subdomain"                # Subdomain for your application

# DigitalOcean project details
project_id           = "your_digitalocean_project_id"
droplet_name         = "your_droplet_name"        # Name for your DigitalOcean Droplet
```

### Deployment Steps

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/CamiloCod3/autostack.git
   cd autostack
   ```

2. **Set Script Permissions**:
   Ensure that the `autostack_setup.sh` script is executable:

   ```bash
   chmod +x autostack_setup.sh
   ```

   > *For Windows users*: Run this script in a **WSL** (Windows Subsystem for Linux) environment or any terminal supporting Bash.

3. **Run the Setup Script**:
   Start the setup with `autostack_setup.sh` to handle the deployment automatically. The script will guide you through selecting a setup profile (`minimal`, `standard`, or `hardcore`) and configuring Terraform for deployment:

   ```bash
   ./autostack_setup.sh
   ```

4. **Verify the Deployment**:
   Once the script completes, it will display the IP address and DNS records for accessing your Odoo server.

5. **To Remove the Setup**:
   Run the following command to tear down the deployment:

   ```bash
   terraform destroy
   ```

### Additional Information

- **DNS Management**: Cloudflare manages DNS for the specified root and subdomains.
- **Security Features**: The setup includes UFW firewall, Fail2Ban, and automated updates to enhance server security.
- **Nginx & SSL**: Configured as a reverse proxy with SSL termination for secure access.
- **Logging**: Setup logs are saved in `/var/log/odoo_setup.log`, with additional service-specific logs.

### Conclusion

Your Odoo server should now be live on a DigitalOcean Droplet, with DNS managed via Cloudflare. The deployment includes essential security and configuration settings, making it suitable for production environments.

--- 
