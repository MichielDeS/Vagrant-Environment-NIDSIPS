#!/bin/bash
# Enable IP forwarding
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
sudo sysctl -w net.ipv4.ip_forward=1


# Update package list and upgrade packages
sudo apt-get update

sudo apt-get install -y --no-install-recommends cmake make gcc g++ flex libfl-dev bison libpcap-dev libssl-dev python3 python3-dev swig zlib1g-dev

echo 'deb http://download.opensuse.org/repositories/security:/zeek/Debian_11/ /' | sudo tee /etc/apt/sources.list.d/security:zeek.list


curl -fsSL https://download.opensuse.org/repositories/security:zeek/Debian_11/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/security_zeek.gpg > /dev/null

sudo apt-get update

sudo apt-get install -y zeek-lts

echo 'export PATH=/usr/local/zeek/bin:$PATH' >> ~/.bashrc

echo 'export PATH=/opt/zeek/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

rm /opt/zeek/etc/networks.cfg

cp /vagrant/provision/networks.cfg /opt/zeek/etc/networks.cfg

rm /opt/zeek/etc/node.cfg

cp /vagrant/provision/node.cfg /opt/zeek/etc/node.cfg

rm /opt/zeek/etc/zeekctl.cfg

cp /vagrant/provision/zeekctl.cfg /opt/zeek/etc/zeekctl.cfg

sudo /opt/zeek/bin/zeekctl deploy

sleep 5

sudo cp /vagrant/Provision/TestScript.sh /home/vagrant/TestScript.sh

sudo chmod +x /home/vagrant/TestScript.sh

./TestScript.sh
