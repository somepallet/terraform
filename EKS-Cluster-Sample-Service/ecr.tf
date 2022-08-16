##Clones git repo to local
resource "null_resource" "git_clone" {
  provisioner "local-exec" {
    command = "git clone https://github.com/CitrineInformatics/sample-service.git"
  }
}

##Creats ECR Repository
resource "aws_ecr_repository" "sample-service-ecr" {
    name          = "sample-service-ecr"
    force_delete  = true
}

##Creats Docker image and pushes to ECR
resource "docker_registry_image" "sample-service-docker" {
    depends_on  =   [null_resource.git_clone]
    name        =   "${aws_ecr_repository.sample-service-ecr.repository_url}:latest"
    build {
        context    = "./sample-service"
        dockerfile = "Dockerfile"
    }  
}
