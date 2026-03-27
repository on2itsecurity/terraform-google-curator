variable "project_id" {
  description = "GCP project ID"
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

variable "auth_code" {
  description = "Curator auth code from the AUXO Portal"
  type        = string
  sensitive   = true
}

variable "firewall_allow_ips" {
  description = "Additional IP ranges allowed inbound access"
  type        = list(string)
  default     = []
}

variable "labels" {
  description = "Map of labels applied to all resources"
  type        = map(string)
  default = {
    managedby = "terraform"
  }
}
