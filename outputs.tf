output "instance_ip_addr" {
  value       = aws_instance.web-server.public_ip
  description = "The private IP address of the main server instance."
}

output "instance_dns_addr" {
  value       = aws_instance.web-server.public_dns
  description = "The private DNS address of the main server instance."
}

output "instance_public_key" {
  value       = aws_key_pair.terraform-key.public_key
  description = "The private key of the main server instance."
}

output "instance_AMI_ID" {
  value       = aws_instance.web-server.ami
  description = "The AMI of the main server instance."
}

output "instance_security_group" {
  value       = aws_security_group.web-sg.description
  description = "Allow port on the main server instance."
}