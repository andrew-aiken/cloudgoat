#Security Group
resource "aws_security_group" "rds" {
  name        = "cg-rds-psql-${var.cgid}"
  description = "CloudGoat ${var.cgid} Security Group for PostgreSQL RDS Instance"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    cidr_blocks = [
      "10.10.10.0/24",
      "10.10.20.0/24",
      "10.10.30.0/24",
      "10.10.40.0/24"
    ]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
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
    Name = "cg-rds-psql-${var.cgid}"
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "cloud-goat-rds-subnet-group-${var.cgid}"
  description = "CloudGoat ${var.cgid} Subnet Group"

  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]
}

resource "aws_db_subnet_group" "rds_testing_subnet_group" {
  name        = "cloud-goat-rds-testing-subnet-group-${var.cgid}"
  description = "CloudGoat ${var.cgid} Subnet Group ONLY for Testing with Public Subnets"

  subnet_ids = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]
}

#RDS PostgreSQL Instance
resource "aws_db_instance" "psql_rds" {
  identifier           = "cg-rds-instance-${local.cgid_suffix}"
  engine               = "postgres"
  engine_version       = "16.2"
  port                 = "5432"
  instance_class       = "db.t3.micro"
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.id
  multi_az             = false
  username             = var.rds_username
  password             = var.rds_password
  publicly_accessible  = false
  storage_type         = "gp2"
  allocated_storage    = 20
  db_name              = var.rds_database_name
  apply_immediately    = true
  skip_final_snapshot  = true

  vpc_security_group_ids = [
    aws_security_group.rds.id
  ]
}
