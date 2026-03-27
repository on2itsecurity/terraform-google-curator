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
  auth_code  = var.auth_code
}
