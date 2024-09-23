output "ec2_details" {
    value = [
        aws_instance.ec2.public_ip,
        aws_instance.ec2.private_ip,
        aws_instance.ec2.id,
        aws_instance.ec2.availability_zone,
        aws_instance.ec2.ami,
        aws_instance.ec2.key_name,
        # aws_instance.ec2.memory_size,
        aws_instance.ec2.root_block_device[0].volume_size
    ]
  
}