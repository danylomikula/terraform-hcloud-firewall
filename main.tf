locals {
  # Merge common and per-firewall configurations.
  firewalls_config = {
    for key, firewall in var.firewalls : key => {
      name   = coalesce(firewall.name, key)
      labels = merge(var.common_labels, firewall.labels)
      rules  = firewall.rules
    }
  }
}

resource "hcloud_firewall" "this" {
  for_each = local.firewalls_config

  name   = each.value.name
  labels = each.value.labels

  dynamic "rule" {
    for_each = each.value.rules
    content {
      direction       = rule.value.direction
      protocol        = rule.value.protocol
      port            = rule.value.port
      source_ips      = rule.value.source_ips
      destination_ips = rule.value.destination_ips
      description     = rule.value.description
    }
  }
}
