# kk-payments Service Level Indicators (SLIs) and Service Level Objectives (SLOs)

## Overview
This document defines the measurement and commitment standards for the kk-payments service.

---

## Three Key Service Level Indicators (SLIs)

### SLI 1: Availability
- **What it measures:** The percentage of successful payment requests
- **How it is measured:** 
  - Data source: nginx access logs at `/var/log/nginx/access.log`
  - Calculation method: `(total requests - failed requests) / total requests * 100`
  - Measurement window: Rolling 30 days
- **Target SLO:** 99.9% availability

### SLI 2: Latency
- **What it measures:** Time to complete a payment request
- **How it is measured:**
  - Data source: application response time from access logs
  - Calculation method: 95th percentile of request duration
  - Measurement window: Rolling 30 days
- **Target SLO:** 95% of requests complete within 500ms

### SLI 3: Payment Error Rate
- **What it measures:** Percentage of payment attempts that fail
- **How it is measured:**
  - Data source: application error logs at `/opt/kijanikiosk/shared/logs/payments-error.log`
  - Calculation method: `(failed payments / total payment attempts) * 100`
  - Measurement window: Rolling 30 days
- **Target SLO:** 99.5% of payment attempts succeed

---

## Rollback Thresholds

| SLI | Short-Window Threshold | Relationship to SLO |
|-----|----------------------|---------------------|
| Availability | 95% over 2 minutes | If availability drops below 95% in a 2-minute window, the deployment is failing significantly below the 99.9% SLO target. Immediate rollback prevents further customer impact. |
| Latency | 95th percentile > 2 seconds over 1 minute | If latency spikes to over 2 seconds at the 95th percentile, the service is degrading. This is 4x the 500ms SLO target. |
| Error Rate | 5% failure rate over 90 seconds | If 5% of payment attempts fail in a 90-second window, the service is actively harming customers. The 99.5% SLO equals only 0.5% failures. A 5% threshold is 10x the acceptable rate. |

---

## What We Do Not Commit To

1. **User-initiated cancellations:** A customer canceling a payment after initiation is logged as a "failed" transaction in the system, but this is not a service failure. Users have the right to cancel, and cancellation rates vary by user behavior, not service health.

2. **Third-party payment gateway downtime:** Our service depends on external payment providers. When their service is unavailable, our error rate increases through no fault of our own. The SLO measures our service's internal health, not the reliability of our partners.

---

## Summary Table

| SLI | Target SLO | Measurement Method | Rollback Threshold |
|-----|------------|--------------------|--------------------|
| Availability | 99.9% | nginx access logs, 30-day rolling | 95% over 2 minutes |
| Latency (95th percentile) | ≤ 500ms | access logs, 30-day rolling | > 2 seconds over 1 minute |
| Payment Error Rate | 99.5% success | error logs, 30-day rolling | > 5% failure over 90 seconds |

---

**Document Owner:** Platform Team
**Review Cycle:** Quarterly
**Last Updated:** $(date +%Y-%m-%d)
