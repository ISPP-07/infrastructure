# infrastructure

This is a basic definition for deploying the entire Harmony project (except for the database) on AWS.

This IaC is in responsible for provisioning and deploying the project, defining access policies, generating ssh key, and providing the ssl certificate to achieve a secure connection through https.

> Disclaimer: lack of time and the uncertainty of the actual deployment conditions, have led us to make a number of decisions, deliberately, that incur in bad IaC practices, such as the two-step execution, building of the images on deployment and not doing ip whitelisting. However, they allow a generic and easy to use definition, which was what we were looking for.

## Prerequisites

In order to use this definition, the following configuration is required:
- Terraform installed.
- An AWS account.
- Configure the AWS access keys on the machine you will be deploying to.

## Configuration

The configuration is not fully automatic in this version (although it can be achieved by taking advantage of terraform variables). You can configure the project from the deploy folder.

The strictly necessary configurations in this version are the following:
1. Specify your AWS credentials profile in the `main.tf` file
2. Select the frontend version to deploy in the `Dockerfile.frontend` file
3. In the `env.frontend` file
   1. Replace `{{domain}}` with your domain for the app (do not remove the `/api` suffix)
   2. Configure the rest of the variables (those are not mandatory)
4. Configure the `env.backend` file
   1. Select the desired NGO deployment
   2. Provide the database name and address
5. Specify your email and domain in the `deployment.sh` file
6. Specify your domain in the `nginx.init.conf` file
7. Specify your domain in the `nginx.conf` file

## Deployment

Once the configuration is done, you must perform the following steps.
1. First you will have to run `terraform init` in the root of the project to get the required providers
2. Then run `terraform apply -target=aws_instance.harmony`. Type `yes` and hit `enter` when the program asks for confirmation.
   1. This step will output the public ip of the provisioned instance. You must whitelist this ip in the database service and associate a domain to it.
3. Once the previous step has been completed, run `terraform apply -target=null_resource.deploy_app` and wait for completition

Once the execution of the last command is finished, you will be able to access the service through your domain using https.

## Improvements and future work

- Build the images before deploying and upload them to a registry
- Whitelist ssh inbound cidr blocks
- Automatize domain and email insertions (put them in tfvars along with the AWS profile)
- Improve the security configuration of the nginx server

By addressing the above points, a cleaner, automated and reliable definition can be achieved.