# Capstone Scope – KijaniKiosk (Track A)

## Problem
We currently have zero environment separation. Every change goes straight to the same cluster namespace. Last month, a bad ConfigMap broke kk-payments for 10 minutes because there was no staging to catch it. Also, we have no alerts – customers report errors before we know about them.

## Track
**A – Infrastructure‑First** (I already have Kubernetes & Jenkins working from earlier weeks)

## In‑Scope (5 items)
1. Create a `kijani-staging` namespace with Terraform (isolated from `default`).
2. Use Ansible to apply staging‑specific ConfigMap (different DB_HOST, log level `debug`).
3. Jenkins pipeline: auto‑deploy to staging on merge to `main`, run a smoke test, then manual approval before production.
4. Prometheus alert rule when kk‑payments error rate >1% over 5 minutes.
5. Connect Week 10 receipt chain – staging kk‑payments writes to a staging S3 bucket that triggers the lambda chain.

## Out‑of‑Scope
- **Multi‑region**: not needed for our current user base (all in one region).
- **Canary deployments**: would overcomplicate the project; we stick with blue/green from Week 7.

## Success Criteria
- A new engineer can run `terraform apply` and get the staging namespace in <5 minutes.
- After merging a PR, Jenkins deploys to staging automatically (no manual step).
- The approval gate blocks production until I click "Approve" – shown in demo.
- Prometheus fires an alert when I artificially inject 5% errors.
- The receipt chain processes a test file in under 30 seconds.

## Architecture Diagram
See `docs/architecture.md` (Mermaid) and attached PNG in the slides.
