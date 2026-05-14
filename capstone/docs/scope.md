# Capstone Scope – KijaniKiosk (Track A)

## Problem Statement
KijaniKiosk currently has no environment separation. Every code change deploys directly to the same cluster namespace where production runs. Last month, a bad ConfigMap broke kk-payments for 10 minutes because there was no staging environment to catch the error. Additionally, there are no monitoring alerts – customers report errors before the engineering team knows about them.

## Track Selected
**Track A – Infrastructure-First** – I already have Kubernetes and Jenkins working from Weeks 7-9.

## In-Scope Components (5 items)
1. Create a `kijani-staging` namespace provisioned by Terraform, isolated from the default production namespace.
2. Use Ansible to apply staging-specific ConfigMap with different DB_HOST and debug log level.
3. Jenkins pipeline that deploys to staging automatically on merge to main, runs a smoke test, and only offers production approval gate after smoke test passes.
4. Prometheus alert rule that fires when kk-payments error rate exceeds 1% over 5 minutes.
5. Week 10 serverless receipt chain integrated – staging kk-payments writes to staging S3 bucket that triggers the lambda chain.

## Out-of-Scope Items
- **Multi-region deployment** – Not needed because KijaniKiosk's user base is currently in a single region.
- **Canary deployments** – Would overcomplicate this project; we continue using blue/green from Week 7.

## Success Criteria (Measurable)
- A new engineer can run `terraform apply` and have the staging namespace ready in under 5 minutes.
- After merging a PR to main, Jenkins automatically deploys to staging with no manual steps.
- The approval gate blocks production deployment until a reviewer clicks "Approve" – demonstrated in the live demo.
- Prometheus fires an alert when I artificially inject 5% errors using a fault injection script.
- The serverless receipt chain processes a test receipt file end-to-end in under 30 seconds (logs shown in demo).

## Architecture Diagram
See `docs/architecture.md` for Mermaid version and attached PNG in the slide deck.
