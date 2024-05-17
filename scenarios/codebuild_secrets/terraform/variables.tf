variable "profile" {
  description = "The AWS profile to use"
  type        = string
}

variable "cgid" {
  description = "CGID variable for unique naming"
  type        = string
}

variable "region" {
  default     = "us-east-1"
  description = "AWS Regions to place resources in"
  type        = string
}


variable "cg_whitelist" {
  description = "User's public IP address(es)"
  default     = ["0.0.0.0/0"]
  type        = list(string)
}

variable "rds_username" {
  default     = "cgadmin"
  description = "Username to use for the RDS instance"
  type        = string
}

variable "rds_password" {
  default     = "wagrrrrwwgahhhhwwwrrggawwwwwwrr"
  description = "Password to use for the RDS instance"
  type        = string
}

variable "rds_database_name" {
  default     = "securedb"
  description = "Default database name for the RDS instance"
  type        = string
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
  description = "Public key filename"
  type        = string
}
