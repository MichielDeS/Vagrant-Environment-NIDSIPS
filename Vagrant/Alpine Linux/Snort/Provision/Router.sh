#!/bin/sh

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


# Enable IP forwarding
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
sudo sysctl -w net.ipv4.ip_forward=1

sudo apk update
sudo apk upgrade

sudo apk add gcc g++ make libpcap-dev pcre-dev bison flex build-base linux-headers


sudo apk add snort

wget https://www.snort.org/downloads/snort/snort-2.9.20.tar.gz
tar -xzvf snort-2.9.20.tar.gz

sudo cp snort-2.9.20/etc/classification.config snort-2.9.20/etc/reference.config /etc/snort/

sudo cp /vagrant/Provision/snort.conf /etc/snort/snort.conf

sudo mkdir -p /etc/snort/var/lib/snort/rules/

sudo cp /vagrant/provision/custom.rules /etc/snort/var/lib/snort/rules/Custom.rules
#sudo touch /etc/snort/var/lib/snort/rules/Custom.rules

sudo cp snort-2.9.20/etc/unicode.map /etc/snort/

sudo cp snort-2.9.20/etc/threshold.conf /etc/snort/

sudo snort -c /etc/snort/snort.conf -i eth2 &

sudo cp /vagrant/Provision/TestScript.sh /home/vagrant/TestScript.sh

sudo chmod +x /home/vagrant/TestScript.sh

./TestScript.sh

