terraform {
  required_version = ">= 1.6.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "curator" {
  source  = "on2itsecurity/curator/google"
  version = "~> 1.0"

  project_id = var.project_id
  region     = var.region
  zone       = var.zone
  auth_code  = var.auth_code

  vm_name      = var.vm_name
  machine_type = var.machine_type
  disk_size_gb = var.disk_size_gb
  disk_type    = var.disk_type

  vpc_name           = "vpc-curator"
  subnet_name        = "sn-curator"
  subnet_range       = "10.10.1.0/24"
  private_ip_address = "10.10.1.10"

  firewall_allow_ips = var.firewall_allow_ips

  labels = var.labels
}
