# Week 5 Tuesday: Declarative Pipeline Reflection

## Question 1: What the Red Build Proved

| Observation | What It Proved |
|-------------|----------------|
| Build stage green, Test stage red | Pipeline executes stages in order. Build does NOT depend on tests passing. |
| Archive stage did not run | Pipeline stops at first failure. No broken artifacts are archived. |
| Post failure block ran | Pipeline has proper error handling for notifications. |

## Question 2: npm ci vs npm install in a Team Context

| Command | Behavior | Problem |
|---------|----------|---------|
| `npm install` | Reads `package.json`, may update `package-lock.json` | Different developers get different dependency versions |
| `npm ci` | Reads ONLY `package-lock.json`, installs exact versions | Every run produces IDENTICAL dependencies |

## Question 3: The Archived Artifact

**Two problems with Jenkins controller storage:**
1. Disk filling - Controller runs out of space
2. Network accessibility - Deployment pipelines cannot easily pull artifacts

**What Nexus provides:**
- Versioning with semantic version support
- Retention policies (keep last 5 versions)
- Fine-grained role-based access control
- REST API accessible from anywhere

## Question 4: What Tuesday's Pipeline Still Cannot Do

The pipeline does NOT catch security vulnerabilities in dependencies.

**Two missing categories of checks:**

1. **Dependency Vulnerability Scanning** - Tool: `npm audit` or Snyk
2. **Static Application Security Testing (SAST)** - Tool: SonarQube or ESLint Security Plugin
