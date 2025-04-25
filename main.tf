# Main config
terraform {
  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "2.3.4"
    }
    aws = {
			source  = "hashicorp/aws"
			version = "5.92.0"
		}
  }
}

# This gets an ip address to add to the allow list, it will not work on a Windows machine
data "external" "myip" {
  program = [ "bash", "./get_my_ip.sh"]
}

provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_ecs_cluster" "fortress" {
	name = var.project
}

locals {
  name_tag = {
    Name = "${var.project}"
  }
}

data "aws_availability_zones" "available" {}

# Persistent storage

resource "aws_efs_file_system" "cassandra" {
  creation_token = "cassandra-efs"
}

resource "aws_efs_mount_target" "cassandra" {
  file_system_id  = aws_efs_file_system.cassandra.id
  subnet_id       = aws_subnet.fortress_subnet[0].id
  security_groups = [aws_security_group.fortress_sg.id]
}

# Logging
resource "aws_cloudwatch_log_group" "fortress_logs" {
  name              = "/ecs/fortress"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "cassandra_logs" {
  name              = "/ecs/cassandra"
  retention_in_days = 7
}

# Networking

resource "aws_vpc" "fortress_vpc" {
  count                = "1"
  cidr_block           = "10.138.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = local.name_tag
}

resource "aws_internet_gateway" "fortress_gw" {
  count  = "1"
  vpc_id = aws_vpc.fortress_vpc[0].id

  tags = local.name_tag
}

resource "aws_subnet" "fortress_subnet" {
  count             = "1"
  vpc_id = aws_vpc.fortress_vpc[0].id
  availability_zone = data.aws_availability_zones.available.names[count.index]

  cidr_block              = "10.138.${1 + count.index}.0/24"
  map_public_ip_on_launch = true

  tags = local.name_tag
}

resource "aws_route_table" "fortress_public" {
  count  = "1"
  vpc_id = aws_vpc.fortress_vpc[0].id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.fortress_gw[0].id
  }
  tags = local.name_tag
}

resource "aws_route_table_association" "fortress_subnet_public" {
  count          = "1"
  subnet_id      = aws_subnet.fortress_subnet[count.index].id
  route_table_id = aws_route_table.fortress_public[0].id
}

resource "aws_security_group" "fortress_sg" {
  name        = "${var.project}"
  description = "Allow TLS inbound traffic"
  vpc_id = aws_vpc.fortress_vpc[0].id

  ingress {
    description = "General ingress rule"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # all protocols and ports
    cidr_blocks = concat(["10.128.0.0/9"], [ "80.7.54.175/32", "109.151.183.6/32", data.external.myip.result.my_ip ])
  }

  ingress {
    description = "Anything from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # all protocols and ports
    cidr_blocks = [aws_vpc.fortress_vpc[0].cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.name_tag
}