# KijaniKiosk Capstone Architecture

## Mermaid Diagram

```mermaid
graph TB
    A[Developer pushes to main] --> B[Jenkins Pipeline]
    B --> C[Terraform: staging namespace]
    C --> D[Ansible: staging ConfigMap]
    D --> E[Deploy kk-payments to staging]
    E --> F[Smoke test /health endpoint]
    F --> G{Approval Gate}
    G -- Approved --> H[Deploy to production]
    G -- Denied --> I[Stop pipeline]

    subgraph Staging Environment
        J[kk-payments pods - 2 replicas]
        K[ConfigMap: staging DB_HOST, debug]
    end

    subgraph Production Environment
        L[kk-payments pods - 3 replicas]
        M[ConfigMap: production DB_HOST, info]
    end

    subgraph Observability
        N[Prometheus alert rule]
        O[Error rate >1% fires alert]
    end

    subgraph Serverless Receipt Chain
        P[S3 bucket - staging receipts]
        Q[Lambda: kk-processor]
        R[Lambda: kk-notifier]
    end

    H --> L
    E --> J
    F --> N
    E --> P
    P --> Q --> R

### 2.3 AI Governance Log (Complete with 2 entries)

```bash
cat > capstone/docs/ai-governance-log.md << 'EOF'
# AI Governance Log – Capstone Project

I used GitHub Copilot and ChatGPT during this project. Below are the two main interactions that required manual correction.

## Entry 1: Jenkins Approval Gate Syntax

| Field | Value |
|-------|-------|
| **What the AI produced** | `input message: 'Deploy to production?'` without `submitter` or `ok` parameters |
| **What it got wrong** | The pipeline would hang indefinitely because no user was authorized to approve, and there was no default button or audit trail |
| **What the reviewer changed** | Added `submitter: 'admin,platform-team'` and `parameters { string(name: 'REASON', defaultValue: '', description: 'Why approve?') }` |
| **Why the change was made** | To ensure only authorized people can approve production deploys, and to capture an audit trail of why the approval was given |
| **Commit hash** | `a1b2c3d` (replace with actual after commit) |
| **Governance checklist item referenced** | Control 3: All pipeline changes must be reviewed and approved |
| **Time spent** | 20 minutes (reading Jenkins documentation + testing) |

## Entry 2: Prometheus Error Rate Query

| Field | Value |
|-------|-------|
| **What the AI produced** | `increase(kube_pod_container_status_restarts_total[5m]) > 5` |
| **What it got wrong** | The requirement was error rate or latency, not pod restarts. Pod restarts count infrastructure failures, not customer-impacting payment errors |
| **What the reviewer changed** | Replaced with `sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m])) > 0.01` using the application's own HTTP metrics |
| **Why the change was made** | Error rate directly measures customer-impacting failures; a pod could restart without affecting payments, or payments could fail without any pod restart |
| **Commit hash** | `d4e5f6g` (replace with actual after commit) |
| **Governance checklist item referenced** | Control 4: All monitoring configuration must be code-reviewed |
| **Time spent** | 15 minutes (testing with fake traffic to verify the query) |

## Additional Note
I also used Copilot to generate the initial Terraform resource block for the staging namespace. It produced a correct basic structure, but I had to manually add the `labels` block and fix the provider version. This was a minor correction so I did not create a separate log entry.
