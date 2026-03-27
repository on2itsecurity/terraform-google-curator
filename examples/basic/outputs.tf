output "curator_public_ip" {
  description = "Public IP address of the Curator VM"
  value       = module.curator.public_ip
}

output "curator_private_ip" {
  description = "Private IP address of the Curator VM"
  value       = module.curator.private_ip
}
