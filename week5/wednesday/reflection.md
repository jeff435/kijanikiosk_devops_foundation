# Week 5 Wednesday: Reflection and Engineering Thinking

## Question 1: Artifact Versioning Under Real Team Conditions

### The Scenario

Two developers working on separate features merge to main at nearly the same time:
- Developer A merges feature branch → Commit SHA: `a3f2c8b`
- Developer B merges feature branch → Commit SHA: `b7d9e2a`

### Version Strings Produced

| Developer | package.json version | Git SHA | Full Version String |
|-----------|---------------------|---------|---------------------|
| Developer A | 1.0.0 | a3f2c8b | `1.0.0-a3f2c8b` |
| Developer B | 1.0.0 | b7d9e2a | `1.0.0-b7d9e2a` |

### Do They Conflict?

**NO.** They do NOT conflict because:
1. Each version string is unique due to different Git SHAs
2. The SHA makes each artifact immutable and distinct
3. Both artifacts can coexist in Nexus

### What If Nexus Has "Disable Redeploy" (Production Setting)?

| Developer | Attempt | Result |
|-----------|---------|--------|
| Developer A | Publish `1.0.0-a3f2c8b` | ✅ Success - version does not exist yet |
| Developer B | Publish `1.0.0-b7d9e2a` | ✅ Success - DIFFERENT version string |

**They do NOT conflict** because the version strings are different. `1.0.0-a3f2c8b` ≠ `1.0.0-b7d9e2a`.

### The Real Conflict Scenario

Conflict would only happen if both developers tried to publish exactly the same version string (e.g., both try to publish `1.0.0` with no SHA). With SHA included, each commit produces a unique version → No conflicts ever.

## Question 2: The withCredentials Masking Limit

### The Masking Mechanism

Jenkins `withCredentials` masks the exact literal credential value in logs. Example: `sk-or-v1-abc123` appears as `********`.

### The Vulnerability: Transformed Credentials

**Scenario where credential appears unmasked:**

```groovy
withCredentials([string(credentialsId: 'api-key', variable: 'API_KEY')]) {
    sh """
        # This is masked: echo $API_KEY
        # This is NOT masked:
        echo $API_KEY | base64
        echo ${API_KEY:0:8}
        echo $(echo $API_KEY | md5sum)
    """
}

## Question 3: The Immutability Requirement

Immutability means once a version is published to Nexus, it cannot be overwritten.

### The Problem Without Immutability

Without immutability, a developer could publish version 1.0.0 at 9am, then overwrite it with different code at 10am. When another team's deployment pipeline pulls version 1.0.0 at 11am, they get different bits than what was tested at 9am. This causes production failures because the deployed code is not the same code that passed testing.

### Why It's Dangerous for Multiple Teams

When multiple teams deploy from the same registry, overwritten versions cause chaos. Team A tests one binary, Team B deploys a different binary, and no one knows which version is actually in production. Version numbers become meaningless.

### What Immutability Enforces

With immutability, once 1.0.0 is published, it is frozen. If a bug is found, you publish 1.0.1. Every version number maps to exactly one binary. Deployment is predictable and auditable.

## Question 4: Credential Rotation

### What Changes and What Stays the Same

| Component | Does it change? |
|-----------|----------------|
| Nexus password | YES - rotated every 90 days |
| Jenkins credential ID | NO - stays the same |
| Jenkinsfile | NO - no changes needed |

### The Rotation Procedure

**Step 1:** Change password in Nexus UI
**Step 2:** Update stored credential in Jenkins (same ID, new password)
**Step 3:** Jenkinsfile requires NO changes

### Why This Separation Is Valuable

- No code change or pull request required to rotate credentials
- Emergency rotation can happen instantly without code review
- Security team can rotate credentials without involving developers
- Jenkins picks up the new password immediately, no pipeline restart needed

The Jenkinsfile references only the credential ID (nexus-credentials), not the actual password. This means the password can be rotated without touching the code.
