#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or use sudo"
    exit 1
fi

# Install resolvconf
apt update && apt install -y resolvconf

# Enable and start resolvconf service
systemctl enable resolvconf
systemctl start resolvconf

# Check service status
systemctl status resolvconf --no-pager

# Update resolv.conf head file
cat <<EOF > /etc/resolvconf/resolv.conf.d/head
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF

# Apply changes
resolvconf --enable-updates
resolvconf -u

# Confirm changes
echo "Updated resolv.conf file:"
cat /etc/resolv.conf

echo "resolvconf setup completed successfully."
