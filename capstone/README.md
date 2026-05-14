# KijaniKiosk Capstone – Track A

## What this project does
Adds a staging environment, pipeline with approval gate, and Prometheus alerts to KijaniKiosk.

## Directory structure
- `docs/` – scope, architecture, governance log, peer log, reflection
- `terraform/` – staging namespace
- `ansible/` – staging ConfigMap
- `pipeline/` – Jenkinsfile
- `observability/` – Prometheus alert rule

## How to run
1. `cd capstone/terraform && terraform apply`
2. `ansible-playbook capstone/ansible/configure-staging.yml`
3. Jenkins pipeline triggers on merge to main

## Known issues
- Smoke test only checks /health (should also check version)
- Terraform state is local (should be remote S3)
- Ansible is overkill here
