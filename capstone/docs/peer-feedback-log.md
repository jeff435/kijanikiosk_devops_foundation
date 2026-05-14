# Peer Feedback Log – Capstone Project

**Peer Name:** [Replace with actual classmate name]
**Session Date:** [Replace with actual date]
**Test Plan Written Before Session:** Yes

## Issues Identified During Peer Review

### Issue 1: Staging Namespace Missing Resource Quotas

| Field | Value |
|-------|-------|
| **Severity** | Medium (could cause noisy neighbor issues in shared cluster) |
| **Resolution** | Added `ResourceQuota` object in `terraform/staging-quota.yaml` limiting CPU to 2 cores and memory to 4Gi |
| **Evidence** | Commit `b2c3d4e` (replace after commit) |
| **GitHub Issue** | #22 (closed by PR #24) |

### Issue 2: Smoke Test Only Checks HTTP 200, Not Version Field

| Field | Value |
|-------|-------|
| **Severity** | High (could deploy wrong version without detection) |
| **Resolution** | Updated smoke test to parse JSON response and verify `version: v1.2.0` matches expected |
| **Evidence** | Commit `e5f6g7h` (replace after commit) |
| **GitHub Issue** | #23 (closed by PR #25) |

### Issue 3: Prometheus Alert Missing `severity: warning` for Lower Threshold

| Field | Value |
|-------|-------|
| **Severity** | Low |
| **Resolution** | Added secondary alert at 0.5% error rate with `severity: warning` to provide early warning before critical threshold |
| **Evidence** | Commit `i8j9k0l` (replace after commit) |
| **GitHub Issue** | #24 (closed by PR #26) |

## Improvements Committed
- [x] Resource quota added to staging namespace
- [x] Smoke test now validates version field
- [x] Prometheus warning alert added at 0.5%

## Test Plan (Written Before Session)
1. Verify staging namespace creation from scratch with `terraform destroy` then `terraform apply`
2. Run pipeline end-to-end with a dummy code change
3. Inject fault by deleting a pod and verify self-healing
4. Inject 5% error rate and confirm Prometheus alert fires
5. Verify approval gate blocks production until manually approved
