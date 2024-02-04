data "aws_ami" "latest-ubuntu-image" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-*-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "jenkins-server" {
  ami                         = data.aws_ami.latest-ubuntu-image.id
  instance_type               = var.instance_type
  iam_instance_profile        = "${aws_iam_instance_profile.s3ec2access.name}"
  key_name                    = "nginxapp"
  subnet_id                   = aws_subnet.public_subnet[0].id
  vpc_security_group_ids      = [aws_security_group.default.id]
  associate_public_ip_address = true
  user_data                   = "${file("jenkins-setup.sh")}"
  tags = {
    Name = "jenkins-server"
  }
  root_block_device {
    volume_size = 50
  }
}

output "ec2_public_ip" {
  value = aws_instance.jenkins-server.public_ip
}