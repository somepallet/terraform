import os
import boto3
import docker
from git import Repo


def main():
    """Builds sample-service, pushes it to ecr and redeploys eks"""

    current_repo = os.getcwd() + "/sample-service"
    aws_region = 'us-east-1'
    service_name = "sample-service-ecr"
    git_url = input("Please enter git url (leaving this blank & pressing enter will default to the original "
                    "sample-service repo): ")
    docker_tag = input("Please enter a docker tag: ")

    # clones git repo to working directory
    if git_url == "":
        Repo.clone_from('https://github.com/CitrineInformatics/sample-service.git', current_repo)
    else:
        Repo.clone_from(f"{git_url}", current_repo)

    # AWS ECR credentials
    ecr_client = boto3.client('ecr', region_name=aws_region)

    ecr_credentials = (
        ecr_client
        .get_authorization_token()
        ['authorizationData'][0])

    # gets ecr url
    ecr_url = ecr_credentials['proxyEndpoint'].replace("https://", "")

    # builds docker images
    docker_srv = docker.from_env()
    image_one, build_log_one = docker_srv.images.build(
        path=current_repo, tag=f"{ecr_url}/{service_name}", rm=True)


    # tags images for AWS ECR
    image_one.tag(f"{ecr_url}/{service_name}", tag='latest')
    image_one.tag(f"{ecr_url}/{service_name}", tag=docker_tag)

    # pushes image to AWS ECR
    os.system(f"aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin {ecr_url}")
    os.system(f"docker image push {ecr_url}/{service_name}:latest")
    os.system(f"docker image push {ecr_url}/{service_name}:{docker_tag}")
    os.system("kubectl rollout restart deployment microservice-deployment")
    print("****The Docker Image has been tagged, pushed to the ECR repo and the EKS-Cluster has been redeployed****")


def clean_up(path):
    """deletes the cloned repository sample-service"""
    try:
        os.rmdir(path)
    except OSError:
        pass


if __name__ == '__main__':
    main()


# clean_up(current_repo)
