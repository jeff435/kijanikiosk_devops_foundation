# KijaniKiosk Capstone - Track A

## What this project does
Adds staging environment, pipeline with approval gate, and Prometheus alerts.

## Directory structure
- `terraform/` - staging namespace
- `ansible/` - staging ConfigMap
- `pipeline/` - Jenkinsfile with approval gate
- `observability/` - Prometheus alert rules
- `k8s/` - Kubernetes manifests
- `docs/` - documentation

## Quick start
```bash
cd capstone/terraform && terraform init && terraform apply -auto-approve
ansible-playbook capstone/ansible/configure-staging.yml
kubectl apply -f capstone/k8s/ -n kijani-staging
