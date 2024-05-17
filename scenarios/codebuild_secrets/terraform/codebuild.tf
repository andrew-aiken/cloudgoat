#IAM Role for AWS CodeBuild Project
resource "aws_iam_role" "codebuild" {
  name        = "code-build-cg-${var.cgid}-service-role"
  description = ""

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  inline_policy {
    name = "code-build-cg-${var.cgid}-policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "ec2:CreateNetworkInterface",
            "ec2:DescribeDhcpOptions",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DeleteNetworkInterface",
            "ec2:DescribeSubnets",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeVpcs"
          ]
          Resource = "*"
        }
      ]
    })
  }

  tags = merge(local.default_tags, {
    Name = "code-build-cg-${var.cgid}-service-role"
  })
}

#AWS CodeBuildProjects
resource "aws_codebuild_project" "codebuild" {
  name          = "cg-codebuild-${var.cgid}"
  build_timeout = 20
  service_role  = aws_iam_role.codebuild.arn

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false

    environment_variable {
      name  = "calrissian-aws-access-key"
      value = aws_iam_access_key.calrissian.id
    }

    environment_variable {
      name  = "calrissian-aws-secret-key"
      value = aws_iam_access_key.calrissian.secret
    }
  }

  source {
    type      = "NO_SOURCE"
    buildspec = file("../assets/buildspec.yml")
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  tags = merge(local.default_tags, {
    Name = "cg-codebuild-${var.cgid}"
  })
}
