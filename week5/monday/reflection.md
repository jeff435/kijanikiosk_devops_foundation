# Week 5 Monday: CI Pipeline Reflection

## Question 1: What Today's Pipeline Does Not Do

Today's pipeline only checks if Node.js runtime is available. The three missing CI properties are:

1. **Automated Build** - Add `stage('Build') { sh 'npm run build' }` to Jenkinsfile
2. **Automated Testing** - Add `stage('Test') { sh 'npm test' }` to Jenkinsfile  
3. **Artifact Production** - Add `stage('Package') { archiveArtifacts artifacts: 'dist/**/*' }` to Jenkinsfile

Today's pipeline does NOT verify:
- The application compiles without errors
- Unit tests pass
- Dependencies are correct
- The artifact is deployable

## Question 2: The Broken-Build Contract in Practice

A realistic exception scenario: A developer argues their broken payment service should be exempt because it's not used by other services yet.

Why this is costly:
- Other developers cannot run reliable tests on main
- The team loses trust in the red build signal
- Over 2 weeks, 10 exceptions cost 57.5 hours of lost productivity

The correct policy: No exceptions on main. Fix or revert within 30 minutes.

## Question 3: The Jenkinsfile in the Repository

Two problems with UI-only pipeline configuration:

1. **Disaster Recovery** - If Jenkins server fails, all pipeline configuration is lost. Recovery takes hours instead of 15 minutes.

2. **No Code Review** - Changes bypass pull request approval. No audit trail of who changed what.

The rule: Pipeline is code. Code lives in version control.

## Question 4: Webhooks vs Polling

**Webhook mechanism:** GitHub sends HTTP POST to Jenkins on every push. Jenkins triggers pipeline immediately.

**When polling is better:** When Jenkins is behind a firewall that blocks inbound webhooks.

**Polling interval trade-off:** For 20 developers pushing multiple times daily, polling every 2 minutes creates 600 API calls per hour. Webhooks are better for teams larger than 5 developers.

## Looking Ahead

- `npm run build` produces a `dist/` folder with bundled JavaScript
- Jenkins uses `archiveArtifacts artifacts: 'dist/**/*'` to find build output
- Jenkins sees test failures only after all tests complete unless `--bail` flag is used
Eof
EEOF
