# AWS SAM Python 3.7 Template
AWS SAM [Cookiecutter](https://github.com/audreyr/cookiecutter) template for creating a Python 3.7 project.

This template can be used by SAM CLI to generate a new project skeleton. During the process of creating a new project you will be asked to select options for how your project should be configured. A description of these options is found in the **Options** section of this README. This template does its best to handle as much boilerplate work as possible and guide people towards using best practices.

When creating a new project the following will be created.

* An AWS SAM template
* A single Lambda function
    * Use this function as an example of what any additional functions in the project should look like.
* A sample event message
    * Adjust the event's message to suit your needs.

Depending on the options selected the following may also be created or configured.

* Function event source configuration
    * Configures function to be triggered by event source
    * May add parameters for configuring the function to use the event source
* Event destination AWS resource
    * Adds AWS resource event data is expected to be passed to (eg. DynamoDB table, Kinesis stream, S3 bucket, SNS topic, SQS queue)
    * Adds IAM policy statement to allow function to write to destination
    * Adds CloudFormation stack output for service discovery
* Dead-letter queue or topic for failed function invocations
* CloudWatch alarm/event topic
    * Other services may subscribe to this in order to process alarms and events

## Usage
### 1. Install AWS SAM CLI
Installing and using the AWS SAM CLI requires having Python installed. Once installed use `pip` to install AWS SAM CLI.

```
$ pip install aws-sam-cli
```

More extensive instructions can be found here: [Installing the AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html)


### 2. **Create a `~/.cookiecutter.rc` file**
Create a configuration file to fill in a few default values during project initialization

```
default_context:
    author_name: "Tom McLaughlin"
    author_email: "tom@serverlessops.io"
    author_github: "tmclaugh"

abbreviations:
    gh: https://github.com/{0}.git
    bb: https://bitbucket.org/{0}
```

### 3. Create a new project
Create a new project by running the command below. This will ask you a series of questions and customize the generated project based on your answers.

```
$ sam init --location gh:serverlessops/sam-py37
```

## Options


Option | Description
------------------------------------------------- | ---------------------------------------------------------------------------------
`service_name`              |   Name of service
`service_description`       |   Description of service
`function_name`             |   Name of service function
`function_description`      |   Description of service function
`copyright_holder`          |   Copyright holder of software
`author_name`               |   Author name
`author_email`              |   Author email
`year`                      |   Year (for copyright)
`event_source`              |   Select a function event source. (Use `other` to skip configuration)
`event_destination`         |   Select a function event destination. (Use `other` to skip configuration)
`dlq_type`                  |   Add a function dead-letter queue or topic. (Use `none` to skip configuration)
`enable_cloudwatch_topic`   |   Create an SNS topic for CloudWatch alarms and events

