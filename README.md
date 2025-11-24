# Hetzner Cloud Firewall Terraform Module

[![Release](https://img.shields.io/github/v/release/danylomikula/terraform-hcloud-firewall)](https://github.com/danylomikula/terraform-hcloud-firewall/releases)
[![Pre-Commit](https://github.com/danylomikula/terraform-hcloud-firewall/actions/workflows/pre-commit.yml/badge.svg)](https://github.com/danylomikula/terraform-hcloud-firewall/actions/workflows/pre-commit.yml)
[![License](https://img.shields.io/github/license/danylomikula/terraform-hcloud-firewall)](https://github.com/danylomikula/terraform-hcloud-firewall/blob/main/LICENSE)

Terraform module for managing Hetzner Cloud firewalls with multiple rules.

## Features

- Create multiple firewalls with custom rules
- Support for inbound and outbound rules
- Flexible port and IP restrictions
- Common labels across all firewalls
- Rich outputs for integration

## Quick Start

```hcl
module "firewall" {
  source  = "danylomikula/firewall/hcloud"
  version = "~> 1.0"

  firewalls = {
    web = {
      rules = [
        {
          direction  = "in"
          protocol   = "tcp"
          port       = "22"
          source_ips = ["YOUR_IP/32"]
          description = "allow ssh from my ip"
        },
        {
          direction  = "in"
          protocol   = "tcp"
          port       = "80"
          source_ips = ["0.0.0.0/0", "::/0"]
          description = "allow http from anywhere"
        },
        {
          direction  = "in"
          protocol   = "tcp"
          port       = "443"
          source_ips = ["0.0.0.0/0", "::/0"]
          description = "allow https from anywhere"
        }
      ]
    }
  }
}
```

## Usage with Server Module

```hcl
module "firewall" {
  source  = "danylomikula/firewall/hcloud"
  version = "~> 1.0"

  firewalls = {
    web = {
      rules = [
        {
          direction   = "in"
          protocol    = "tcp"
          port        = "22"
          source_ips  = ["YOUR_IP/32"]
          description = "ssh access"
        },
        {
          direction   = "in"
          protocol    = "tcp"
          port        = "80"
          source_ips  = ["0.0.0.0/0", "::/0"]
          description = "http traffic"
        }
      ]
    }
  }

  common_labels = {
    environment = "production"
    managed_by  = "terraform"
  }
}

module "server" {
  source  = "danylomikula/server/hcloud"
  version = "~> 1.0"

  servers = {
    web-01 = {
      server_type = "cx23"
      location    = "nbg1"
      image       = "ubuntu-24.04"
      ssh_keys    = [var.ssh_key_id]
    }
  }

  common_firewall_ids = [module.firewall.firewall_ids["web"]]
}
```

## Rule Examples

### Allow SSH Only from Specific IP

```hcl
{
  direction   = "in"
  protocol    = "tcp"
  port        = "22"
  source_ips  = ["1.2.3.4/32"]
  description = "ssh from office"
}
```

### Allow HTTP/HTTPS from Anywhere

```hcl
{
  direction   = "in"
  protocol    = "tcp"
  port        = "80"
  source_ips  = ["0.0.0.0/0", "::/0"]
  description = "http traffic"
},
{
  direction   = "in"
  protocol    = "tcp"
  port        = "443"
  source_ips  = ["0.0.0.0/0", "::/0"]
  description = "https traffic"
}
```

### Allow Database Access from Private Network

```hcl
{
  direction   = "in"
  protocol    = "tcp"
  port        = "5432"
  source_ips  = ["10.100.0.0/16"]
  description = "postgres from private network"
}
```

### Allow Port Range

```hcl
{
  direction   = "in"
  protocol    = "tcp"
  port        = "8000-8999"
  source_ips  = ["0.0.0.0/0"]
  description = "application ports"
}
```

### Allow ICMP (Ping)

```hcl
{
  direction   = "in"
  protocol    = "icmp"
  source_ips  = ["0.0.0.0/0", "::/0"]
  description = "allow ping"
}
```

### Outbound Rule

```hcl
{
  direction       = "out"
  protocol        = "tcp"
  port            = "443"
  destination_ips = ["0.0.0.0/0", "::/0"]
  description     = "allow outbound https"
}
```

### Firewall Object Structure

```hcl
{
  name   = string                      # optional, defaults to map key
  labels = map(string)
  rules = list(object({
    direction       = string           # "in" or "out"
    protocol        = string           # "tcp", "udp", "icmp", "esp", "gre"
    port            = string           # port or port range (e.g., "80" or "8000-8999")
    source_ips      = list(string)     # cidr blocks for inbound rules
    destination_ips = list(string)     # cidr blocks for outbound rules
    description     = string           # optional description
  }))
}
```

## Protocol Options

- **tcp**: Transmission Control Protocol
- **udp**: User Datagram Protocol
- **icmp**: Internet Control Message Protocol (for ping)
- **esp**: Encapsulating Security Payload (for VPN)
- **gre**: Generic Routing Encapsulation (for VPN)

## Best Practices

1. **Restrict SSH Access**: Limit SSH (port 22) to known IPs only
2. **Allow ICMP**: Enable ping for monitoring and debugging
3. **Use Descriptions**: Document each rule's purpose
4. **Group by Service**: Create separate firewalls for different services
5. **Use common_labels**: Apply consistent labels for organization
6. **Private Network Traffic**: Allow internal traffic from private network ranges
7. **Default Deny**: Hetzner firewalls deny all traffic by default, explicitly allow what you need

## Important Notes

- Firewalls can be attached to multiple servers
- Rules are stateful (return traffic is automatically allowed)
- Default policy is deny all (whitelist approach)
- Changes to firewall rules apply immediately to all attached servers
- IPv6 should be included in source_ips with `::/0` for public access

## hcloud CLI

**List Firewalls**:
```bash
hcloud firewall list
```

**Describe Firewall**:
```bash
hcloud firewall describe <firewall-id>
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_hcloud"></a> [hcloud](#requirement\_hcloud) | >= 1.45.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_hcloud"></a> [hcloud](#provider\_hcloud) | >= 1.45.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [hcloud_firewall.this](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/firewall) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_common_labels"></a> [common\_labels](#input\_common\_labels) | Labels to apply to all firewalls. | `map(string)` | `{}` | no |
| <a name="input_firewalls"></a> [firewalls](#input\_firewalls) | Map of firewall configurations. | <pre>map(object({<br/>    name   = optional(string)<br/>    labels = optional(map(string), {})<br/>    rules = list(object({<br/>      direction       = string<br/>      protocol        = string<br/>      port            = optional(string)<br/>      source_ips      = optional(list(string), [])<br/>      destination_ips = optional(list(string), [])<br/>      description     = optional(string)<br/>    }))<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_firewall_ids"></a> [firewall\_ids](#output\_firewall\_ids) | Map of firewall names to their IDs. |
| <a name="output_firewalls"></a> [firewalls](#output\_firewalls) | Map of all firewall resources with complete attributes. |
<!-- END_TF_DOCS -->

## Related Modules

| Module | Description | GitHub | Terraform Registry |
|--------|-------------|--------|-------------------|
| **terraform-hcloud-network** | Manage Hetzner Cloud networks and subnets | [GitHub](https://github.com/danylomikula/terraform-hcloud-network) | [Registry](https://registry.terraform.io/modules/danylomikula/network/hcloud) |
| **terraform-hcloud-ssh-key** | Manage Hetzner Cloud SSH keys | [GitHub](https://github.com/danylomikula/terraform-hcloud-ssh-key) | [Registry](https://registry.terraform.io/modules/danylomikula/ssh-key/hcloud) |
| **terraform-hcloud-server** | Manage Hetzner Cloud servers | [GitHub](https://github.com/danylomikula/terraform-hcloud-server) | [Registry](https://registry.terraform.io/modules/danylomikula/server/hcloud) |

## Authors

Module managed by [Danylo Mikula](https://github.com/danylomikula).

## Contributing

Contributions are welcome! Please read the [Contributing Guide](.github/contributing.md) for details on the process and commit conventions.

## License

Apache 2.0 Licensed. See [LICENSE](LICENSE) for full details.
