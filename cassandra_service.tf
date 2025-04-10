resource "aws_ecs_service" "cassandra" {
  name            = "cassandra"
  cluster         = aws_ecs_cluster.fortress.id
  task_definition = aws_ecs_task_definition.cassandra.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  force_new_deployment = true

  network_configuration {
    subnets          = aws_subnet.fortress_subnet[*].id
    security_groups  = [aws_security_group.fortress_sg.id]
    assign_public_ip = true
  }
  enable_execute_command = true 
}