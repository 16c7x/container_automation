resource "aws_ecs_task_definition" "cassandra" {
  family                   = "cassandra"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = "arn:aws:iam::574184548053:role/ecsTaskExecutionRole"
  task_role_arn            = "arn:aws:iam::574184548053:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name      = "cassandra"
      image     = "cassandra:latest"
      essential = true
      portMappings = [
        { containerPort = 7000, hostPort = 7000, protocol = "tcp" },
        { containerPort = 9042, hostPort = 9042, protocol = "tcp" }
      ]
      environment = [
        { name = "CASSANDRA_START_RPC", value = "true" },
        { name = "CASSANDRA_RPC_ADDRESS", value = "0.0.0.0" },
        { name = "CASSANDRA_LISTEN_ADDRESS", value = "auto" },
        { name = "CASSANDRA_CLUSTER_NAME", value = "my-cluster" },
        { name = "CASSANDRA_ENDPOINT_SNITCH", value = "GossipingPropertyFileSnitch" },
        { name = "CASSANDRA_DC", value = "my-datacenter-1" }
      ]
      mountPoints = [
        {
          sourceVolume  = "cassandra-data"
          containerPath = "/var/lib/cassandra"
          readOnly      = false
        }
      ]
      healthCheck = {
        command     = ["CMD-SHELL", "nodetool status"]
        interval    = 120
        timeout     = 10
        retries     = 3
        startPeriod = 120
      }
    }
  ])

  volume {
    name = "cassandra-data"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.cassandra.id
      root_directory = "/"
    }
  }

}