terraform {
  required_version = ">= 1.13"
  required_providers {
    kustomization = {
      source  = "kbst/kustomization"
      version = "0.9.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "kustomization" {
  kubeconfig_path = "~/.kube/config"
}