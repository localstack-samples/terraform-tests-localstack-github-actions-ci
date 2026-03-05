# Serverless Image Resizer with LocalStack & Terraform

This is a simple example of how to use LocalStack to create a serverless image resizer using AWS Lambda and S3. The image resizer is implemented in Python and uses the Python Imaging Library (PIL) to resize images.

## Requirements

- LocalStack Pro with the [`localstack` CLI](https://docs.localstack.cloud/getting-started/installation/#localstack-cli).
- [Terraform CLI](https://www.terraform.io/downloads) with the [`tflocal` wrapper](https://github.com/localstack/terraform-local).
- [AWS CLI](https://docs.localstack.cloud/user-guide/integrations/aws-cli/) with the [`awslocal` wrapper](https://docs.localstack.cloud/user-guide/integrations/aws-cli/#localstack-aws-cli-awslocal).

## Start LocalStack

Start LocalStack Pro with the `LOCALSTACK_AUTH_TOKEN` pre-configured:

```bash
export LOCALSTACK_AUTH_TOKEN=<your-auth-token>
make start
make ready
```

## Build the Lambda function

To build the Lambda function, you need to create a ZIP archive with the Python code and the required dependencies. You can use the following commands to create the ZIP archive:

```bash
docker run --platform linux/x86_64 --rm -v "$PWD":/var/task "public.ecr.aws/sam/build-python3.11" /bin/sh -c "pip3 install -r requirements.txt -t libs; exit"

cd libs && zip -r ../lambda.zip . && cd ..
zip lambda.zip lambda_function.py
rm -rf libs
```

## Deploy the infrastructure

To run this example you need to execute:

```bash
tflocal init
tflocal plan
tflocal apply --auto-approve
```

After the Terraform script has been applied, you can upload an image to the S3 bucket and check the resized image in the `resized` folder. Here is an example:

```bash
awslocal s3 cp image.png s3://original-images/image.png
awslocal s3 ls s3://resized-images
```

## Run the tests

You can run tests using the Terraform Test framework:

```bash
tflocal test
```
