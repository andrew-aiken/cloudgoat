variable "profile" {
  description = "The AWS profile to use"
  type        = string
}

variable "cgid" {
  description = "CGID variable for unique naming"
  type        = string
}

variable "rds_username" {
  default     = "cgadmin"
  description = "Username for the RDS database"
  type        = string
}

variable "rds_password" {
  default     = "wagrrrrwwgahhhhwwwrrggawwwwwwrr"
  description = "Password for the RDS database"
  type        = string
}

variable "rds_database_name" {
  default     = "securedb"
  description = "Default database name for the RDS database"
  type        = string
}

variable "region" {
  default = "us-east-1"
  type    = string
}

variable "cg_whitelist" {
  description = "User's public IP address(es)"
  default     = ["0.0.0.0/0"]
  type        = list(string)
}

variable "stack-name" {
  description = "Name of the stack"
  default     = "CloudGoat"
  type        = string
}

variable "scenario-name" {
  description = "Name of the scenario"
  default     = "codebuild-secrets"
  type        = string
}

variable "ssh_public_key" {
  default     = "../cloudgoat.pub"
  description = "SSH Public Key for the EC2 instance"
  type        = string
}

locals {
  # Ensure the bucket suffix doesn't contain invalid characters
  # "Bucket names can consist only of lowercase letters, numbers, dots (.), and hyphens (-)."
  # (per https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html)
  cgid_suffix = replace(var.cgid, "/[^a-z0-9-.]/", "-")
}
