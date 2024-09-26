
resource "aws_ebs_volume" "ec2_vol" {
    size = 10
    availability_zone = aws_instance.ec2.availability_zone 
}

resource "aws_volume_attachment" "ebs-disk1" {
    device_name = "/dev/sdh"
    volume_id = aws_ebs_volume.ec2_vol.id
    instance_id = aws_instance.ec2.id
 
}