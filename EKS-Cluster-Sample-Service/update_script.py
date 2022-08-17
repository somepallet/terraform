import base64
import os
import boto3
import docker
import shutil
from git import Repo


def main():
    """Builds sample-service, pushes it to ecr and redeploys eks"""

    current_repo = os.getcwd() + "/sample-service"
    aws_region = 'us-east-1'
    service_name = "sample-service-ecr"
    Repo.clone_from('https://github.com/CitrineInformatics/sample-service.git', current_repo)

    # builds docker image
    docker_srv = docker.from_env()
    image, build_log = docker_srv.images.build(
        path=current_repo, tag=service_name, rm=True)

    # AWS ECR credentials
    ecr_client = boto3.client('ecr', region_name=aws_region)

    ecr_credentials = (
        ecr_client
        .get_authorization_token()
        ['authorizationData'][0])

    # gets ecr url
    ecr_url = ecr_credentials['proxyEndpoint'].replace("https://", "")

    # tags image for AWS ECR
    image.tag(f"{ecr_url}/{service_name}", tag='latest')

    # pushes image to AWS ECR
    os.system(f"aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin {ecr_url}")
    os.system(f"docker image push {ecr_url}/{service_name}:latest")
    os.system("kubectl rollout restart deployment microservice-deployment")


def clean_up(path):
    """deletes the cloned repository sample-service"""
    try:
        os.rmdir(path)
    except OSError:
        pass


if __name__ == '__main__':
    main()


# clean_up(current_repo)
