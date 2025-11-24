terraform {
  required_version = ">= 1.5.0"

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.45.0"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

# Create firewall with basic web server rules.
module "firewall" {
  source = "../.."

  firewalls = {
    web = {
      name = "production-web-firewall" # optional, defaults to map key ("web")
      rules = [
        # Inbound rules
        {
          direction   = "in"
          protocol    = "tcp"
          port        = "22"
          source_ips  = ["0.0.0.0/0", "::/0"]
          description = "Allow SSH"
        },
        {
          direction   = "in"
          protocol    = "tcp"
          port        = "80"
          source_ips  = ["0.0.0.0/0", "::/0"]
          description = "Allow HTTP"
        },
        {
          direction   = "in"
          protocol    = "tcp"
          port        = "443"
          source_ips  = ["0.0.0.0/0", "::/0"]
          description = "Allow HTTPS"
        },
        {
          direction   = "in"
          protocol    = "icmp"
          source_ips  = ["0.0.0.0/0", "::/0"]
          description = "Allow ping"
        },
        # Outbound rules
        {
          direction       = "out"
          protocol        = "tcp"
          port            = "53"
          destination_ips = ["0.0.0.0/0", "::/0"]
          description     = "Allow DNS queries"
        },
        {
          direction       = "out"
          protocol        = "udp"
          port            = "53"
          destination_ips = ["0.0.0.0/0", "::/0"]
          description     = "Allow DNS queries (UDP)"
        },
        {
          direction       = "out"
          protocol        = "tcp"
          port            = "80"
          destination_ips = ["0.0.0.0/0", "::/0"]
          description     = "Allow outbound HTTP"
        },
        {
          direction       = "out"
          protocol        = "tcp"
          port            = "443"
          destination_ips = ["0.0.0.0/0", "::/0"]
          description     = "Allow outbound HTTPS"
        },
        {
          direction       = "out"
          protocol        = "icmp"
          destination_ips = ["0.0.0.0/0", "::/0"]
          description     = "Allow outbound ping"
        }
      ]
      labels = {
        service = "web"
      }
    }
  }

  common_labels = {
    environment = "production"
    managed_by  = "terraform"
  }
}
