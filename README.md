# OpenStack Security Group Terraform Module

> 💡 The module supports complex rule sets, such as those required to create a subnet security group for IPA services (i.e. Kerberos, LDAP and DNS).

This Terraform module creates and configures an OpenStack Security Group with a user-defined set of rules. It is designed to be reusable, flexible, and aligned with Terraform best practices for OpenStack deployments. 

More specifically, the module:
* Creates an OpenStack Security Group with customizable name and description.
* Attaches an arbitrary number of user-defined rules to the security group.

## Copyright and License
Copyright © EUMETSAT 2025.

The provided code and instructions are licensed under the [MIT license](./LICENSE).
They are intended to automate the setup of an environment that includes 
third-party software components.
The usage and distribution terms of the resulting environment are 
subject to the individual licenses of those third-party libraries.

Users are responsible for reviewing and complying with the licenses of
all third-party components included in the environment.

Contact [EUMETSAT](http://www.eumetsat.int) for details on the usage and distribution terms.

## Authentication

Before proceeding, if you lack OpenStack Application Credentials or do not know
how to make them available to Ansible in your development environment, make sure
to check out the 
[EWC documentation](https://confluence.ecmwf.int/display/EWCLOUDKB/EWC+-+How+to+request+Openstack+Application+Credentials).

## Usage

```hcl
module "ldap_security_group" {
  source = "/path/to/terraform/module"

  security_group_name = "ldap"

  security_group_rules = [
    {
      direction        = "ingress"
      ether_type       = "IPv4"
      protocol         = "tcp"
      port_range_min   = 80
      port_range_max   = 80
      remote_ip_prefix = "0.0.0.0/0"
    },
    {
      direction        = "ingress"
      ether_type       = "IPv4"
      protocol         = "udp"
      port_range_min   = 123
      port_range_max   = 123
      remote_ip_prefix = "0.0.0.0/0"
    },
    {
      direction        = "ingress"
      ether_type       = "IPv4"
      protocol         = "tcp"
      port_range_min   = 88
      port_range_max   = 88
      remote_ip_prefix = "0.0.0.0/0"
    },
    {
      direction        = "ingress"
      ether_type       = "IPv4"
      protocol         = "udp"
      port_range_min   = 88
      port_range_max   = 88
      remote_ip_prefix = "0.0.0.0/0"
    },
    {
      direction        = "ingress"
      ether_type       = "IPv4"
      protocol         = "tcp"
      port_range_min   = 53
      port_range_max   = 53
      remote_ip_prefix = "0.0.0.0/0"
    },
    {
      direction        = "ingress"
      ether_type       = "IPv4"
      protocol         = "udp"
      port_range_min   = 53
      port_range_max   = 53
      remote_ip_prefix = "0.0.0.0/0"
    },
    {
      direction        = "ingress"
      ether_type       = "IPv4"
      protocol         = "tcp"
      port_range_min   = 389
      port_range_max   = 389
      remote_ip_prefix = "0.0.0.0/0"
    },
    {
      direction        = "ingress"
      ether_type       = "IPv4"
      protocol         = "tcp"
      port_range_min   = 749
      port_range_max   = 749
      remote_ip_prefix = "0.0.0.0/0"
    },
    {
      direction        = "ingress"
      ether_type       = "IPv4"
      protocol         = "tcp"
      port_range_min   = 22
      port_range_max   = 22
      remote_ip_prefix = "0.0.0.0/0"
    },
    {
      direction        = "ingress"
      ether_type       = "IPv4"
      protocol         = "tcp"
      port_range_min   = 636
      port_range_max   = 636
      remote_ip_prefix = "0.0.0.0/0"
    },
    {
      direction        = "ingress"
      ether_type       = "IPv4"
      protocol         = "tcp"
      port_range_min   = 464
      port_range_max   = 464
      remote_ip_prefix = "0.0.0.0/0"
    },
    {
      direction        = "ingress"
      ether_type       = "IPv4"
      protocol         = "udp"
      port_range_min   = 464
      port_range_max   = 464
      remote_ip_prefix = "0.0.0.0/0"
    },
    {
      direction        = "ingress"
      ether_type       = "IPv4"
      protocol         = "tcp"
      port_range_min   = 443
      port_range_max   = 443
      remote_ip_prefix = "0.0.0.0/0"
    }
  ]

  tags = {
    environment       = "production"
    project           = "ewc"
    provisioning-tool = "terraform"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `security_group_name` | Name of the security group. Example: `ldap` | `string` | n/a | yes |
| `security_group_description` | Description of the security group | `string` | n/a | no |
| `security_group_rules` | List of security group rules | `list(object({direction = string, ether_type = string, protocol = string, port_range_min = number, port_range_max = number, remote_ip_prefix = string}))` | `[]` | no |
| `tags` | Map of tags to assign to the security group | `map(string)` | `{}` | no |

### Security Group Rules Input Structure

Each rule in the `security_group_rules` list is an object with the following attributes:

- `direction`: The direction of the rule (`ingress` or `egress`).
- `ether_type`: The ether type (`IPv4` or `IPv6`).
- `protocol`: The protocol (e.g., `tcp`, `udp`, `icmp`, or `null` for any).
- `port_range_min`: The minimum port number (1-65535, or `null` for protocols like `icmp`).
- `port_range_max`: The maximum port number (1-65535, or `null` for protocols like `icmp`).
- `remote_ip_prefix`: The remote IP prefix in CIDR notation (e.g., `0.0.0.0/0`).

## SW Bill of Materials (SBoM)
Third-party components used in the working environment.

The following components will be included in the working environment:
| Component | Version | License | Home URL |
|------|---------|---------|--------------|
| terraform-provider-openstack | 1.53.0 |  MPL-2.0 |  https://github.com/terraform-provider-openstack/terraform-provider-openstack   |

## Outputs

| Name | Description |
|------|-------------|
| `security_group_id` | ID of the created security group |
| `security_group_name` | Name of the created security group |
| `security_group_rules` | List of created security group rule IDs |

## Best Practices

### Resource Tagging

This module supports tagging of the security group using the `tags` variable. Tags are applied as a list of strings to the `openstack_networking_secgroup_v2` resource.

Example:

```hcl
tags = {
  environment       = "production"
  project           = "ewc"
  provisioning-tool = "terraform"
}
```

The above results in the security group being tagged with `environment=production`, `project=ewc` and `provisioning-tool=terraform`.

## Changelog
All notable changes (i.e. fixes, features and breaking changes) are documented 
in the [CHANGELOG.md](./CHANGELOG.md).

## Contributing

Thanks for taking the time to join our community and start contributing!
Please make sure to:
* Familiarize yourself with our [Code of Conduct](./CODE_OF_CONDUCT.md) before 
contributing.
* See [CONTRIBUTING.md](./CONTRIBUTING.md) for instructions on how to request 
or submit changes.

## Authors

[European Weather Cloud](http://support.europeanweather.cloud/) 
<[support@europeanweather.cloud](mailto:support@europeanweather.cloud)>
