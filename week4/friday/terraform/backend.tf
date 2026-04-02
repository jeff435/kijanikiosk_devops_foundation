terraform {
  # backend "s3" {
  #   bucket         = "kijanikiosk-terraform-state"
  #   key            = "week4/friday/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-lock"
  #   encrypt        = true
  # }

  # Using local backend for simulation as bucket is not yet provisioned
  backend "local" {
    path = "terraform.tfstate"
  }
}
