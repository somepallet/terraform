##Variables used in the EKS-Cluster module
variable "region" {
    description = "AWS region currently being used"
    default = "us-east-1"
}

variable "profile" {
    default = "default"
    description = "AWS credentials profile"
}

variable "env" {
    default = "dev"
    description = "AWS environment tag"
}

variable "git_url" {
    default = "https://github.com/CitrineInformatics/sample-service.git"
    description = "git repo url"
}
##If terraform doesn't pick up aws credentials##
/*
variable "access_key" {
 default = "<Access-Key>"
}
variable "secret_key" {
   default = "<Secret-Key>"
}
*/