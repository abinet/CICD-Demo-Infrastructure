terraform {
  required_version = ">=0.13"

  backend "local" {
    path = ".tf.tfstate"
  }

  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.10.1"
    }
  }
}

provider "kubectl" {
  config_path = "~/.kube/config"
}

provider "helm" {
  repository_config_path = "${path.module}/.helm/repositories.yaml"
  repository_cache = "${path.module}/.helm"
  kubernetes {
    config_path = "~/.kube/config"
  }
}
