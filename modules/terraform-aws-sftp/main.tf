resource "aws_security_group" "sftp_sg" {
  name        = "ocp-sftp-private-sg"
  description = "Allow SFTP from internal network"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_source_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    { Name = var.sftp_sg_name },
    var.tags
  )
}

resource "aws_instance" "sftp_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name
  
  associate_public_ip_address = false

  vpc_security_group_ids = [aws_security_group.sftp_sg.id]

  metadata_options {
    http_tokens = "required"
  }

  user_data = file("${path.module}/script.sh")

  tags = merge(
    { Name = var.sftp_server_name },
    var.tags
  )
}

resource "aws_ebs_volume" "sftp_data" {
  availability_zone = aws_instance.sftp_server.availability_zone
  size              = var.volume_size
  type              = "gp3"
  tags = merge(
    { Name = var.sftp_data_name },
    var.tags
  )
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.sftp_data.id
  instance_id = aws_instance.sftp_server.id
}