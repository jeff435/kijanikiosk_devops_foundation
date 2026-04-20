# KijaniKiosk CI Pipeline: Board Presentation Document

## What This Pipeline Does (In Plain English)

Every time a developer saves their work to the shared codebase, an automated process starts. This process checks whether the change meets our quality standards before it is recorded as an approved version that can be deployed to production.

Think of it like an assembly line with five inspection points. At each point, the line either gives a green light to continue or stops and tells the developer exactly what needs fixing.

## The Five Inspection Points

| Stage | What It Checks | How Long It Takes |
|-------|----------------|-------------------|
| **Lint** | Code style and basic syntax (missing brackets, typos) | ~30 seconds |
| **Build** | Can the code be packaged into a working application? | ~2-3 minutes |
| **Verify** | Do all tests pass? Are there known security vulnerabilities? | ~2-4 minutes (parallel) |
| **Archive** | Save the approved version with a unique fingerprint | ~10 seconds |
| **Publish** | Store the version in our private registry for deployment | ~30 seconds |

**Total time:** Under 10 minutes from push to published artifact.

## What Makes This Reliable for Financial Services

**Reproducible environments.** The pipeline runs inside a container with a pinned version of Node.js (18). What passes on Monday passes on Friday, even if someone updates the server.

**Immutable versions.** Every published artifact has a version number that combines our semantic version (1.0.0) with the unique identifier of the code commit. Two different commits never produce the same version number.

**No secrets in code.** The pipeline never stores passwords or API keys in the Jenkinsfile, the commit history, or the build logs.

## What Happens When Something Goes Wrong

**If a developer pushes code with a syntax error:** The pipeline stops at the first inspection point within 30 seconds. The developer sees exactly which file and which line contains the error.

**If a test fails:** The pipeline stops after the Verify stage. The developer receives the test report showing which expectation was not met. No version is published to our registry.

**If a security vulnerability is found:** The pipeline stops and alerts the team. A vulnerable package never reaches our registry.

**If the connection to our artifact registry fails:** The pipeline still saves the artifact in Jenkins. Nothing is lost. The team fixes the connection and re-runs only the publish step.

## What This Pipeline Does Not Yet Do

1. **No deployment automation.** The pipeline publishes to our registry but does not deploy to production. That comes next week.

2. **No performance testing.** We check correctness and security, not speed.

3. **No automatic rollback.** If a bad version slips through, we must manually revert.

4. **No notification to Slack/MS Teams.** Currently, developers must check Jenkins directly.

These gaps are known, documented, and scheduled. The pipeline as built today is production-ready for continuous integration.
