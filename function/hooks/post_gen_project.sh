#!/bin/sh -x

echo "Copying files from {{cookiecutter.tmp_dir}}"

find . -type f | cpio -pdm ..

echo "Add the following to your template.yml file."

cat <<EOF
Resources:
  {{cookiecutter.function_name}}:
    Type: AWS::Serverless::Function
    Properties:
      Description: "{{cookiecutter.function_description}}"
      CodeUri: src/handlers/{{cookiecutter.function_name}}
      Handler: function.handler
      Runtime: python{{ cookiecutter.python_version }}
      MemorySize: 128
      Timeout: 3
{%- if cookiecutter.dlq_type != "none" %}
      DeadLetterQueue:
{%- if cookiecutter.dlq_type == "sqs" %}
        Type: 'SQS'
        TargetArn:
          Fn::GetAtt: {{cookiecutter.function_name}}DlqQueue.Arn
{%- elif cookiecutter.dlq_type == "sns" %}
        Type: 'SNS'
        TargetArn:
          Ref: {{cookiecutter.function_name}}DlqTopic
{%- endif %}
{%- endif %}
      Policies:
        - Statement:
          - Effect: "Allow"
            Action:
              - "ssm:GetParameter"
            Resource: !Sub "arn:aws:ssm:\${AWS::Region}:\${AWS::AccountId}:parameter/\${ServiceName}/\${ServiceEnv}/*"
{%- if cookiecutter.event_destination != "other" %}
        - Statement:
{%- if cookiecutter.event_destination == "dynamodb" %}
          - Effect: "Allow"
            Action:
              - "dynamodb:<<DDB_ACTION>>"
            Resource:
              Fn::GetAtt:
                - DynamoDBTable
                - Arn
{%- elif cookiecutter.event_destination == "kinesis" %}
          - Effect: "Allow"
            Action:
              - "kinesis:<<KINESIS_ACTION>>"
            Resource:
              Fn::GetAtt:
                - KinesisStream
                - Arn
{%- elif cookiecutter.event_destination == "s3" %}
          - Effect: "Allow"
            Action:
              - "s3:<<S3_ACTION>>"
            Resource:
              Fn::GetAtt:
                - S3Bucket
                - Arn
{%- elif cookiecutter.event_destination == "sns" %}
          - Effect: "Allow"
            Action:
              - "sns:<<SNS_ACTION>>"
            Resource:
              Ref: SnsTopic
{%- elif cookiecutter.event_destination == "sqs" %}
          - Effect: "Allow"
            Action:
              - "sqs:<<SQS_ACTION>>"
            Resource:
              Fn::GetAtt:
                - SqsQueue
                - Arn
{%- endif %}
{%- endif %}

