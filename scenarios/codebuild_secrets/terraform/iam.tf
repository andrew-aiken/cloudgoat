# Calrissian User
resource "aws_iam_user" "calrissian" {
  name = "calrissian"
  tags = local.default_tags
}

resource "aws_iam_access_key" "calrissian" {
  user = aws_iam_user.calrissian.name
}

resource "aws_iam_policy" "calrissian" {
  name        = "cg-calrissian-policy-${var.cgid}"
  description = "cg-calrissian-policy-${var.cgid}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "calrissian"
        Effect = "Allow"
        Action = [
          "rds:CreateDBSnapshot",
          "rds:DescribeDBInstances",
          "rds:ModifyDBInstance",
          "rds:RestoreDBInstanceFromDBSnapshot",
          "rds:DescribeDBSubnetGroups",
          "rds:CreateDBSecurityGroup",
          "rds:DeleteDBSecurityGroup",
          "rds:DescribeDBSecurityGroups",
          "rds:AuthorizeDBSecurityGroupIngress",
          "ec2:CreateSecurityGroup",
          "ec2:DeleteSecurityGroup",
          "ec2:DescribeSecurityGroups",
          "ec2:AuthorizeSecurityGroupIngress"
        ]
        Resource = "*"
      }
    ]
  })

  tags = local.default_tags
}

resource "aws_iam_user_policy_attachment" "calrissian" {
  user       = aws_iam_user.calrissian.name
  policy_arn = aws_iam_policy.calrissian.arn
}


# Solo User
resource "aws_iam_user" "solo" {
  name = "solo"
  tags = local.default_tags
}

resource "aws_iam_access_key" "solo" {
  user = aws_iam_user.solo.name
}

resource "aws_iam_policy" "solo" {
  name        = "cg-solo-policy-${var.cgid}"
  description = "cg-solo-policy-${var.cgid}"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "solo"
        Effect = "Allow"
        Action = [
          "s3:ListAllMyBuckets",
          "ssm:DescribeParameters",
          "ssm:GetParameter",
          "codebuild:ListProjects",
          "codebuild:BatchGetProjects",
          "codebuild:ListBuilds",
          "ec2:DescribeInstances",
          "ec2:DescribeVpcs",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups"
        ]
        Resource = "*"
      }
    ]
  })

  tags = local.default_tags
}

resource "aws_iam_user_policy_attachment" "solo" {
  user       = aws_iam_user.solo.name
  policy_arn = aws_iam_policy.solo.arn
}
