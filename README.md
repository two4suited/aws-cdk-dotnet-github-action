# Github Action for using .Net Core Version of CDK

Based off of this code base: https://github.com/youyo/aws-cdk-github-actions

```yaml
name: CI

on: [push]

jobs:
  aws_cdk:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: cdk synth
        id: synth
        uses: two4suited/aws-cdk-dotnet-github-action@master
        with:
          cdk_subcommand: 'synth'
          cdk_version: '1.24.0'
          working_dir: 'infrastructure'
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_DEFAULT_REGION: 'us-west-2'
      - name: cdk deploy
        uses: two4suited/aws-cdk-dotnet-github-action@master
        with:
          cdk_subcommand: 'deploy'
          actions_comment: false
          args: '--require-approval never'
          working_dir: 'infrastructure'
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_DEFAULT_REGION: 'us-west-2'

```

## Inputs
- `cdk_subcommand` **Required** AWS CDK subcommand to execute.
- `cdk_version` AWS CDK version to install. (default: 'latest')
- `cdk_stack` AWS CDK stack name to execute. (default: '*')
- `working_dir` AWS CDK working directory. (default: '.')

## Outputs

- `status_code` Returned status code.

## ENV

- `AWS_ACCESS_KEY_ID` **Required**
- `AWS_SECRET_ACCESS_KEY` **Required**

Recommended to get `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` from secrets.