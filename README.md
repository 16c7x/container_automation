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
