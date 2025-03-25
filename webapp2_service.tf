resource "aws_ecs_service" "webapp2" {
	name                 = "webapp2-service"
	cluster              = aws_ecs_cluster.fortress.id
	task_definition      = aws_ecs_task_definition.webapp2.arn
	launch_type          = "FARGATE"
	desired_count        = 1
	force_new_deployment = true

    network_configuration {
        subnets          = module.networking.subnet_ids
        security_groups  = module.networking.security_group_ids
        assign_public_ip = true
    }
}