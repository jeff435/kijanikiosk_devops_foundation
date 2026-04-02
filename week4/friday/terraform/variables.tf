variable "region" {
  description = "The AWS region"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "The instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "The key name for SSH access"
}
