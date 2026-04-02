variable "ami" {
  description = "The AMI ID to use"
}

variable "instance_type" {
  description = "The instance type"
}

variable "name" {
  description = "The name of the instance"
}

variable "key_name" {
  description = "The key name for SSH access"
}

variable "vpc_security_group_ids" {
  description = "The security group IDs to assign"
  type        = list(string)
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
