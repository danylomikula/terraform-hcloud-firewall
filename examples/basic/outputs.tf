output "firewall_ids" {
  description = "ids of created firewalls"
  value       = module.firewall.firewall_ids
}

output "firewalls" {
  description = "complete firewall resources"
  value       = module.firewall.firewalls
}
