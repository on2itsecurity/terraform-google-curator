# Location
variable "project_id" {
  description = "GCP project ID for deployment"
  type        = string
}

variable "region" {
  description = "GCP region for deployment"
  type        = string
  default     = "europe-west4"
}

variable "zone" {
  description = "GCP zone for the Curator VM"
  type        = string
  default     = "europe-west4-a"
}

variable "labels" {
  description = "Map of labels applied to all resources"
  type        = map(string)
  default     = {}
}

# Networking
variable "vpc_name" {
  description = "Name of the VPC network"
  type        = string
  default     = "vpc-curator"
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "sn-curator"
}

variable "subnet_range" {
  description = "IP CIDR range for the subnet"
  type        = string
  default     = "10.10.1.0/24"
}

# VM
variable "vm_name" {
  description = "Name of the Curator compute instance"
  type        = string
  default     = "vm-curator"
}

variable "machine_type" {
  description = "GCP machine type for the Curator instance"
  type        = string
  default     = "e2-standard-4"
}

variable "private_ip_address" {
  description = "Static private IP address for the VM (must be within subnet range)"
  type        = string
  default     = "10.10.1.10"
}

variable "disk_size_gb" {
  description = "Boot disk size in GB"
  type        = number
  default     = 50
}

variable "disk_type" {
  description = "Boot disk type (pd-ssd, pd-balanced, pd-standard)"
  type        = string
  default     = "pd-ssd"
}

# Security
variable "firewall_allow_ips" {
  description = "Additional IP ranges allowed inbound access (ON2IT range 185.46.232.0/22 is always included)"
  type        = list(string)
  default     = []
}

# Curator
variable "auth_code" {
  description = "Curator auth code from the AUXO Portal (delivered via instance metadata)"
  type        = string
  sensitive   = true
}

variable "image" {
  description = "Source image for the Curator VM (projects/PROJECT/global/images/family/FAMILY format)"
  type        = string
  default     = "projects/on2it-public/global/images/family/curator-family"
}
