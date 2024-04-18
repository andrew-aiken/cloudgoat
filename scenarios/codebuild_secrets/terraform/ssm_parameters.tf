#AWS SSM Parameters
resource "aws_ssm_parameter" "ec2_public_key" {
  name        = "cg-ec2-public-key-${var.cgid}"
  description = "cg-ec2-public-key-${var.cgid}"
  type        = "String"
  value       = file("../cloudgoat.pub")
}

resource "aws_ssm_parameter" "ec2_private_key" {
  name        = "cg-ec2-private-key-${var.cgid}"
  description = "cg-ec2-private-key-${var.cgid}"
  type        = "String"
  value       = file("../cloudgoat")
}
