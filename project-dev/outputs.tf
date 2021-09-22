#so we know the eip so we can connect to the instance

output "server_public_ip" {
    value = aws_eip.one.public_ip
}
