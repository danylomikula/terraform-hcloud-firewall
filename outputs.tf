output "firewalls" {
  description = "Map of all firewall resources with complete attributes."
  value = {
    for key, firewall in hcloud_firewall.this : key => {
      id     = firewall.id
      name   = firewall.name
      labels = firewall.labels
      rules  = firewall.rule
    }
  }
}

output "firewall_ids" {
  description = "Map of firewall names to their IDs."
  value = {
    for key, firewall in hcloud_firewall.this : key => firewall.id
  }
}
