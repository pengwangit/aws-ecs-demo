output "db_secrets_arn" {
  value = aws_secretsmanager_secret.db_secrets.arn
}

output "db_secrets_kms_key_arn" {
  value = aws_kms_key.db_secrets_kms_key.arn
}