{%- if cookiecutter.event_source != "other" %}
      Events:
{%- if cookiecutter.event_source == "apigateway" %}
        Apig:
          Type: Api
          Properties:
            RestApiId:
              Ref: RestApi
            #Path: <<required: PATH>>
            #Method: <<required: METHOD>>
{%- elif cookiecutter.event_source == "cloudwatch-event" %}
        CloudWatchEvent:
          Type: CloudWatchEvent
          Properties:
            Pattern: <<PATTERN_OBJECT>>
{%- elif cookiecutter.event_source == "cloudwatch-logs" %}
        CloudWatchLogs:
          Type: CloudWatchLogs
          Properties:
            LogGroupName:
              Ref: EventCloudwatchLogGroupName
            #FilterPattern:
            #  Ref: EventCloudwatchLogGroupFilterPattern
{%- elif cookiecutter.event_source == "dynamodb" %}
        DynamoDB:
          Type: DynamoDB
          Properties:
            Stream:
              Ref: EventDynamoDBStreamArn
            StartingPosition:
              Ref: EventDynamoDBStreamStartingPosition
            BatchSize:
              Ref: EventDynamoDBStreamBatchSize
            Enabled:
              Ref: EventDynamoDBStreamEnabled
{%- elif cookiecutter.event_source == "kinesis" %}
        Kinesis:
          Type: Kinesis
          Properties:
            Stream:
              Ref: EventKinesisStreamArn
            StartingPosition:
              Ref: EventKinesisStreamStartingPosition
            BatchSize:
              Ref: EventKinesisStreamBatchSize
            Enabled:
              Ref: EventKinesisStreamEnabled
{%- elif cookiecutter.event_source == "s3" %}
        S3:
          Type: S3
          Properties:
            Bucket:
              Ref: EventS3Bucket
            Events:
              Ref: EventS3EventsList
            #Filter:
            #  S3Key:
            #    Ref: EventS3FilterRuleList
{%- elif cookiecutter.event_source == "schedule" %}
        Schedule:
          Type: Schedule
          Properties:
            Schedule:
              Ref: EventSchedule
{%- elif cookiecutter.event_source == "sns" %}
        SNS:
          Type: SNS
          Properties:
            Topic:
              Ref: EventSnsTopicArn
            #FilterPolicy:
            #  <<FILTER_POLICY>>
{%- elif cookiecutter.event_source == "sqs" %}
        SQS:
          Type: SQS
          Properties:
            Queue:
              Ref: EventSqsQueueArn
            BatchSize:
              Ref: EventSqsQueueBatchSize
            Enabled:
              Ref: EventSqsQueueEnabled
{%- endif %}
{%- endif %}

{%- if cookiecutter.dlq_type != "none" %}
{% if cookiecutter.dlq_type == "sqs" %}
  {{cookiecutter.function_name}}DlqQueue:
    Type: AWS::SQS::Queue
{% elif cookiecutter.dlq_type == "sns" %}
  {{cookiecutter.function_name}}DlqTopic:
    Type: AWS::SNS::Topic
{%- endif %}
{%- endif %}


Outputs:
{% if cookiecutter.dlq_type != "none" %}
{%- if cookiecutter.dlq_type == "sqs" %}
  {{cookiecutter.function_name}}DlqQueueArn:
    Description: "ARN of DLQ"
    Value:
      Fn::GetAtt: {{cookiecutter.function_name}}DlqQueue.Arn
    Export:
      Name:
        Fn::Sub: "\${AWS::StackName}-{{cookiecutter.function_name}}DlqQueueArn"

  {{cookiecutter.function_name}}DlqQueueName:
    Description: "Name of DLQ"
    Value:
      Fn::GetAtt: {{cookiecutter.function_name}}DlqQueue.QueueName
    Export:
      Name:
        Fn::Sub: "\${AWS::StackName}-{{cookiecutter.function_name}}DlqQueueName"

  {{cookiecutter.function_name}}DlqQueueUrl:
    Description: "Url of DLQ"
    Value:
      Ref: {{cookiecutter.function_name}}DlqQueue
    Export:
      Name:
        Fn::Sub: "\${AWS::StackName}-{{cookiecutter.function_name}}DlqQueueUrl"

{%- elif cookiecutter.dlq_type == "sns" %}
  {{cookiecutter.function_name}}DlqTopicArn:
    Description: "ARN of DLQ topic"
    Value:
      Ref: {{cookiecutter.function_name}}DlqTopic
    Export:
      Name:
        Fn::Sub: "\${AWS::StackName}-{{cookiecutter.function_name}}DlqTopicArn"

  {{cookiecutter.function_name}}DlqTopicName:
    Description: "Name of DLQ topic"
    Value:
      Fn::GetAtt: {{cookiecutter.function_name}}DlqTopic.TopicName
    Export:
      Name:
        Fn::Sub: "\${AWS::StackName}-{{cookiecutter.function_name}}DlqTopicName"
{%- endif %}
{%- endif %}

EOF

# FIXME: This don't work.
rmdir .
