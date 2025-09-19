variable "security_group_name" {
  description = "Name of the security group"
  type        = string
  validation {
    condition     = length(var.security_group_name) > 0
    error_message = "Security group name must not be empty."
  }
}

variable "security_group_description" {
  description = "Description of the security group"
  type        = string
  default     = null
}

variable "security_group_rules" {
  description = "List of security group rules"
  type = list(object({
    direction        = string
    ether_type       = string
    protocol         = string
    port_range_min   = number
    port_range_max   = number
    remote_ip_prefix = string
  }))
}

variable "tags" {
  description = "Map of tags to assign to the security group"
  type        = map(string)
  default     = {}
}

