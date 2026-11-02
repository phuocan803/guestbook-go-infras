#!/bin/bash

TEMPLATE_STACK_NAME="Pipeline-prebuild-stack"
TEMPLATE_BODY_FILE="infras/aws/code_pipeline/prebuild-cfn.yaml"

STACK_NAME="iac-devops-fml"
TEMPLATE_PATH="main-cfn.yaml"
OUTPUT_FILE="output.json"
BRANCH_NAME="master"
RESOURCE_PERMISSIONS='{\"Version\":\"2012-10-17\",\"Statement\":[{\"Sid\":\"PermissionsForCloudFormation\",\"Effect\":\"Allow\",\"Action\":\"*\",\"Resource\":\"*\"}]}'
CODE_PIPELINE_NAME="Pipeline1"
CONNECTION_ARN="arn:aws:codeconnections:us-east-1:381492301125:connection/f8a29f05-dbad-4263-b90c-7ed8f00d1115"
FULL_REPOSITORY_ID="phuocan803/guestbook-go-infras"
RETENTION_POLICY="Delete"
PARAMETER_OVERRIDES="-"

PARAMETERS=$(cat <<EOF | jq -c .
[
  {
    "ParameterKey": "BranchName",
    "ParameterValue": "$BRANCH_NAME"
  },
  {
    "ParameterKey": "CloudFormationResourcePermissions",
    "ParameterValue": "$RESOURCE_PERMISSIONS"
  },
  {
    "ParameterKey": "CodePipelineName",
    "ParameterValue": "$CODE_PIPELINE_NAME"
  },
  {
    "ParameterKey": "ConnectionArn",
    "ParameterValue": "$CONNECTION_ARN"
  },
  {
    "ParameterKey": "FullRepositoryId",
    "ParameterValue": "$FULL_REPOSITORY_ID"
  },
  {
    "ParameterKey": "OutputFileName",
    "ParameterValue": "$OUTPUT_FILE"
  },
  {
    "ParameterKey": "ParameterOverrides",
    "ParameterValue": "$PARAMETER_OVERRIDES"
  },
  {
    "ParameterKey": "RetentionPolicy",
    "ParameterValue": "$RETENTION_POLICY"
  },
  {
    "ParameterKey": "StackName",
    "ParameterValue": "$STACK_NAME"
  },
  {
    "ParameterKey": "TemplatePath",
    "ParameterValue": "$TEMPLATE_PATH"
  }
]
EOF
)

aws cloudformation create-stack \
  --stack-name "$TEMPLATE_STACK_NAME" \
  --template-body "file://$TEMPLATE_BODY_FILE" \
  --parameters "$PARAMETERS" \
  --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND
