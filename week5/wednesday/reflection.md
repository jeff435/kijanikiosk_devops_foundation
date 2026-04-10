# Week 5 Wednesday: Reflection and Engineering Thinking

## Question 1: Artifact Versioning Under Real Team Conditions

Two developers merge at same time:
- Developer A: SHA `a3f2c8b` → version `1.0.0-a3f2c8b`
- Developer B: SHA `b7d9e2a` → version `1.0.0-b7d9e2a`

**Do they conflict?** No. Different SHAs make unique versions.

## Question 2: The withCredentials Masking Limit

Jenkins cannot mask transformed credentials like:
- Base64 encoded values
- Substrings of the credential
- Hashed values

**Fix:** Never echo or transform credentials in build steps.

## Question 3: The Immutability Requirement

Immutability means once a version is published to Nexus, it cannot be overwritten.

**Without immutability:** A developer could publish version 1.0.0 at 9am, then overwrite it with different code at 10am. When another team pulls 1.0.0 at 11am, they get different bits than what was tested.

**With immutability:** Bug fix requires publishing version 1.0.1. Every version maps to exactly one binary.

## Question 4: Credential Rotation

| What changes | What stays the same |
|--------------|---------------------|
| Nexus password | Jenkins credential ID |
| | Jenkinsfile (no changes needed) |

**Rotation procedure:**
1. Change password in Nexus UI
2. Update stored credential in Jenkins (same ID, new password)
3. Jenkinsfile requires NO changes
