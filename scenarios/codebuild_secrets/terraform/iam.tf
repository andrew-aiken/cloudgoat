resource "aws_iam_user" "calrissian" {
  name = "calrissian"
}

resource "aws_iam_access_key" "calrissian" {
  user = aws_iam_user.calrissian.name
}

resource "aws_iam_user" "solo" {
  name = "solo"
}

resource "aws_iam_access_key" "solo" {
  user = aws_iam_user.solo.name
}

#IAM User Policies
resource "aws_iam_policy" "calrissian_policy" {
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
}

resource "aws_iam_policy" "solo_policy" {
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
}

#User Policy Attachments
resource "aws_iam_user_policy_attachment" "calrissian_attachment" {
  user       = aws_iam_user.calrissian.name
  policy_arn = aws_iam_policy.calrissian_policy.arn
}

resource "aws_iam_user_policy_attachment" "solo_attachment" {
  user       = aws_iam_user.solo.name
  policy_arn = aws_iam_policy.solo_policy.arn
}
