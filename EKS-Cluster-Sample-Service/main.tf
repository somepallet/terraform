##Initiating Providers
terraform {
  required_providers {
    aws    = {
        source  = "hashicorp/aws"
    }
    docker = {
        source  = "kreuzwerker/docker"
        version = "2.20.2"
    }
  }
}

provider "aws" {
  profile   = "${var.profile}"
  region    = "${var.region}"

  ##If terraform doesn't pick up aws credentials file
  /*
  shared_credentials_file = ""
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  */

}

provider "docker" {
  registry_auth {
    address  = local.aws_ecr_url
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}
