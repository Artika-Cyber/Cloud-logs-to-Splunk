output "aws_key_id" {
  value = aws_iam_access_key.splunk_user_key.id
}

output "aws_key_secret" {
  value     = aws_iam_access_key.splunk_user_key.secret
  sensitive = true
}