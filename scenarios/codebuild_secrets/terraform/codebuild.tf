#IAM Role for AWS CodeBuild Project
resource "aws_iam_role" "codebuild_role" {
  name        = "code-build-cg-${var.cgid}-service-role"
  description = ""

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })

  inline_policy {
    name = "code-build-cg-${var.cgid}-policy"
    policy = jsonencode(
      {
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "logs:CreateLogGroup",
              "logs:CreateLogStream",
              "logs:PutLogEvents"
            ]
            Resource = "*"
          },
          {
            Effect = "Allow"
            Action = [
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
      }
    )
  }
}

#AWS CodeBuildProjects
resource "aws_codebuild_project" "codebuild_project" {
  name          = "cg-codebuild-${var.cgid}"
  build_timeout = 20
  service_role  = aws_iam_role.codebuild_role.arn

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false

    environment_variable {
      name  = "AWS_ACCESS_KEY_ID"
      value = aws_iam_access_key.calrissian.id
    }

    environment_variable {
      name  = "AWS_SECRET_ACCESS_KEY"
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
  tags = {
    Name = "cg-codebuild-${var.cgid}"
  }
}
