resource "aws_secretsmanager_secret" "docker" {
  name = "docker2"
  recovery_window_in_days = 0
}

data "external" "key" {
  program = ["bash", "./get_key.sh"]
}

resource "aws_secretsmanager_secret_version" "docker" {
  secret_id     = aws_secretsmanager_secret.docker.id
  secret_string = jsonencode(data.external.key.result)
}