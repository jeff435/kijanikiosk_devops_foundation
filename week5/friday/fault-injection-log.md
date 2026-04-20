# Fault Injection Log - KijaniKiosk CI Pipeline

**Purpose:** Document pipeline behaviour when each stage fails independently.

---

## Fault 1: Lint Stage Failure

| Property | Value |
|----------|-------|
| **Fault injected** | Syntax error in source file (missing closing brace in payments.js) |
| **Observed behaviour** | Lint: ❌ RED. Build: ⬜ GREY. Verify: ⬜ GREY. Archive: ⬜ GREY. Publish: ⬜ GREY |
| **Design rationale** | Lint is cheapest/fastest (30s). Fail fast prevents wasting 4+ minutes on bad syntax. |

---

## Fault 2: Build Stage Failure

| Property | Value |
|----------|-------|
| **Fault injected** | Removed required export causing npm run build to exit with code 1 |
| **Observed behaviour** | Lint: ✅ GREEN. Build: ❌ RED. Verify: ⬜ GREY. Archive: ⬜ GREY. Publish: ⬜ GREY |
| **Design rationale** | Build produces artifact that all later stages depend on. No build output = nothing to test/publish. |

---

## Fault 3: Test Stage Failure (within parallel Verify)

| Property | Value |
|----------|-------|
| **Fault injected** | Modified test to expect true when actual value is false |
| **Observed behaviour** | Lint: ✅ GREEN. Build: ✅ GREEN. Verify/Test: ❌ RED. Verify/SecurityAudit: ✅ GREEN. Archive: ⬜ GREY. Publish: ⬜ GREY |
| **Design rationale** | Both parallel branches run to completion for maximum diagnostic information. |

---

## Fault 4: Security Audit Failure (within parallel Verify)

| Property | Value |
|----------|-------|
| **Fault injected** | Added vulnerable dependency (lodash@4.17.19) to package.json |
| **Observed behaviour** | Lint: ✅ GREEN. Build: ✅ GREEN. Verify/Test: ✅ GREEN. Verify/SecurityAudit: ❌ RED. Archive: ⬜ GREY. Publish: ⬜ GREY |
| **Design rationale** | Security vulnerabilities must block publication to Nexus. Vulnerable package never reaches registry. |

---

## Fault 5: Publish Stage Failure

| Property | Value |
|----------|-------|
| **Fault injected** | Used incorrect Nexus URL (localhost instead of host IP) |
| **Observed behaviour** | Lint: ✅ GREEN. Build: ✅ GREEN. Verify: ✅ GREEN. Archive: ✅ GREEN. Publish: ❌ RED |
| **Design rationale** | Archive stage already stored artifact in Jenkins. Publish failure is infrastructure/connectivity issue, not code quality. |

---

## Restoration Confirmation

After each fault, the pipeline was restored to green by reverting the fault injection. All five faults were independently tested.

**Final pipeline status:** ✅ GREEN (under 10 minutes)
