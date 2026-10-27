locals {
  any_ipv4 = "0.0.0.0/0"

  # Default private subnet of an EWC tenancy, per federee
  private_subnet_cidr = {
    EUMETSAT = "10.0.0.0/24"
    ECMWF    = "192.168.1.0/24"
  }[var.federee]

  # Common security groups
  predefined_security_groups = {
    ssh = [
      { protocol = "tcp", port = 22, remote_ip_prefix = local.any_ipv4 },
    ]
    ssh-https = [
      { protocol = "tcp", port = 22, remote_ip_prefix = local.any_ipv4 },
      { protocol = "tcp", port = 80, remote_ip_prefix = local.any_ipv4 },
      { protocol = "tcp", port = 443, remote_ip_prefix = local.any_ipv4 },
    ]
    ssh-http-https = [
      { protocol = "tcp", port = 22, remote_ip_prefix = local.any_ipv4 },
      { protocol = "tcp", port = 80, remote_ip_prefix = local.any_ipv4 },
      { protocol = "tcp", port = 443, remote_ip_prefix = local.any_ipv4 },
    ]
    nginx-proxy-manager = [
      { protocol = "tcp", port = 443, remote_ip_prefix = local.private_subnet_cidr },
      { protocol = "tcp", port = 80, remote_ip_prefix = local.private_subnet_cidr },
      { protocol = "tcp", port = 22, remote_ip_prefix = local.private_subnet_cidr },
      { protocol = "tcp", port = 8200, remote_ip_prefix = local.private_subnet_cidr }, # NPM admin frontend
    ]
    eumetcast = [
      { protocol = "udp", port = 2268, remote_ip_prefix = local.any_ipv4 },
      { protocol = "tcp", port = 8500, remote_ip_prefix = local.any_ipv4 },
    ]
    ipa = [
      { protocol = "tcp", port = 443, remote_ip_prefix = local.private_subnet_cidr }, # HTTPS
      { protocol = "tcp", port = 80, remote_ip_prefix = local.private_subnet_cidr },  # HTTP
      { protocol = "tcp", port = 22, remote_ip_prefix = local.any_ipv4 },             # SSH
      { protocol = "tcp", port = 389, remote_ip_prefix = local.private_subnet_cidr }, # LDAP
      { protocol = "tcp", port = 636, remote_ip_prefix = local.private_subnet_cidr }, # LDAPS
      { protocol = "tcp", port = 88, remote_ip_prefix = local.private_subnet_cidr },  # Kerberos auth
      { protocol = "udp", port = 88, remote_ip_prefix = local.private_subnet_cidr },  # Kerberos auth
      { protocol = "tcp", port = 464, remote_ip_prefix = local.private_subnet_cidr }, # Kerberos password change
      { protocol = "udp", port = 464, remote_ip_prefix = local.private_subnet_cidr }, # Kerberos password change
      { protocol = "tcp", port = 53, remote_ip_prefix = local.private_subnet_cidr },  # DNS
      { protocol = "udp", port = 53, remote_ip_prefix = local.private_subnet_cidr },  # DNS
      { protocol = "udp", port = 123, remote_ip_prefix = local.private_subnet_cidr }, # NTP
    ]
    htcondor = [
      { protocol = "tcp", port = 9618, remote_ip_prefix = local.any_ipv4 },
    ]
  }

  security_group_name = var.security_group_name != null ? var.security_group_name : var.predefined_security_group

  security_group_rules = var.predefined_security_group != null ? [
    for rule in local.predefined_security_groups[var.predefined_security_group] : {
      direction        = "ingress"
      ether_type       = "IPv4"
      protocol         = rule.protocol
      port_range_min   = rule.port
      port_range_max   = rule.port
      remote_ip_prefix = rule.remote_ip_prefix
    }
  ] : var.security_group_rules == null ? [] : var.security_group_rules
}
