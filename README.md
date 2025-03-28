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

## Debugging

If you need to connect to a running container you will need: 

* The aws cli installed - [https://formulae.brew.sh/formula/awscli}](https://formulae.brew.sh/formula/awscli)
* The aws-azure-login installed and be logged in - [https://github.com/aws-azure-login/aws-azure-login](https://github.com/aws-azure-login/aws-azure-login), you can install using ```npm install -g aws-azure-login```.
* The AWS session manager plugin - [https://formulae.brew.sh/cask/session-manager-plugin](https://formulae.brew.sh/cask/session-manager-plugin)
* You'll need aws configured to connect to the correct region [https://stackoverflow.com/questions/75544962/command-to-switch-the-region-on-aws-cli](https://stackoverflow.com/questions/75544962/command-to-switch-the-region-on-aws-cli)

You can check you're logged in by running ```aws s3 ls```, it should be clear if you're logged in on not. 

To list the tasks in the fortress cluster run ```aws ecs list-tasks --cluster fortress```

To display infomation about one of the tasks run ```aws ecs describe-tasks --cluster fortress --task <task ARN>```
** You want the number after the last / not the full arn string.
** It's not very descriptive, it may take trial and error to find the tight task arn. 



