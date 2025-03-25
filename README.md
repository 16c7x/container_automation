# README

## Docker container

To build and test this locally

``` bash
docker build -t webserver .
docker run -p 8080:80 webserver
```

## To view

[http://localhost:8080]

## To stop

``` bash
docker ps
docker stop <container id>
```

or just ctrl+d

## GitHub

The Docker container is built with a Github action, it needs to be able to login to Dockerhub to push th container.
In the project go to Settings -> Secrets and variables -> Actions, and ensure the following are set;

* DOCKERHUB_TOKEN
* DOCKERHUB_USERNAME

## AWS/Terraform

### Reference material

This was usefull to manualy get Fargate up and running [https://www.youtube.com/watch?v=1n46Nudo6Yo](https://www.youtube.com/watch?v=1n46Nudo6Yo)
This is a good reference for building it into Terraform [https://github.com/WillBrock/terraform-ecs](https://github.com/WillBrock/terraform-ecs)