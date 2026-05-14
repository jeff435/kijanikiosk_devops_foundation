# Capstone Project Reflection

## 1. What did you get wrong? (Be specific)

I assumed that reusing the same Kubernetes Deployment manifest for both staging and production would work without changes. I was wrong because the `imagePullSecrets` also needed to be different – staging uses a different container registry with its own credentials. This caused `ImagePullBackOff` errors for two hours until I realized the problem. In hindsight, I should have used Kustomize with overlays from the beginning. That would have allowed me to patch only the differences (namespace, secrets, config) while keeping the base manifest identical. Instead, I wasted time debugging what looked like a network issue but was actually a credentials problem.

## 2. Most important thing you learned (and when it appeared)

The most important thing came from **Week 8: the `HEALTHCHECK --start-period` directive**. Before Week 8, I thought a pod was "ready" as soon as `kubectl get pods` showed `Running`. But my kk-payments application needs 15 seconds to initialize database connections and load configuration. Without a proper `startPeriod`, Kubernetes kept restarting the pod during normal startup, creating a crash loop that looked like a serious bug but was actually just an impatient health check.

This changed how I think about readiness vs. liveness probes. Readiness is for removing traffic during startup or temporary overload. Liveness is for detecting a truly deadlocked process. Setting `startPeriod` to 20 seconds completely solved the false restart problem. I now always add a conservative `startPeriod` to every deployment.

## 3. If you had a second pass (another week), what would you change?

**Add:**
- Canary deployment stage using Flagger instead of just blue/green. The approval gate is manual; canary would automatically roll back if metrics degrade.
- Remote Terraform state (S3 + DynamoDB locking). Right now the state is local, which is risky for a team.
- Proper SSL/TLS termination on the Ingress instead of plain HTTP.

**Remove:**
- The Ansible playbook. It's overkill – I could have applied the ConfigMap directly with `kubectl apply` from the pipeline. Ansible adds unnecessary complexity and another tool to maintain.

**Change:**
- The smoke test currently only checks `/health` returns 200. I would change it to also call a mock payment endpoint (e.g., `/test-payment`) to verify business logic, not just HTTP status.
- The Prometheus alert threshold. 1% might be too high for a payments service. I would start at 0.5% and adjust after observing real traffic patterns.

**One more thing:** I would absolutely make the release process fully automated. Right now the approval gate requires a human click – that's fine for the first production deploy, but for subsequent hotfixes I would add an option to skip approval with a justified reason.
