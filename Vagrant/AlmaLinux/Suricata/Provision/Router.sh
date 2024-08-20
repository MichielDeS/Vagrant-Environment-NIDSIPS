#!/bin/sh
# Enable IP forwarding

# Turn off all swap
sudo swapoff -a

# Remove existing swap file if it exists
if [ -f /swapfile ]; then
    echo "Removing existing swap file"
    sudo rm /swapfile
fi

# Check for other swap files
if grep -q 'swap' /etc/fstab; then
    echo "Removing other swap entries from /etc/fstab"
    sudo sed -i '/swap/d' /etc/fstab
fi

sudo dd if=/dev/zero of=/swapfile bs=1M count=1024

sudo chmod 600 /swapfile

sudo mkswap /swapfile

sudo swapon /swapfile

echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
sudo sysctl -w net.ipv4.ip_forward=1

sudo dnf -y update
#sudo yum -y upgrade

sudo dnf install -y epel-release

sudo dnf install -y suricata

sudo systemctl stop suricata

sleep 5

sudo cp /vagrant/Provision/suricata.yaml /etc/suricata/suricata.yaml
sudo cp /vagrant/Provision/custom.rules /etc/suricata/rules/custom.rules

sudo sed -i 's|OPTIONS="-i eth0|OPTIONS="-i eth1|' /etc/sysconfig/suricata

# Ensure proper permissions
sudo chmod 644 /etc/suricata/suricata.yaml
sudo chmod 644 /etc/suricata/rules/custom.rules

sudo systemctl enable suricata

sudo systemctl start suricata

sudo cp /vagrant/Provision/TestScript.sh /home/vagrant/TestScript.sh

sudo chmod +x /home/vagrant/TestScript.sh

./TestScript.sh
