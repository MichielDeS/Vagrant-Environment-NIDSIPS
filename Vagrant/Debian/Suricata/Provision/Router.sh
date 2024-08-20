#!/bin/sh
# Enable IP forwarding
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
sudo sysctl -w net.ipv4.ip_forward=1


# Update package list and upgrade packages
sudo apt update

# Install Suricata
sudo apt-get install -y suricata

sudo systemctl stop suricata

sleep 5

# Copy suricata.yaml and custom.rules to /etc/suricata
sudo cp /vagrant/Provision/suricata.yaml /etc/suricata/suricata.yaml
sudo cp /vagrant/Provision/custom.rules /var/lib/suricata/rules/custom.rules

# Ensure proper permissions
sudo chmod 644 /etc/suricata/suricata.yaml
sudo chmod 644 /var/lib/suricata/rules/custom.rules

sudo systemctl enable suricata
sudo systemctl start suricata

sudo cp /vagrant/Provision/TestScript.sh /home/vagrant/TestScript.sh

sudo chmod +x /home/vagrant/TestScript.sh

./TestScript.sh
