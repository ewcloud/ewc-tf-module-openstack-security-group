variable "security_group_name" {
  description = "Name of the security group. Required with security_group_rules; defaults to the predefined_security_group name otherwise"
  type        = string
  default     = null
  validation {
    condition     = var.security_group_name == null ? true : length(trimspace(var.security_group_name)) > 0
    error_message = "Security group name must not be empty."
  }
}

variable "security_group_description" {
  description = "Description of the security group"
  type        = string
  default     = null
}

variable "security_group_rules" {
  description = "List of security group rules for a custom security group. Mutually exclusive with predefined_security_group"
  type = list(object({
    direction        = string
    ether_type       = string
    protocol         = string
    port_range_min   = number
    port_range_max   = number
    remote_ip_prefix = string
  }))
  default = null
}

variable "predefined_security_group" {
  description = "Name of a predefined security group to create. Mutually exclusive with security_group_rules"
  type        = string
  default     = null
  validation {
    condition = var.predefined_security_group == null ? true : contains([
      "ssh", "ssh-https", "ssh-http-https", "nginx-proxy-manager", "eumetcast", "ipa", "htcondor",
    ], var.predefined_security_group)
    error_message = "Predefined security group must be one of: ssh, ssh-https, ssh-http-https, nginx-proxy-manager, eumetcast, ipa, htcondor."
  }
}

variable "federee" {
  description = "EWC federee hosting the deployment. Selects the private subnet CIDR used by the nginx-proxy-manager and ipa predefined security groups"
  type        = string
  default     = "EUMETSAT"
  nullable    = false
  validation {
    condition     = contains(["EUMETSAT", "ECMWF"], var.federee)
    error_message = "Federee must be one of: EUMETSAT, ECMWF."
  }
}

variable "tags" {
  description = "Map of tags to assign to the security group"
  type        = map(string)
  default     = {}
}
