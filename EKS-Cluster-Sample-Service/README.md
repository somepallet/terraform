This module provisions an EKS cluster in AWS with the following: VPC, private/public subnets, security groups, EC2s, IAM roles, route tables, elastic ips, NAT gateway, internet gateway, load balancer, ECR repository and cloudwatch logs. Also clones the git repo for the sample-service, creates an app image and deploys it to the ECR and outputs the working loadbalancer url once the terraform apply finishes provisioning.

Prerequisites Installed prior to deploy/update cluster:
    - terraform, docker, git, python, aws cli/configure aws credentials to the default ~/.aws/credentials file, kubectl

Instructions:

To Deploy the sample-service into aws and get a working url:
    - run "terraform init" "terraform plan" & "terraform apply -auto-approve" commands in the working directory "EKS-Cluster-Sample-Service" 

To update the existing cluster with the latest sample-service commits:
    - run "python ./update_script.py"
