locals {
  # Ensure the bucket suffix doesn't contain invalid characters
  # "Bucket names can consist only of lowercase letters, numbers, dots (.), and hyphens (-)."
  # (per https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html)
  cgid_suffix = replace(var.cgid, "/[^a-z0-9-.]/", "-")

  default_tags = {
    Stack    = var.stack-name
    Scenario = var.scenario-name
  }
}