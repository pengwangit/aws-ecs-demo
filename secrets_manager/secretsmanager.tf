resource "aws_kms_key" "db_secrets_kms_key" {
  description = "KMS key for db secrets encryption"
}

resource "aws_secretsmanager_secret" "db_secrets" {
  name_prefix = "db_credentials"
  description = "current db credentials"
  kms_key_id  = aws_kms_key.db_secrets_kms_key.id
  depends_on  = [aws_kms_key.db_secrets_kms_key]
}

resource "aws_secretsmanager_secret_version" "db_secrets_version" {
  secret_id = aws_secretsmanager_secret.db_secrets.id
  secret_string = format(
    "{\"username\":\"%s\",\"password\":\"%s\",\"dbname\":\"%s\"}",
    var.database_username, var.database_password, var.database_name
  )
}
