output "curator_vm_name" {
  description = "Name of the Curator compute instance"
  value       = module.curator.vm_name
}

output "curator_public_ip" {
  description = "Public IP address of the Curator VM"
  value       = module.curator.public_ip
}

output "curator_private_ip" {
  description = "Private IP address of the Curator VM"
  value       = module.curator.private_ip
}

output "project_id" {
  description = "GCP project ID"
  value       = module.curator.project_id
}

output "vpc_id" {
  description = "ID of the VPC network"
  value       = module.curator.vpc_id
}

output "subnet_id" {
  description = "ID of the subnet"
  value       = module.curator.subnet_id
}
