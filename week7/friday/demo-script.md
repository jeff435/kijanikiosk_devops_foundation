# Nia's Board Presentation Demo Script

## Introduction
*Nia stands at the front of the room. The screen shows the deployment dashboard.*

"I'm going to show you how our system deploys new features safely. Watch the screen as we start."

---

## Deploy to New Environment
*Amina clicks the deploy button. The dashboard shows "Building".*

"Our team has prepared a new version of our payment service. We're sending it to a safe testing area that runs alongside our live service. Nothing changes for customers yet."

---

## Switch Traffic
*Amina clicks the switch button. The dashboard shows "Switching".*

"Now we're moving customer traffic to the new version. The screen will show when the switch is complete."

---

## Introduce Fault
*Amina runs the command to stop the new service. The dashboard shows health checks failing.*

"The new version has encountered a problem. Our system detects this immediately. Watch what happens next."

---

## Automated Rollback
*The dashboard shows "Rollback initiated" and then "Rollback complete".*

"The system automatically puts the old working version back in place. No human had to push a button. This entire recovery took XX seconds. The screen shows the original version is now serving traffic again."

---

## Summary
*Nia turns to face the board.*

"Our deployment system fixes itself. When something goes wrong with a new version, we're back to the working version in under 90 seconds. Your customers never know there was a problem. This is what reliable software looks like."

---

**Note:** Replace XX with actual rollback time from rollback-evidence.txt
