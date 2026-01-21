# Terraform AWS SFTP Module

This Terraform module provisions an AWS SFTP server using an EC2 instance, an attached EBS volume for data storage, and a security group to control access. The server is configured for secure file transfers via SFTP, with a chrooted SFTP user.

## Features

- Deploys an EC2 instance with a custom AMI.
- Attaches and mounts an additional EBS volume for SFTP uploads.
- Configures SSH for SFTP-only access with password authentication.
- Creates a security group allowing SSH (port 22) from specified CIDR blocks.
- Supports tagging and customization via variables.

## Prerequisites

- Terraform >= 1.0
- AWS account with appropriate permissions (e.g., EC2, EBS, VPC, Security Groups)
- An existing VPC and subnet
- SSH key pair for EC2 access (optional, as SFTP uses password auth)
- AMI ID for the desired OS (e.g., Amazon Linux 2 or Ubuntu)

## Usage

```hcl
module "sftp" {
  source = "./modules/terraform-aws-sftp"

  vpc_id               = "vpc-xxxxxxxx"
  subnet_id            = "subnet-xxxxxxxx"
  instance_type        = "t4g.small"
  ami_id               = "ami-xxxxxxxx"
  key_name             = "your-key-pair"
  allowed_source_cidrs = ["10.0.0.0/16", "10.121.0.0/20"]
  volume_size          = 100
  tags                 = {
    Environment = "test"
    Project     = "sftp"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| vpc_id | VPC ID for the SFTP server | `string` | - | Yes |
| subnet_id | Subnet ID for the SFTP server | `string` | - | Yes |
| instance_type | EC2 instance type | `string` | `"t4g.small"` | No |
| ami_id | AMI ID for the EC2 instance | `string` | - | Yes |
| key_name | SSH key pair name | `string` | - | Yes |
| allowed_source_cidrs | List of CIDR blocks allowed for SSH access | `list(string)` | `[]` | No |
| volume_size | Size of the additional EBS volume in GB | `number` | `50` | No |
| tags | Common tags for resources | `map(string)` | `{}` | No |
| sftp_sg_name | Name tag for the security group | `string` | `"ocp-sftp-private-sg"` | No |
| sftp_server_name | Name tag for the EC2 instance | `string` | `"SFTP-Graviton-Server"` | No |
| sftp_data_name | Name tag for the EBS volume | `string` | `"sftp-data-disk"` | No |

## Outputs

| Name | Description |
|------|-------------|
| sftp_server_id | ID of the SFTP EC2 instance |
| sftp_sg_id | ID of the SFTP security group |
| sftp_data_volume_id | ID of the attached EBS volume |

## Example with Terragrunt

If using Terragrunt, define inputs in a `terragrunt.hcl` file:

```hcl
terraform {
  source = "../../../modules/terraform-aws-sftp"
}

inputs = {
  vpc_id               = "vpc-xxxxxxxx"
  subnet_id            = "subnet-xxxxxxxx"
  allowed_source_cidrs = ["10.120.0.0/21", "10.121.0.0/20"]
  # ... other inputs
}
```

## Notes

- The SFTP user is created with username `sftp_user` and a default password (change in `script.sh` for security).
- The server uses IMDSv2 for metadata access.
- Ensure the AMI supports the commands in `script.sh` (e.g., ext4 filesystem, systemd).
- For production, consider using AWS Transfer Family for managed SFTP.

## License

This module is provided as-is. Review and test in a non-production environment before use.