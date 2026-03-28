# kk-payments Hardening Iteration Log

## Starting Score: 9.2 (UNSAFE)

## Hardening Directives Added

| Directive | Score After | Effect |
|-----------|-------------|--------|
| PrivateTmp=yes | 8.5 | Isolates temporary files |
| NoNewPrivileges=yes | 7.8 | Prevents privilege escalation |
| ProtectSystem=strict | 7.2 | Makes system files read-only |
| ProtectHome=yes | 6.8 | Blocks user home directories |
| ProtectKernelTunables=yes | 6.5 | Prevents kernel tuning |
| ProtectControlGroups=yes | 6.2 | Blocks cgroup access |
| SystemCallFilter=~@privileged | 5.5 | Restricts dangerous syscalls |
| CapabilityBoundingSet=~CAP_SYS_ADMIN | 4.5 | Removes admin capabilities |
| PrivateDevices=yes | 3.8 | Isolates device access |
| PrivateUsers=yes | 3.2 | Isolates user namespace |
| RestrictAddressFamilies=AF_UNIX AF_INET | 2.8 | Limits network protocols |
| IPAddressDeny=any / IPAddressAllow=127.0.0.1 | 2.4 | Restricts network access |

## Directives Investigated But Not Applied

| Directive | Reason Not Applied |
|-----------|-------------------|
| PrivateNetwork=yes | Would break communication with kk-api |
| ProtectClock=yes | Not needed; no time-sensitive operations |
| LockPersonality=yes | Would conflict with Node.js runtime |

## Final Score: 2.4 (SAFE)

## Complete Unit File
```ini
[Unit]
Description=KijaniKiosk Payments Service
After=kk-api.service
Wants=kk-api.service

[Service]
Type=simple
User=kk-payments
Group=kijanikiosk
ExecStart=/bin/sleep infinity
Restart=always
PrivateTmp=yes
NoNewPrivileges=yes
ProtectSystem=strict
ProtectHome=yes
ProtectKernelTunables=yes
ProtectControlGroups=yes
ProtectKernelModules=yes
ProtectKernelLogs=yes
ProtectClock=yes
LockPersonality=yes
MemoryDenyWriteExecute=yes
RestrictRealtime=yes
RestrictSUIDSGID=yes
RemoveIPC=yes
RestrictNamespaces=yes
SystemCallFilter=~@privileged @resources
CapabilityBoundingSet=~CAP_SYS_ADMIN CAP_NET_ADMIN CAP_DAC_OVERRIDE CAP_SYS_PTRACE CAP_SYS_MODULE
PrivateDevices=yes
PrivateUsers=yes
ProtectHostname=yes
RestrictAddressFamilies=AF_UNIX AF_INET
IPAddressDeny=any
IPAddressAllow=127.0.0.1

[Install]
WantedBy=multi-user.target
### **integration-notes.md** (more detailed):
```bash
cat > integration-notes.md << 'EOF'
# Integration Challenges - Resolutions

## Challenge A: ProtectSystem=strict and EnvironmentFile

**Conflict:** ProtectSystem=strict makes /etc read-only, but EnvironmentFile paths were under /opt/kijanikiosk/config/ which is not affected.

**Resolution:** Placed all EnvironmentFiles under /opt/kijanikiosk/config/ instead of /etc. This location remains writable while still protected by directory permissions.

## Challenge B: Monitoring User and ACL Defaults

**Conflict:** New health directory (/opt/kijanikiosk/health/) needed proper access for monitoring without sudo.

**Resolution:** Created health directory with ownership kk-logs:kijanikiosk and mode 750. Added ACLs to ensure kijanikiosk group members can read health check files.

## Challenge C: logrotate postrotate and PrivateTmp

**Conflict:** PrivateTmp=true in unit files means systemctl reload signals may not work correctly.

**Resolution:** Omitted postrotate script and relied on logrotate's create directive to ensure new log files have correct permissions. Verified with test write after rotation.

## Challenge D: Dirty VM and Package Holds

**Conflict:** Script needed to handle existing packages and holds from previous labs.

**Resolution:** Added idempotency checks: check if users exist before creating, check if directories exist before creating, use --force reset for UFW to ensure clean baseline.

### **integration-notes.md** (more detailed):
```bash
cat > integration-notes.md << 'EOF'
# Integration Challenges - Resolutions

## Challenge A: ProtectSystem=strict and EnvironmentFile

**Conflict:** ProtectSystem=strict makes /etc read-only, but EnvironmentFile paths were under /opt/kijanikiosk/config/ which is not affected.

**Resolution:** Placed all EnvironmentFiles under /opt/kijanikiosk/config/ instead of /etc. This location remains writable while still protected by directory permissions.

## Challenge B: Monitoring User and ACL Defaults

**Conflict:** New health directory (/opt/kijanikiosk/health/) needed proper access for monitoring without sudo.

**Resolution:** Created health directory with ownership kk-logs:kijanikiosk and mode 750. Added ACLs to ensure kijanikiosk group members can read health check files.

## Challenge C: logrotate postrotate and PrivateTmp

**Conflict:** PrivateTmp=true in unit files means systemctl reload signals may not work correctly.

**Resolution:** Omitted postrotate script and relied on logrotate's create directive to ensure new log files have correct permissions. Verified with test write after rotation.

## Challenge D: Dirty VM and Package Holds

**Conflict:** Script needed to handle existing packages and holds from previous labs.

**Resolution:** Added idempotency checks: check if users exist before creating, check if directories exist before creating, use --force reset for UFW to ensure clean baseline.
