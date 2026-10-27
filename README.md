# OpenStack Security Group Terraform Module

This Terraform module creates and configures an OpenStack Security Group with either common predefined or custom-defined set of rules. It is designed to be reusable, flexible, and aligned with Terraform best practices for OpenStack deployments.

## Features

* Creates an OpenStack Security Group with customizable name and description.
* Attaches an arbitrary number of
rules from:
  * one of the [predefined security groups](#predefined-security-groups)

    **OR**
  * custom-defined rules, to said security group


## Authentication

Before proceeding, if you lack OpenStack Application Credentials or do not know
how to make them available in your local environment, make sure
to check out the 
[EWC documentation](https://confluence.ecmwf.int/x/TiRNH).

## Usage

>⚠️ Set exactly one of `security_group_rules` or `predefined_security_group`.

The module creates either one of the **predefined** EWC security groups, by name, or a **custom** security group, from your own list of
rules.



### Choose a predefined security group

>💡 For a full list of available options, see the [Predefined Security Groups section](#predefined-security-groups) below.

>✅ The security group is named after the predefined group (`ipa` in the example below), unless you also set `security_group_name`.

```hcl
module "ipa_security_group" {
  source = "github.com/ewcloud/ewc-tf-module-openstack-security-group?ref=1.1.0"

  predefined_security_group = "ipa"
  federee                   = "ECMWF" # Defaults to EUMETSAT if not set

  tags = {
    environment       = "production"
    project           = "ewc"
    provisioning-tool = "terraform"
  }
}
```

**OR**

### Define a custom security group

```hcl
module "postgres_security_group" {
  source = "github.com/ewcloud/ewc-tf-module-openstack-security-group?ref=1.1.0"

  security_group_name        = "postgres"
  security_group_description = "PostgreSQL from the private subnet"

  security_group_rules = [
    {
      direction        = "ingress"
      ether_type       = "IPv4"
      protocol         = "tcp"
      port_range_min   = 5432
      port_range_max   = 5432
      remote_ip_prefix = "10.0.0.0/24"
    },
    {
      direction        = "ingress"
      ether_type       = "IPv4"
      protocol         = "tcp"
      port_range_min   = 22
      port_range_max   = 22
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
| `security_group_name` | Name of the security group. Required with `security_group_rules`; defaults to the `predefined_security_group` name otherwise. Example: `ipa` | `string` | `null` | no |
| `security_group_description` | Description of the security group | `string` | `null` | no |
| `security_group_rules` | List of security group rules for a custom security group. Mutually exclusive with `predefined_security_group` | `list(object({direction = string, ether_type = string, protocol = string, port_range_min = number, port_range_max = number, remote_ip_prefix = string}))` | `null` | no |
| `predefined_security_group` | Name of a predefined security group to create, one of the available[predefined security groups](#predefined-security-groups). Mutually exclusive with `security_group_rules` | `string` | `null` | no |
| `federee` | EWC federee hosting the deployment, `EUMETSAT` or `ECMWF`. When applicable, defines the private subnet IP range for a predefined security groups | `string` | `"EUMETSAT"` | no |
| `tags` | Map of tags to assign to the security group | `map(string)` | `{}` | no |


### Predefined Security Groups

| Name | Rules (protocol/port from source) |
|------|-----------------------------------|
| `ssh` | tcp/22 ingress from `0.0.0.0/0` |
| `ssh-https` | tcp/22, tcp/80, tcp/443 ingress from `0.0.0.0/0` (same as `ssh-http-https`, useful for EWC site harmonization) |
| `ssh-http-https` | tcp/22, tcp/80, tcp/443 ingress from `0.0.0.0/0` (same as `ssh-https`, useful for EWC site harmonization) |
| `nginx-proxy-manager` | tcp/443 (HTTPS), tcp/80 (HTTP), tcp/22 (SSH), tcp/8200 (NPM admin frontend) ingress from the `<private subnet>` IP range (automatically set according to `federee`) |
| `eumetcast` | udp/2268, tcp/8500 ingress from `0.0.0.0/0` |
| `ipa` | tcp/22 (SSH) from `0.0.0.0/0`; tcp/443 (HTTPS), tcp/80 (HTTP), tcp/389 (LDAP), tcp/636 (LDAPS), tcp+udp/88 (Kerberos auth), tcp+udp/464 (Kerberos password change), tcp+udp/53 (DNS), udp/123 (NTP) ingress from `<private subnet>` (automatically set according to `federee`) |
| `htcondor` | tcp/9618 ingress from `0.0.0.0/0` |

### Custom Security Group Rules Input Structure

Each rule in the `security_group_rules` list is an object with the following attributes:

- `direction`: The direction of the rule (`ingress` or `egress`).
- `ether_type`: The ether type (`IPv4` or `IPv6`).
- `protocol`: The protocol (e.g., `tcp`, `udp`, `icmp`, or `null` for any).
- `port_range_min`: The minimum port number (1-65535, or `null` for protocols like `icmp`).
- `port_range_max`: The maximum port number (1-65535, or `null` for protocols like `icmp`).
- `remote_ip_prefix`: The remote IP prefix in CIDR notation (e.g., `10.0.0.0/24`).


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

## SW Bill of Materials (SBoM)
Third-party components used in the working environment.

The following components will be included in the working environment:
| Component | Version | License | Home URL |
|------|---------|---------|--------------|
| terraform-provider-openstack | 1.53.0 |  MPL-2.0 |  https://github.com/terraform-provider-openstack/terraform-provider-openstack   |

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

## Authors

[European Weather Cloud](http://support.europeanweather.cloud/)
<[support@europeanweather.cloud](mailto:support@europeanweather.cloud)>
