#!/bin/bash
# KijaniKiosk Production Server Provisioning Script
# Week 3 - Friday Project

echo "=========================================="
echo "KijaniKiosk Provisioning Script Starting"
echo "=========================================="

# Phase 1: Create service accounts
echo ""
echo "=== PHASE 1: Creating Service Accounts ==="

# Create group if not exists
if ! getent group kijanikiosk > /dev/null; then
    sudo groupadd kijanikiosk
    echo "✓ Created kijanikiosk group"
else
    echo "✓ kijanikiosk group already exists"
fi

# Create users
for user in kk-api kk-payments kk-logs; do
    if ! id "$user" &>/dev/null; then
        sudo useradd -r -g kijanikiosk -s /usr/sbin/nologin "$user"
        echo "✓ Created $user"
    else
        echo "✓ $user already exists"
    fi
done

# Phase 2: Create directories
echo ""
echo "=== PHASE 2: Creating Directories ==="

sudo mkdir -p /opt/kijanikiosk/{config,shared/logs,health}
echo "✓ Created /opt/kijanikiosk structure"

sudo chown -R root:kijanikiosk /opt/kijanikiosk
sudo chmod 750 /opt/kijanikiosk
echo "✓ Set ownership and permissions"

# Phase 3: Set up ACLs
echo ""
echo "=== PHASE 3: Setting ACLs ==="

# Set ACLs on logs directory
sudo setfacl -m u:kk-api:rwx /opt/kijanikiosk/shared/logs
sudo setfacl -m u:kk-payments:rx /opt/kijanikiosk/shared/logs
sudo setfacl -m g:kijanikiosk:rwx /opt/kijanikiosk/shared/logs

# Set default ACLs for new files
sudo setfacl -d -m u:kk-api:rwx /opt/kijanikiosk/shared/logs
sudo setfacl -d -m u:kk-payments:rx /opt/kijanikiosk/shared/logs
sudo setfacl -d -m g:kijanikiosk:rwx /opt/kijanikiosk/shared/logs
echo "✓ ACLs configured"

# Phase 4: Create environment files
echo ""
echo "=== PHASE 4: Creating Environment Files ==="

echo "PORT=3000" | sudo tee /opt/kijanikiosk/config/api.env > /dev/null
echo "PORT=3001" | sudo tee /opt/kijanikiosk/config/payments-api.env > /dev/null
sudo chmod 640 /opt/kijanikiosk/config/*.env
echo "✓ Environment files created"

# Phase 5: Create systemd service files
echo ""
echo "=== PHASE 5: Creating systemd Services ==="

# kk-logs service
sudo tee /etc/systemd/system/kk-logs.service > /dev/null << 'EOF'
[Unit]
Description=KijaniKiosk Log Service
After=network.target

[Service]
Type=simple
User=kk-logs
Group=kijanikiosk
ExecStart=/bin/sleep infinity
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# kk-api service
sudo tee /etc/systemd/system/kk-api.service > /dev/null << 'EOF'
[Unit]
Description=KijaniKiosk API Service
After=network.target

[Service]
Type=simple
User=kk-api
Group=kijanikiosk
ExecStart=/bin/sleep infinity
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# kk-payments service
sudo tee /etc/systemd/system/kk-payments.service > /dev/null << 'EOF'
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

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
echo "✓ Service files created"

# Phase 6: Configure firewall
echo ""
echo "=== PHASE 6: Configuring Firewall ==="

sudo ufw --force reset
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp comment 'SSH access'
sudo ufw allow 80/tcp comment 'HTTP web traffic'
sudo ufw --force enable
echo "✓ Firewall configured"

# Phase 7: Configure log rotation
echo ""
echo "=== PHASE 7: Configuring Log Rotation ==="

sudo tee /etc/logrotate.d/kijanikiosk > /dev/null << 'EOF'
/opt/kijanikiosk/shared/logs/*.log {
    daily
    rotate 7
    missingok
    notifempty
    compress
    create 640 kk-logs kijanikiosk
}
EOF
echo "✓ Logrotate configured"

# Phase 8: Health check
echo ""
echo "=== PHASE 8: Health Check ==="

sudo mkdir -p /opt/kijanikiosk/health
sudo chown kk-logs:kijanikiosk /opt/kijanikiosk/health

echo '{"status":"provisioned","timestamp":"'$(date -Is)'"}' | sudo tee /opt/kijanikiosk/health/last-provision.json > /dev/null
sudo chmod 640 /opt/kijanikiosk/health/last-provision.json
echo "✓ Health check created"

echo ""
echo "=========================================="
echo "Provisioning Complete!"
echo "=========================================="