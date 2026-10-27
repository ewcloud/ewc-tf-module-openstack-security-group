resource "openstack_networking_secgroup_v2" "security_group" {
  name        = local.security_group_name
  description = var.security_group_description
  tags        = [for k, v in var.tags : "${k}=${v}"]

  lifecycle {
    precondition {
      condition     = (var.security_group_rules == null) != (var.predefined_security_group == null)
      error_message = "Set exactly one of security_group_rules (custom security group) or predefined_security_group."
    }
    precondition {
      condition     = local.security_group_name != null
      error_message = "security_group_name is required when creating a custom security group with security_group_rules."
    }
  }
}

resource "openstack_networking_secgroup_rule_v2" "security_group_rule" {
  for_each = { for idx, rule in local.security_group_rules : idx => rule }

  security_group_id = openstack_networking_secgroup_v2.security_group.id
  direction         = each.value.direction
  ethertype         = each.value.ether_type
  protocol          = each.value.protocol
  port_range_min    = each.value.port_range_min
  port_range_max    = each.value.port_range_max
  remote_ip_prefix  = each.value.remote_ip_prefix
}
