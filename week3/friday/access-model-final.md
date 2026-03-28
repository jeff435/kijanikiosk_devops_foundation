# KijaniKiosk Access Model

## Directory Structure and Permissions

| Directory | Owner | Group | Mode | ACLs |
|-----------|-------|-------|------|------|
| /opt/kijanikiosk | root | kijanikiosk | 750 | None |
| /opt/kijanikiosk/config | root | kijanikiosk | 750 | kk-api:rx, kk-payments:rx |
| /opt/kijanikiosk/shared/logs | root | kijanikiosk | 750 | kk-api:rwx, kk-payments:rx |
| /opt/kijanikiosk/health | kk-logs | kijanikiosk | 750 | kijanikiosk:rx (group read) |

## Service Accounts

| Account | UID | Primary Group | Purpose |
|---------|-----|---------------|---------|
| kk-api | 1001 | kijanikiosk | API service |
| kk-payments | 1002 | kijanikiosk | Payments service |
| kk-logs | 1003 | kijanikiosk | Log aggregation |

## Access Matrix

| Resource | kk-api | kk-payments | kk-logs | kijanikiosk Group |
|----------|--------|-------------|---------|------------------|
| /opt/kijanikiosk | - | - | - | r-x |
| /opt/kijanikiosk/config | r-x | r-x | - | r-x |
| /opt/kijanikiosk/shared/logs | rwx | r-x | rwx | rwx |
| /opt/kijanikiosk/health | - | - | rwx | r-x |

## Default ACLs (inherited for new files in /shared/logs)
- user:kk-api:rwx
- user:kk-payments:rx
- group:kijanikiosk:rwx
- mask::rwx
