resource "aws_iam_role" "lambda_role" {
  name        = "cg-lambda-role-${var.cgid}-service-role"
  description = ""

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
}

resource "aws_lambda_function" "lambda_function" {
  filename         = "../assets/lambda.zip"
  function_name    = "cg-lambda-${var.cgid}"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda.handler"
  source_code_hash = data.archive_file.lambda_function.output_base64sha256
  runtime          = "python3.12"

  environment {
    variables = {
      DB_NAME     = var.rds_database_name
      DB_USER     = var.rds_username
      DB_PASSWORD = var.rds_password
    }
  }
}
