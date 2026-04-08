# Week 5 Tuesday: Declarative Pipeline Reflection

## Question 1: What the Red Build Proved

### What Each Observation Proved

| Observation | What It Proved |
|-------------|----------------|
| Build stage green, Test stage red | The pipeline executes stages in order. Build does NOT depend on tests passing. |
| Archive stage did not run | The pipeline stops at first failure. No broken artifacts are archived. |
| Post failure block ran | The pipeline has proper error handling for notifications and cleanup. |

### Syntax Error vs Test Failure

If a syntax error crashes the test runner instead of producing a failing test:

| Aspect | Test Failure | Test Runner Crash |
|--------|--------------|-------------------|
| Exit code | Non-zero (1) | Non-zero (1, 126, or 127) |
| Stage view | Red (failed) | Red (failed) |
| Difference to Jenkins | None - Jenkins only sees exit code | None - Jenkins only sees exit code |

Jenkins does NOT distinguish between test failure and test runner crash. Both produce a non-zero exit code and fail the stage.

## Question 2: npm ci vs npm install in a Team Context

### The Scenario

Four developers work on the payments service. Monday night, one developer runs `npm install` locally, updating `package-lock.json`. Another developer forgets to pull the latest lockfile.

### The Problem with npm install

| Command | Behavior | Problem |
|---------|----------|---------|
| `npm install` | Reads `package.json`, resolves dependencies, may update `package-lock.json` | Different developers get different dependency versions |
| `npm ci` | Reads ONLY `package-lock.json`, installs exact versions | Every run produces IDENTICAL dependencies |

### Why npm ci Prevents This

`npm ci` ensures every pipeline run uses EXACTLY the same dependency versions. No drift. No "works on my machine."

## Question 3: The Archived Artifact

### Two Problems with Jenkins Controller Storage

| Problem | Impact |
|---------|--------|
| **Disk filling** | Controller runs out of disk space. Builds fail. Jenkins crashes. |
| **Network accessibility** | Deployment pipelines cannot easily pull artifacts from Jenkins controller |

### What a Dedicated Artifact Repository Provides

| Property | Jenkins Controller | Nexus/Artifactory |
|----------|-------------------|-------------------|
| Versioning | Manual naming only | Built-in semantic version support |
| Retention | Manual deletion only | Automated policies (keep last 5 versions) |
| Access control | Jenkins permissions only | Fine-grained role-based access |
| Network access | Jenkins network only | REST API from anywhere |

## Question 4: What Tuesday's Pipeline Still Cannot Do

### Nia's Question Answer

**No.** The pipeline does NOT catch security vulnerabilities in dependencies.

### Two Missing Categories of Checks

**Category 1: Dependency Vulnerability Scanning**
- Tool: `npm audit` or Snyk
- Stage: After `npm ci`, before `Build`
- Command: `npm audit --audit-level=moderate`

**Category 2: Static Application Security Testing (SAST)**
- Tool: SonarQube or ESLint Security Plugin
- Stage: After `Build`, before `Test`
- Scans for: hardcoded secrets, SQL injection, unsafe functions

### Pipeline Stage Order with Security

```groovy
stages {
    stage('Checkout') { }
    stage('Install Dependencies') { }
    stage('Security Scan') { }      // npm audit - fail fast
    stage('Build') { }
    stage('SAST Scan') { }          // SonarQube - deeper analysis
    stage('Test') { }
    stage('Archive') { }
}
