output "cloudgoat_output_aws_account_id" {
  value = data.aws_caller_identity.account.account_id
}

output "cloudgoat_output_solo_access_key_id" {
  value = aws_iam_access_key.solo.id
}

output "cloudgoat_output_solo_secret_key" {
  value     = aws_iam_access_key.solo.secret
  sensitive = true
}
