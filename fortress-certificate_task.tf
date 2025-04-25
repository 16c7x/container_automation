resource "aws_ecs_task_definition" "fortress-certificate" {
  family                   = "fortress-certificate"
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "arn:aws:iam::574184548053:role/ecsTESecretsRole"
  task_role_arn            = "arn:aws:iam::574184548053:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
		{
			name      = "fortress-certificate-authority-service"
			image     = "perforce/fortress-certificate-authority-service:latest"
      cpu       = 0		
      portMappings: [
        {
          name: "fortress-certificate-authority-service",
          containerPort: 80,
          hostPort: 80,
          protocol: "tcp",
          appProtocol: "http"
        }
      ]
      essential = true
      repositoryCredentials = {
        credentialsParameter = aws_secretsmanager_secret.docker.arn
      }
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.fortress_logs.name
          awslogs-region        = "eu-west-1"
          awslogs-stream-prefix = "ecs"
        }
      }
		}
  ])
}