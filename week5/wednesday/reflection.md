# Week 5 Wednesday: Reflection and Engineering Thinking

## Question 1: Artifact Versioning Under Real Team Conditions

### The Scenario

Two developers working on separate features merge to main at nearly the same time:

- **Developer A** merges feature branch → Commit SHA: `a3f2c8b`
- **Developer B** merges feature branch → Commit SHA: `b7d9e2a`

### Version Strings Produced

| Developer | package.json version | Git SHA | Full Version String |
|-----------|---------------------|---------|---------------------|
| Developer A | 1.0.0 | a3f2c8b | `1.0.0-a3f2c8b` |
| Developer B | 1.0.0 | b7d9e2a | `1.0.0-b7d9e2a` |

### Do They Conflict?

**NO.** They do NOT conflict because:

1. Each version string is **unique** due to different Git SHAs
2. The SHA makes each artifact **immutable and distinct**
3. Both artifacts can coexist in Nexus

### What If Nexus Has "Disable Redeploy" (Production Setting)?

| Developer | Attempt | Result |
|-----------|---------|--------|
| Developer A | Publish `1.0.0-a3f2c8b` | ✅ Success - version does not exist yet |
| Developer B | Publish `1.0.0-b7d9e2a` | ✅ Success - DIFFERENT version string |

**They do NOT conflict** because the version strings are different. `1.0.0-a3f2c8b` ≠ `1.0.0-b7d9e2a`.

### The Real Conflict Scenario

Conflict would only happen if:
- Both developers tried to publish **exactly the same version string**
- Example: Both try to publish `1.0.0` (no SHA)

**With SHA included:** Each commit produces a unique version → No conflicts ever.

---

## Question 2: The withCredentials Masking Limit

### The Masking Mechanism

Jenkins `withCredentials` masks:
- The **exact literal** credential value in logs
- Example: `sk-or-v1-abc123` appears as `********`

### The Vulnerability: Transformed Credentials

**Scenario where credential appears unmasked:**

```groovy
withCredentials([string(credentialsId: 'api-key', variable: 'API_KEY')]) {
    sh """
        # This is masked: echo $API_KEY
        # This is NOT masked:
        echo $API_KEY | base64
        echo ${API_KEY:0:8}
        echo \$(echo $API_KEY | md5sum)
    """
}
