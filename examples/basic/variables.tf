variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region for deployment"
  type        = string
  default     = "europe-west4"
}

variable "auth_code" {
  description = "Curator auth code from the AUXO Portal"
  type        = string
  sensitive   = true
}
