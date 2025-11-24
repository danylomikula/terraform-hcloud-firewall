# Examples

This directory contains examples demonstrating how to use the Hetzner Cloud Firewall module.

## Available Examples

| Example | Description |
|---------|-------------|
| [basic](./basic/) | Create a firewall with typical web server rules (SSH, HTTP, HTTPS, DNS) |

## Usage

Each example can be run independently:

```bash
cd examples/basic
export TF_VAR_hcloud_token="your-api-token"
terraform init
terraform apply
```
