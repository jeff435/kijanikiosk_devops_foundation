# KijaniKiosk Infrastructure Security and Hardening Report

## Introduction for the Board
This document outlines the security architecture and hardening measures implemented for the KijaniKiosk infrastructure. Our goal is to ensure that the platform is resilient against common attacks, protects sensitive customer payment data, and maintains a high degree of availability. By using Infrastructure as Code, we have made these security decisions transparent, reproducible, and auditable.

## Security Control Summary

| Control | What it does | Risk Mitigated |
|---------|--------------|----------------|
| Ingress Filtering | Restricts incoming network traffic to only essential communication paths (secure remote access and web traffic). | Unauthorized access to internal services and reduction of the attack surface. |
| Key Pair Management | Uses cryptographic keys for remote access instead of passwords. | Brute-force password attacks and unauthorized remote login. |
| Service Account Isolation | Each application component runs under its own unique identity with minimal necessary permissions. | Lateral movement between components; if one service is compromised, others remain protected. |
| Directory Access Controls | Strictly limits which users and groups can read or write to specific folders on the server. | Information disclosure and unauthorized modification of application data or configuration. |
| Temporary File Isolation | Provides each service with its own private and isolated area for temporary files. | Information leakage between services through shared temporary storage. |
| Privilege Escalation Prevention | Explicitly prevents any service from gaining more power than it was originally granted. | Exploitation of software bugs to gain administrative control over the entire server. |
| System File Protection | Mounts most of the server's core software files as read-only for the application services. | Tampering with system binaries or configuration files by a compromised application. |
| Restricted Network Families | Limits the types of network communication a service can perform (e.g., only local or internet-based). | Data exfiltration through unusual network protocols or unauthorized internal communication. |

## Architectural Overview and Security Strategy
Our approach to securing KijaniKiosk is based on the principle of "Defense in Depth." We do not rely on a single security measure but rather layer multiple controls to ensure that a failure in one area does not lead to a total system compromise.

At the network level, we have implemented strict firewall rules that only allow traffic on the ports absolutely necessary for operation. This significantly reduces the visibility of our servers to potential attackers on the internet. We have also moved away from traditional password-based logins for our engineers, requiring the use of unique cryptographic keys which are much harder to compromise.

Moving deeper into the servers themselves, we have implemented a robust service isolation strategy. Each part of the application—the main interface, the payment processor, and the logging system—operates in its own "sandbox." This is achieved through the use of dedicated service accounts and strict filesystem permissions. By ensuring that the payment processor cannot even see the logs created by the main interface, we prevent a vulnerability in the interface from being used to access sensitive payment data.

The most significant hardening efforts have been focused on the `kk-payments` service, given its critical role in handling financial transactions. We have utilized advanced system configuration directives to strip away almost all capabilities that the service does not need. For example, the service is prevented from seeing any other users' files, it cannot change its own identity to gain more power, and it is even restricted from writing to parts of the server where the operating system itself is stored. These measures have resulted in a security score of 2.4 on the standard assessment tool, indicating a very high level of protection.

## Reproducibility and Auditability
By codifying these decisions in our automation scripts, we have moved beyond manual, error-prone setups. Every time a new server is created, these exact security measures are applied automatically. This provides Nia and the board with a high degree of confidence that our production environment is exactly as secure as we have documented it to be. The logs from our deployment process prove that these configurations are applied consistently across all three servers in our environment.

## Current Gaps and Future Roadmap
While the current posture is robust, it is important to acknowledge what these measures do not protect against. We are currently protected against external network attacks and local privilege escalation attempts. However, we do not yet have deep inspection of the application traffic itself, nor do we have a system for automatically rotating our cryptographic keys on a frequent basis. Furthermore, our current setup assumes that the administrative keys used for deployment are kept secure by the engineers. Future iterations of the KijaniKiosk pipeline will focus on implementing automated key rotation, enhanced traffic monitoring, and integrating security scanning directly into our development process to catch potential vulnerabilities before they ever reach a server.

## Appendix: Security Assessment Score
The `kk-payments` service was assessed using the system security analyzer, achieving a final score of **2.4**. This represents a significant improvement from the default configuration and places the service in the "Safe" category according to industry standards for system service hardening.
