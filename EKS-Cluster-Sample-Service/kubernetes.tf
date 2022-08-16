##EKS service deployment configuration
resource "kubernetes_deployment" "sample-service" {
  metadata {
    name = "microservice-deployment"
    labels = {
      app  = "sample-service"
    }
  }

spec {
    replicas = 2
selector {
      match_labels = {
        app  = "sample-service"
      }
    }
template {
      metadata {
        labels = {
          app  = "sample-service"
        }
      }
spec {
        container {
          image = "${aws_ecr_repository.sample-service-ecr.repository_url}:latest"
          name  = "sample-service-container"
          port {
            container_port = 5000
         }
        }
      }
    }
  }
}

resource "kubernetes_service" "sample-service" {
  depends_on = [kubernetes_deployment.sample-service]
  metadata {
    name = "sample-service-v1"
  }
  spec {
    selector = {
      app = "sample-service"
    }
    port {
      port        = 80
      target_port = 5000
    }
type = "LoadBalancer"
  }
}