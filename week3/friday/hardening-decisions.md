# KijaniKiosk Security Hardening Decisions

## Executive Summary
This document outlines the security controls implemented for the KijaniKiosk production server. Each control is explained in plain language with the specific risk it mitigates.

## Security Controls

| Control | What it does | Risk Mitigated |
|---------|--------------|----------------|
| Service Accounts | Dedicated non-login accounts for each service | Prevents privilege escalation; limits blast radius if one service is compromised |
| kijanikiosk Group | Shared group for all service accounts | Enables controlled collaboration while maintaining individual accountability |
| PrivateTmp | Isolates temporary files per service | Prevents one service from accessing another service's temporary data |
| NoNewPrivileges | Prevents processes from gaining new privileges | Stops privilege escalation attacks even if vulnerabilities exist |
| ProtectSystem | Makes system files read-only | Blocks unauthorized modification of system binaries and configurations |
| ProtectHome | Blocks access to user home directories | Prevents services from accessing sensitive user data |
| SystemCallFilter | Restricts which system calls services can use | Limits attack surface; blocks dangerous kernel interactions |
| CapabilityBoundingSet | Removes Linux capabilities | Prevents services from performing privileged operations |
| PrivateDevices | Isolates device access | Blocks direct hardware access |
| RestrictAddressFamilies | Limits network protocols | Prevents services from using unnecessary network stacks |
| MemoryDenyWriteExecute | Prevents memory pages from being writable and executable | Mitigates code injection attacks |

## What This Security Posture Does NOT Protect Against
- Zero-day vulnerabilities in the application code
- Insider threats with legitimate access credentials
- Physical access to the server hardware
- DDoS attacks (requires additional network-level controls)
- Data exfiltration through authorized channels
- Vulnerabilities in the underlying Linux kernel
