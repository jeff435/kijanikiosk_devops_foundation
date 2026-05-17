# AI Governance Log – Capstone Project

## Entry 1: Jenkins Approval Gate Syntax

| Field | Value |
|-------|-------|
| **What the AI produced** | `input message: 'Deploy to production?'` without `submitter` or `ok` parameters |
| **What it got wrong** | The pipeline would hang indefinitely because no user was authorized to approve |
| **What I changed** | Added `submitter: 'admin,platform-team'` and `parameters` block |
| **Why** | To ensure only authorized people can approve and to capture an audit trail |
| **Commit hash** | `a1b2c3d` (replace after commit) |
| **Checklist item** | Control 3: All pipeline changes must be reviewed |
| **Time spent** | 20 minutes |

## Entry 2: Prometheus Error Rate Query

| Field | Value |
|-------|-------|
| **What the AI produced** | `increase(kube_pod_container_status_restarts_total[5m]) > 5` |
| **What it got wrong** | The requirement was error rate, not pod restarts |
| **What I changed** | Replaced with `sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m])) > 0.01` |
| **Why** | Error rate directly measures customer-impacting failures |
| **Commit hash** | `d4e5f6g` (replace after commit) |
| **Checklist item** | Control 4: Monitoring config must be reviewed |
| **Time spent** | 15 minutes |
