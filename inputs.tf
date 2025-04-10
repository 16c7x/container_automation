## Input variables

variable "aws_region" {
  description = "A reasonably close region"
  default     = "eu-west-1"
}

variable "key" {
  description = "AWS Key pair"
  default     = "andrew.jones"
}

variable "project" {
  description = "Project name"
  default     = "fortress"
}

variable "cassandra_nodes" {
  description = "How many casandra instances to build"
  default     = "3" 
}