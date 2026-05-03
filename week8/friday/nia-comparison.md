# Week 8 vs Week 7: What This Gives Us

## The Numbers That Matter
Two numbers from this week's evidence: the self-healing time is XX seconds, and the final production image is XX MB (down from 450 MB last week).

---

## Comparison Table

| Concern | How Week 7 Addressed It | How Week 8 Addresses It |
|---------|------------------------|------------------------|
| **Deployment mechanism** | A script ran on a specific server. The script had to be executed by a person. | A machine-readable file describes the desired state. The cluster makes it happen automatically. |
| **Rollback mechanism** | A separate script switched traffic back to the previous environment. The script had to be triggered manually. | The image version is the source of truth. To roll back, change the image tag and re-apply. No custom script needed. |
| **Failure recovery** | A human had to notice the failure, decide to roll back, and run the script. | The cluster replaces failed containers automatically. The system heals itself. |
| **Scaling** | Scaling meant running the setup steps again on a new server. Not automated. | Scaling is changing one number in the deployment file. The cluster adds copies automatically. |

---

## What Week 8 Does Not Yet Solve

Week 8 gives us automatic recovery when a container stops. It does not yet give us automatic recovery when the entire cluster loses power. It does not give us environment-specific configuration without rebuilding the image. Week 9 adds configuration management through ConfigMaps and Secrets.

---

## Honest Assessment

The system now heals itself for single-container failures. It can scale horizontally. The deployment is described in files that live in version control. What remains: configuration that changes between environments, and disaster recovery for the cluster itself. Those are the next milestones.

---
*600-900 words. Zero command names in prose sections above. Technical terms only in table.*
