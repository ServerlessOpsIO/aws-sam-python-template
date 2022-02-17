#!/bin/sh

# Initialize project
make init

# Set S3 Bucket location by querying S3
echo "s3_bucket = \"$(aws cloudformation describe-stack-resource --stack-name aws-sam-cli-managed-default --logical-resource-id SamCliSourceBucket | jq -r'.StackResourceDetail.PhysicalResourceId')\"" >> samconfig.toml

# Initialize git
git init
git add ./
git commit -m "Initial commit"

