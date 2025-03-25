resource "aws_ecs_task_definition" "webapp2" {
	family                   = "webapp2-task"
	network_mode             = "awsvpc"
	cpu                      = "512"
	memory                   = "1024"
	requires_compatibilities = ["FARGATE"]

	container_definitions = jsonencode([
		{
			name      = "webapp2"
			image     = "16c7x/webapp:latest"
            cpu       = 0		
            portMappings: [
                {
                    name: "webapp2-80",
                    containerPort: 80,
                    hostPort: 80,
                    protocol: "tcp",
                    appProtocol: "http"
                }
            ]
            essential = true
		}
	])
}