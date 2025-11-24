variable "firewalls" {
  description = "Map of firewall configurations."
  type = map(object({
    name   = optional(string)
    labels = optional(map(string), {})
    rules = list(object({
      direction       = string
      protocol        = string
      port            = optional(string)
      source_ips      = optional(list(string), [])
      destination_ips = optional(list(string), [])
      description     = optional(string)
    }))
  }))
  default = {}
}

variable "common_labels" {
  description = "Labels to apply to all firewalls."
  type        = map(string)
  default     = {}
}
