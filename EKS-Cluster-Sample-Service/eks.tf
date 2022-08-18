##Provisions EKS cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name    = "${local.cluster_name}"
  cluster_version = "1.23"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
      ami_type    = "AL2_x86_64"
    }

  eks_managed_node_groups = {
    ##for blue green deployment
    # blue = {}
    sample-service-green = {
        instance_types = ["t3.large"]
        # capacity_type  = "SPOT"
        min_size       = 2
        desired_size   = 4
        max_size       = 6
      }
    }
}

##Applies Kubeconfig to provisioned cluster
resource "null_resource" "kubeconfig"{
  depends_on = [module.eks]

  provisioner "local-exec" {
    command = "aws eks --region ${var.region} update-kubeconfig --name ${local.cluster_name}"
  }
}