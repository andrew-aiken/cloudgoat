data "archive_file" "lambda_function" {
  type        = "zip"
  source_file = "../assets/lambda.py"
  output_path = "../assets/lambda.zip"
}

resource "aws_iam_role" "lambda" {
  name = "cg-lambda-role-${var.cgid}-service-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = local.default_tags
}

resource "aws_lambda_function" "lambda" {
  function_name    = "cg-lambda-${var.cgid}"
  filename         = "../assets/lambda.zip"
  role             = aws_iam_role.lambda.arn
  handler          = "lambda.handler"
  source_code_hash = data.archive_file.lambda_function.output_base64sha256
  runtime          = "python3.9" # TODO increase to latest

  environment {
    variables = {
      DB_NAME     = var.rds_database_name
      DB_USER     = var.rds_username
      DB_PASSWORD = var.rds_password
    }
  }

  tags = local.default_tags
}
