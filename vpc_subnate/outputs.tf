output "aws_ami_id" {
  value = data.aws_ami.RH-FE-ubuntu.id
}
output "public_ip_FE" {
  value = aws_instance.RH-FE.public_ip
}