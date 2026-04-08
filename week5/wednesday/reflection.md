# Week 5 Wednesday: Reflection and Engineering Thinking

## Question 1: Artifact Versioning Under Real Team Conditions

Two developers merge at the same time:
- Developer A: SHA `a3f2c8b` → version `1.0.0-a3f2c8b`
- Developer B: SHA `b7d9e2a` → version `1.0.0-b7d9e2a`

**Do they conflict?** No. Different SHAs make unique versions.

With Nexus "Disable Redeploy" enabled, both publishes succeed because the version strings are different.

## Question 2: The withCredentials Masking Limit

Jenkins cannot mask transformed credentials like:
- Base64 encoded values
- Substrings of the credential
- Hashed values

**Why:** Jenkins only knows the literal credential value. It cannot predict every possible transformation.

**Fix:** Never echo or transform credentials in build steps. Use credentials directly in commands.

## Question 3: The Immutability Requirement

Immutability means once a version is published to Nexus, it cannot be overwritten.

**Without immutability:** A developer could publish version 1.0.0 at 9am, then overwrite it with different code at 10am. When another team pulls 1.0.0 at 11am, they get different bits than what was tested. Production gets untested code and crashes.

**Why dangerous for multiple teams:** Team A tests one binary, Team B deploys a different binary. Version numbers become meaningless.

**With immutability:** Bug fix requires publishing version 1.0.1. Every version maps to exactly one binary.

## Question 4: Credential Rotation

**What changes:**
- Nexus password (rotated every 90 days)

**What stays the same:**
- Jenkins credential ID (`nexus-credentials`)
- Jenkinsfile (no changes needed)

**Rotation procedure:**
1. Change password in Nexus UI
2. Update stored credential in Jenkins (same ID, new password)
3. Jenkinsfile requires NO changes

**Why valuable:**
- No code change or pull request required
- Emergency rotation without code review
- Security team can rotate without developers
- Jenkins picks up new password immediately

## Looking Ahead: Thursday's Two Problems

| Question | Answer |
|----------|--------|
| What does `agent { docker { image 'node:20-alpine' } }` do? | Pulls Docker image, starts container, runs steps inside |
| Can Docker agent access Nexus on same VM? | Need same Docker network or host.docker.internal |
| Can different stages run on different agents? | Yes - use agent none then per-stage agents |

**End of Wednesday Reflection**
