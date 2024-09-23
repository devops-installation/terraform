output "ec2_details" {
    value = {
        public_ip    = aws_instance.ec2.public_ip
        private_ip   = aws_instance.ec2.private_ip
        id           = aws_instance.ec2.id
        az           = aws_instance.ec2.availability_zone
        ami          = aws_instance.ec2.ami
        key          = aws_instance.ec2.key_name
        cpu_cores    = aws_instance.ec2.cpu_options
        volume_size  = aws_instance.ec2.root_block_device[0].volume_size
    }
}
