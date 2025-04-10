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

To login run ```aws-azure-login``` 

You can check you're logged in by running ```aws s3 ls```, it should be clear if you're logged in on not. 

To list the tasks in the fortress cluster run ```aws ecs list-tasks --cluster fortress``` the output should look something like this

```json
{
    "taskArns": [
        "arn:aws:ecs:eu-west-1:574184548053:task/fortress/1aab2fc7e1c84fb28d74c334ebff580b",
        "arn:aws:ecs:eu-west-1:574184548053:task/fortress/69eefac82db84b638c5851bc69cfcf77"
    ]
}
```

You will have to cross reference the id's here with those listed on the AWS console for the task. Login to the AWS console and go to "Elastic Container Service", select the cluster, click the "Tasks" tab and look for the Task in the list.

```bash
aws ecs execute-command --cluster <cluster name>> --task <task ID> --container <container name> --command "/bin/sh" --interactive
```

In this example I'll log into the fortress cluster, to task id 1aab2fc7e1c84fb28d74c334ebff580b (from the task list above) and I know it's running on a Docker container called cassandra.

```bash
aws ecs execute-command --cluster fortress --task 1aab2fc7e1c84fb28d74c334ebff580b --container cassandra --command "/bin/sh" --interactive
```


