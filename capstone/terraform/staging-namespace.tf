terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
  }
}

resource "kubernetes_namespace" "staging" {
  metadata {
    name = "kijani-staging"
    labels = {
      environment = "staging"
      managed-by  = "terraform"
    }
  }
}

resource "kubernetes_config_map" "staging_config" {
  metadata {
    name      = "kk-payments-config"
    namespace = kubernetes_namespace.staging.metadata[0].name
  }

  data = {
    DB_HOST   = "staging-postgres.kijani-staging.svc.cluster.local"
    LOG_LEVEL = "debug"
  }
}
