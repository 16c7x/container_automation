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

# Contain all the networking configuration for readability
module "networking" {
  source    = "git@github.com:16c7x/terraform_networking.git"
  id        = "${var.project}"
  project   = "${var.project}"
  allow      = concat(["10.128.0.0/9"], [ "80.7.54.175/32", "109.151.183.6/32", data.external.myip.result.my_ip ])
  to_create = true
  subnet    = null
}
