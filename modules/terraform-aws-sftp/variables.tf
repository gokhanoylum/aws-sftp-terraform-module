variable "vpc_id" {
  description = "SFTP server VPC ID"
  type        = string
}

variable "subnet_id" {
  description = "Private Subnet ID for SFTP server"
  type        = string
}

variable "instance_type" {
  description = "Provisioned EC2 instance type"
  type        = string
  default     = "t4g.small"
}

variable "ami_id" {
  description = "AMI ID"
  type        = string
}

variable "key_name" {
  description = "SSH Key Pair name for EC2 instance"
  type        = string
}

variable "allowed_source_cidr" {
  description = "Allow network CIDR for SFTP access"
  type        = string
}

variable "allowed_source_cidrs" {
  description = "List of CIDR blocks allowed to access the SFTP server"
  type        = list(string)
  default     = []
}

variable "volume_size" {
  description = "Additional EBS volume size in GB"
  type        = number
  default     = 50
}

variable "tags" {
  description = "Common tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "sftp_sg_name" {
  description = "Name tag for the SFTP security group"
  type        = string
  default     = "ocp-sftp-private-sg"
}

variable "sftp_server_name" {
  description = "Name tag for the SFTP server instance"
  type        = string
  default     = "SFTP-Graviton-Server"
}

variable "sftp_data_name" {
  description = "Name tag for the SFTP data EBS volume"
  type        = string
  default     = "sftp-data-disk"
}