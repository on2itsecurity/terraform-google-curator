output "vm_name" {
  description = "Name of the Curator compute instance"
  value       = google_compute_instance.this.name
}

output "private_ip" {
  description = "Private IP address of the Curator VM"
  value       = google_compute_instance.this.network_interface[0].network_ip
}

output "public_ip" {
  description = "Public IP address of the Curator VM"
  value       = google_compute_address.this.address
}

output "project_id" {
  description = "GCP project ID"
  value       = var.project_id
}

output "vpc_id" {
  description = "ID of the VPC network"
  value       = google_compute_network.this.id
}

output "subnet_id" {
  description = "ID of the subnet"
  value       = google_compute_subnetwork.this.id
}
