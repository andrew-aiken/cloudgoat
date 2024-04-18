resource "aws_iam_role" "ec2_role" {
  name        = "cg-ec2-role-${var.cgid}"
  description = ""

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })

  managed_policy_arns = [
    aws_iam_policy.ec2_role_policy.arn
  ]
}

resource "aws_iam_policy" "ec2_role_policy" {
  name        = "cg-ec2-role-policy-${var.cgid}"
  description = "cg-ec2-role-policy-${var.cgid}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lambda:ListFunctions",
          "lambda:GetFunction",
          "rds:DescribeDBInstances"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "cg-ec2-instance-profile-${var.cgid}"
  role = aws_iam_role.ec2_role.name
}

resource "aws_security_group" "ec2_ssh" {
  name        = "cg-ec2-ssh-${var.cgid}"
  description = "CloudGoat ${var.cgid} Security Group for EC2 Instance over SSH"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.cg_whitelist
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "cg-ec2-ssh-${var.cgid}"
  }
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "cg-ec2-key-pair-${var.cgid}"
  public_key = file(var.ssh_public_key)
}

resource "aws_instance" "ubuntu_ec2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.ec2_key.key_name
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name
  subnet_id                   = aws_subnet.public_subnet_1.id
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.ec2_ssh.id
  ]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }

  user_data = <<-EOF
        #!/bin/bash
        apt-get update
        apt-get install -y postgresql-client
        psql postgresql://${var.rds_username}:${var.rds_password}@${aws_db_instance.psql_rds.endpoint}/${var.rds_database_name} \
        -c "CREATE TABLE sensitive_information (name VARCHAR(100) NOT NULL, value VARCHAR(100) NOT NULL);"
        psql postgresql://${var.rds_username}:${var.rds_password}@${aws_db_instance.psql_rds.endpoint}/${var.rds_database_name} \
        -c "INSERT INTO sensitive_information (name,value) VALUES ('Key1','V\!C70RY-PvyOSDptpOVNX2JDS9K9jVetC1xI4gMO4');"
        psql postgresql://${var.rds_username}:${var.rds_password}@${aws_db_instance.psql_rds.endpoint}/${var.rds_database_name} \
        -c "INSERT INTO sensitive_information (name,value) VALUES ('Key2','V\!C70RY-JpZFReKtvUiWuhyPGF20m4SDYJtOTxws6');"
        EOF

  volume_tags = {
    Name = "CloudGoat ${var.cgid} EC2 Instance Root Device"
  }
  tags = {
    Name = "cg-ubuntu-ec2-${var.cgid}"
  }
}
