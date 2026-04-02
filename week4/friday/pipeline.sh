#!/bin/bash
set -e

# Change to terraform directory
cd "$(dirname "$0")/terraform"

# Terraform Apply
echo "Running Terraform Apply..."
terraform init
terraform apply -auto-approve -var="key_name=id_rsa"

# Extract IPs
API_IP=$(terraform output -raw api_ip)
PAYMENTS_IP=$(terraform output -raw payments_ip)
LOGS_IP=$(terraform output -raw logs_ip)

# Return to parent directory
cd ..

# Write to inventory.ini
echo "Writing IPs to ansible/inventory.ini..."
cat <<EOF > ansible/inventory.ini
[kijanikiosk]
api ansible_host=$API_IP
payments ansible_host=$PAYMENTS_IP
logs ansible_host=$LOGS_IP

[kijanikiosk:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/id_rsa
EOF

# Run Ansible
echo "Running Ansible Playbook..."
cd ansible
ansible-playbook -i inventory.ini kijanikiosk.yml
