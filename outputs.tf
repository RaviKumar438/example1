output "sgroup" {
  value = aws_security_group.allow_ssh.id
}
output "Master_public_ip" {
  value = aws_instance.Master[*].public_ip
}

#output "private_key_pem" {
# value     = tls_private_key.key_pair.private_key_pem
# sensitive = true # Marking the output as sensitive
#}
output "public" {
  value = aws_subnet.public[*].id

}
output "instance_ids" {
  description = "IDs of the launched EC2 instances"
  value       = aws_instance.Master[*].id
}
# Write the output to a file using local-exec provisioner
resource "null_resource" "output_file" {
  provisioner "local-exec" {
    command = "echo '${join("\n", aws_instance.Master[*].public_ip)}' > instance_ips.txt"
  }

  depends_on = [aws_instance.Master]
}