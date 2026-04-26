# Post-Incident Review: Week 5 Monday Staging Environment Incident

## Section 1: Incident Summary (For Nia - No Acronyms)

On Monday morning during a live investor demonstration, the deployment system targeted the wrong environment. The staging environment was unavailable for 48 seconds while engineers corrected the error. No customer data was affected because the incident occurred in a testing environment, not production.

---

## Section 2: Timeline

| Time | Event |
|------|-------|
| 09:00:00 | Nia begins investor walkthrough of the deployment pipeline |
| 09:02:15 | Engineer triggers pipeline for green environment deployment |
| 09:02:30 | Pipeline targets staging instead of development environment (error identified) |
| 09:02:45 | Engineer notices the error on dashboard |
| 09:03:00 | Manual rollback initiated |
| 09:03:03 | Rollback completes; staging restored to correct state |
| 09:03:15 | Investor demonstration resumes |

**Incident Duration:** 48 seconds
**Status:** Resolved

---

## Section 3: Root Cause

The pipeline configuration referenced a fixed environment name (`staging`) instead of reading the environment name from the deployment trigger. When the engineer triggered the pipeline for a different environment, the configuration did not respect the intended target.

---

## Section 4: Contributing Factors

| Factor | Description |
|--------|-------------|
| Hardcoded environment | Pipeline configuration had a hardcoded value instead of a variable |
| No preview step | The pipeline did not show which environment would be affected before execution |
| Manual trigger | The pipeline required manual triggering with no validation of the target environment |

---

## Section 5: What Went Well

The monitoring dashboard immediately showed the error in the user interface. The engineer detected the problem within 15 seconds because the visual indicators made the incorrect environment state clearly visible.

---

## Section 6: Action Items

| # | Owner | Action Item | Target Completion |
|---|-------|-------------|--------------------|
| 1 | Platform Team | Replace hardcoded environment names with variables read from deployment trigger | End of week |
| 2 | Platform Team | Add a confirmation step showing the target environment before any deployment proceeds | End of week |
| 3 | QA Team | Add automated test: pipeline cannot run with unauthenticated environment variable | Next sprint |

---

**Report Completed By:** Platform Team
**Date:** $(date +%Y-%m-%d)
