# Basic Example

This example demonstrates how to create a Hetzner Cloud firewall with typical web server rules.

## What it creates

- A firewall named `production-web-firewall` with:
  - **Inbound rules**: SSH (22), HTTP (80), HTTPS (443), ICMP (ping)
  - **Outbound rules**: DNS (53 TCP/UDP), HTTP (80), HTTPS (443), ICMP (ping)
- Labels for organization (`service=web`, `environment=production`, `managed_by=terraform`)

## Usage

```bash
export TF_VAR_hcloud_token="your-api-token"
terraform init
terraform plan
terraform apply
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_hcloud"></a> [hcloud](#requirement\_hcloud) | >= 1.45.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_firewall"></a> [firewall](#module\_firewall) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_hcloud_token"></a> [hcloud\_token](#input\_hcloud\_token) | Hetzner Cloud API token. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_firewall_ids"></a> [firewall\_ids](#output\_firewall\_ids) | ids of created firewalls |
| <a name="output_firewalls"></a> [firewalls](#output\_firewalls) | complete firewall resources |
<!-- END_TF_DOCS -->
