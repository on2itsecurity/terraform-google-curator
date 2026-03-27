# AUXO Curator - GCP Compute Instance Module

Terraform/OpenTofu module for deploying an AUXO Curator appliance on Google Cloud Platform. This module creates a Curator VM with hardened firewall rules, VPC network, and static external IP.

## Prerequisites

- GCP project with Compute Engine API enabled
- Authenticated `gcloud` CLI (`gcloud auth application-default login`)
- An auth code from the [AUXO Portal](https://soc.on2it.net)
- Terraform >= 1.6.0 or OpenTofu >= 1.6.0

## Usage

```hcl
module "curator" {
  source  = "on2itsecurity/curator/google"
  version = "~> 1.0"

  project_id = var.project_id
  auth_code  = var.auth_code
}
```

## Requirements

| Name                 | Version  |
| -------------------- | -------- |
| terraform / opentofu | >= 1.6.0 |
| google               | >= 6.0.0 |

## Inputs

| Name               | Description                                                        | Type           | Default                                                      | Required |
| ------------------ | ------------------------------------------------------------------ | -------------- | ------------------------------------------------------------ | -------- |
| project_id         | GCP project ID for deployment                                      | `string`       | n/a                                                          | **yes**  |
| auth_code          | Curator auth code from the AUXO Portal                             | `string`       | n/a                                                          | **yes**  |
| region             | GCP region for deployment                                          | `string`       | `"europe-west4"`                                             | no       |
| zone               | GCP zone for the Curator VM                                        | `string`       | `"europe-west4-a"`                                           | no       |
| labels             | Map of labels applied to all resources                             | `map(string)`  | `{}`                                                         | no       |
| vpc_name           | Name of the VPC network                                            | `string`       | `"vpc-curator"`                                              | no       |
| subnet_name        | Name of the subnet                                                 | `string`       | `"sn-curator"`                                               | no       |
| subnet_range       | IP CIDR range for the subnet                                       | `string`       | `"10.10.1.0/24"`                                             | no       |
| vm_name            | Name of the Curator compute instance                               | `string`       | `"vm-curator"`                                               | no       |
| machine_type       | GCP machine type for the Curator instance                          | `string`       | `"e2-standard-4"`                                            | no       |
| private_ip_address | Static private IP address for the VM                               | `string`       | `"10.10.1.10"`                                               | no       |
| disk_size_gb       | Boot disk size in GB                                               | `number`       | `50`                                                         | no       |
| disk_type          | Boot disk type (pd-ssd, pd-balanced, pd-standard)                  | `string`       | `"pd-ssd"`                                                   | no       |
| firewall_allow_ips | Additional IP ranges allowed inbound (ON2IT range always included) | `list(string)` | `[]`                                                         | no       |
| image              | Source image for the Curator VM                                    | `string`       | `"projects/on2it-public/global/images/family/curator-family"`  | no       |

## Outputs

| Name       | Description                          |
| ---------- | ------------------------------------ |
| vm_name    | Name of the Curator compute instance |
| private_ip | Private IP address of the Curator VM |
| public_ip  | Public IP address of the Curator VM  |
| project_id | GCP project ID                       |
| vpc_id     | ID of the VPC network                |
| subnet_id  | ID of the subnet                     |

## Network Security

The module creates hardened firewall rules with least-privilege outbound access:

- **DNS** (UDP 53) to Cloudflare and Google resolvers
- **NTP** (UDP 123) to Cloudflare time servers
- **HTTPS** (TCP 443) to AUXO platform (185.46.232.0/22)
- **NATS** (TCP 4222) to AUXO platform (185.46.232.0/22)
- **Google APIs** (TCP 443) via Private Google Access ranges
- **Deny all** other outbound traffic

The ON2IT platform range (185.46.232.0/22) is always included in the inbound allow rule. Additional IP ranges can be added via `firewall_allow_ips`.

Private Google Access is enabled on the subnet, allowing the VM to reach Google Cloud Storage and other Google APIs without traversing the public internet.

## Examples

- [Basic](./examples/basic) -- Minimal deployment with required variables only
- [Complete](./examples/complete) -- Full deployment with all options

## License

MIT
