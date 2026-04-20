# Week 5 Project Reflection

## Question 1: Tension between requirements

The tension I discovered was between **disableConcurrentBuilds()** and the **parallel Verify stage**. 

I prioritised keeping both because they solve different problems: 
- `disableConcurrentBuilds()` prevents resource exhaustion from multiple developers pushing simultaneously
- Parallel Verify reduces feedback time within a single build

After testing, I confirmed they work together correctly.

## Question 2: Translating for Nia vs Osei

**Board document sentence (for Nia):** 
> "Every time a developer saves their work to the shared codebase, an automated process checks whether the change meets our quality standards before it is recorded as an approved version."

**Technical version (for Osei):**
> "A Jenkins Declarative Pipeline triggered by a GitHub webhook executes five stages (Lint, Build, parallel Verify, Archive, Publish) and conditionally publishes a semantically versioned artifact to Nexus only if all stages pass."

**What is the same:** The trigger (developer push), quality check before approval, versioned output

**What is different:** Board version omits tool names (Jenkins, Nexus, webhook), uses active voice, focuses on business outcomes rather than mechanisms

## Question 3: Scaling from 4 to 40 developers

**Which part breaks first:** The Nexus registry throughput and Jenkins build queue management.

With 40 developers, `disableConcurrentBuilds()` would create a severe bottleneck. Builds would queue for hours.

**What needs to change:**

1. **Remove or relax `disableConcurrentBuilds()`** - Replace with resource-based concurrency limits (max 5 concurrent builds)

2. **Add build agents** - Need an agent pool (4-8 agents) with auto-scaling

3. **Branch-based pipeline optimisation** - Run Lint and Security Audit on every push, but only full Build + Test on PR branches

4. **Nexus clustering** - Add Nexus BlobStore clustering or CDN cache

5. **Notification system** - Add Slack/Teams notifications for build results

The core pipeline logic scales well. The infrastructure around it would fail first.
