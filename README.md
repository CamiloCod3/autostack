---

# 🚀 Autostack: Automated Server Deployment with Terraform

**Automate Your Server Deployment with Ease**  
Autostack is a powerful, flexible solution for automating server deployment and configuration using Terraform, supported by Bash scripts and Docker. Designed with scalability, security, and efficiency in mind, Autostack is ideal for deploying applications like Odoo on cloud platforms, ensuring reliable infrastructure setup with minimal manual intervention.

## 📁 Project Overview

Autostack leverages **Terraform** for infrastructure automation, **Bash scripts** for seamless configuration, and **Docker** for local testing. Cloudflare is used for DNS management, allowing for efficient handling of domain records. The project automates key aspects of server setup, including SSH security, firewall configuration, Fail2Ban, swap memory allocation, and Nginx with SSL for secure access.

### Project Structure

```bash
.
├── autostack_setup.sh          # Main setup script to initiate configuration
├── docker/
│   ├── docker-compose.yml       # Docker Compose file for local testing
│   ├── Dockerfile               # Dockerfile for setting up a local environment
│   └── entrypoint.sh            # Entrypoint for Docker container setup
├── Getting_Started.md           # Detailed setup and usage instructions
├── main.tf                      # Main Terraform configuration
├── modules/
│   └── odoo/
│       ├── cloud-init.yaml      # Cloud-init configuration for server initialization
│       ├── main.tf              # Module-specific Terraform configuration
│       ├── README.md            # Module-specific README
│       └── setup-scripts/       # Scripts for automated server configuration
│           ├── fail2ban_setup.sh          # Fail2Ban setup for SSH security
│           ├── firewall_setup.sh          # UFW firewall configuration
│           ├── odoo_install.sh            # Odoo installation and setup
│           ├── run_all_setup.sh           # Orchestrator script to run all setup scripts
│           ├── security_updates_setup.sh  # Configures automatic security updates
│           ├── sensitive_files_setup.sh   # Sets up Nginx and SSL for secure access
│           ├── swap_memory_configure.sh   # Configures swap memory
│           ├── system_setup.sh            # Installs system packages and dependencies
│           ├── user_db_setup.sh           # Creates users and configures PostgreSQL
│           └── user_ssh_configure.sh      # Enhances SSH security settings
├── README.md                    # Main project README
└── variables.tf                 # Global variables for Terraform

```

## 🔒 Key Security Features

- **Automated Security Updates**: Keeps the server current with the latest patches.
- **Fail2Ban**: Protects against brute-force attacks on SSH.
- **UFW Firewall**: Controls access with rules for SSH, HTTP, and HTTPS.
- **Enhanced SSH Security**: Configures SSH to run on a custom port with restricted access.
- **SSL-Enabled Nginx**: Ensures secure access to services through Nginx.

## 🌐 Cloudflare DNS Management

Autostack integrates with Cloudflare to manage DNS records for both the root domain and subdomains. This ensures your server remains accessible under a custom domain with automated DNS configurations.

## 🌐 Local Testing with Docker

The **docker/** directory provides Docker configurations to simulate the server environment locally. This allows you to test configurations and scripts before deploying to a cloud environment, helping ensure reliable and consistent results in production.

## 💡 Customization Options

Autostack is highly configurable. You can modify key variables like `region`, `size`, `domain_name`, and more in `variables.tf` or `terraform.tfvars`. This flexibility allows Autostack to be adapted for various applications and environments.

## 🎯 Learning Outcomes

In developing Autostack, I gained experience in:

- **Infrastructure as Code (IaC) with Terraform**: For scalable, consistent infrastructure deployment.
- **Server Security Best Practices**: Implementing UFW, Fail2Ban, automated updates, and SSH security enhancements.
- **Automation with Bash Scripting**: Streamlining server setup and configuration tasks.
- **Local Testing Using Docker**: Creating a reliable testing environment that mimics the production setup.
- **Cloud Infrastructure Management and DNS**: Deploying and managing servers on cloud platforms with Terraform, and managing DNS records with Cloudflare.

## 📖 Documentation

For a full guide on setup and deployment, refer to the [Getting Started](./Getting_Started.md) document, which includes detailed steps on installation, configuration, and execution.

---

**Contributions**: Interested in improving Autostack? Feel free to fork the repository, make changes, and submit a pull request!

--- 