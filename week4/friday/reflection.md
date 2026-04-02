# Reflection: KijaniKiosk Full IaC Pipeline

### 1. Conflict Discovery
During the integration, I discovered that `ProtectSystem=strict` and the location of environment files had a potential conflict. If environment files were placed under `/etc/`, the service might fail to read them because `ProtectSystem=strict` can make system directories read-only for the service. I resolved this by ensuring all configuration and environment files were placed under `/opt/kijanikiosk/config/`, which remains accessible and writable by the management system (Ansible) while still being protected from the service itself. This taught me that hardening measures must be carefully coordinated with the filesystem layout.

### 2. Rewriting for Tendo
**Original for Nia:** "The system provides each service with its own private area for temporary files, preventing information leakage."
**Technical for Tendo:** "The `PrivateTmp=yes` directive is enabled in the systemd unit files to instantiate a private `/tmp` and `/var/tmp` namespace for each process, effectively mitigating potential race conditions and information disclosure vulnerabilities via shared temporary storage."
**Lost/Gained:** The translation for Tendo gains precision about the mechanism (`namespaces`, `PrivateTmp`) and the specific vulnerabilities addressed, but it loses the immediate clarity and focus on the business outcome ("information leakage prevention") that Nia needs to communicate to the board.

### 3. The Fragile Handoff
The most fragile handoff is the extraction of the Terraform output IP addresses into the Ansible `inventory.ini` file via the `pipeline.sh` script. In a production environment, if the Terraform state becomes inconsistent or if the outputs are renamed, the Ansible configuration step will fail because it cannot find the target hosts. To make this handoff more robust, I would need to implement dynamic inventory discovery (e.g., using the `aws_ec2` Ansible plugin) instead of relying on manual file generation, which would allow Ansible to query the target environment directly for instances tagged with specific roles.
