output "public_ip_freedebt" {
    value       = data.aws_eip.freedebt_eip.public_ip 
}
