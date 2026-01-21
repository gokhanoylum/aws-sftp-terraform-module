output "sftp_private_ip" {
  value       = aws_instance.sftp_server.private_ip
  description = "SFTP Server Private IP Adresi"
}