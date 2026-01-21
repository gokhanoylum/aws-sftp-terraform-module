terraform {
  source = "../../../..//modules/terraform-aws-sftp"
}

include {
  path = find_in_parent_folders()
}

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

inputs = {
  instance_type = "t4g.small"
  ami_id        = "ami-001dda72adba06b0f"  
  key_name      = "sftp"
  vpc_id              = "vpc-**********" 
  subnet_id           = "subnet-***********"    
  allowed_source_cidrs = ["10.120.*.*/21", "10.121.*.*/20"]        
  
  volume_size         = 100

  tags = local.common_vars.tags
  sftp_sg_name = "ocp-sftp-private-sg"
  sftp_server_name = "ocp-test-sftp-server"
  sftp_data_name = "sftp-data-disk"
}