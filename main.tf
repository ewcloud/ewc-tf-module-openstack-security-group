resource "openstack_networking_secgroup_v2" "security_group" {
  name        = var.security_group_name
  description = var.security_group_description
  tags        = [for k, v in var.tags : "${k}=${v}"]
}

resource "openstack_networking_secgroup_rule_v2" "security_group_rule" {
  for_each = { for idx, rule in var.security_group_rules : idx => rule }

  security_group_id = openstack_networking_secgroup_v2.security_group.id
  direction         = each.value.direction
  ethertype         = each.value.ether_type
  protocol          = each.value.protocol
  port_range_min    = each.value.port_range_min
  port_range_max    = each.value.port_range_max
  remote_ip_prefix  = each.value.remote_ip_prefix
}
