# Architecture Diagram – KijaniKiosk Capstone

```mermaid
graph TB
    A[Push to main] --> B[Jenkins]
    B --> C[Terraform: staging ns]
    C --> D[Ansible: staging ConfigMap]
    D --> E[Deploy kk-payments staging]
    E --> F[Smoke test /health]
    F --> G[Manual approve?]
    G -- Yes --> H[Deploy to production]
    G -- No --> I[Stop]

    subgraph Staging
        J[kk-payments pods]
        K[ConfigMap: staging DB_HOST]
    end

    subgraph Prod
        L[kk-payments pods]
        M[ConfigMap: prod DB_HOST]
    end

    subgraph Observability
        N[Prometheus alert rule]
        O[Error rate >1% → alert]
    end

    H --> L
    E --> J
    F --> O

---

## ✅ Step 4: Create the Terraform file

```bash
cat > capstone/terraform/staging-namespace.tf << 'EOF'
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
