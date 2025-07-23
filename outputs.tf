output "security_group_id" {
  description = "ID of the created security group"
  value       = openstack_networking_secgroup_v2.security_group.id
}

output "security_group_name" {
  description = "Name of the created security group"
  value       = openstack_networking_secgroup_v2.security_group.name
}

output "security_group_rules" {
  description = "List of created security group rule IDs"
  value       = [for rule in openstack_networking_secgroup_rule_v2.security_group_rule : rule.id]
}
