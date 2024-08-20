#!/bin/sh
sudo apt-get update
sudo apt-get install -y nmap

sudo ip route add 172.10.0.10 via 192.168.60.253

sudo apt-get update -y

sudo apt-get install -y sqlmap

# Copy attack script to vm
sudo cp /vagrant/Provision/AttackNmap.sh /home/vagrant/AttackNmap.sh

sudo cp /vagrant/Provision/AttackSQL.sh /home/vagrant/AttackSQL.sh

# Ensure proper permissions
sudo chmod +x /home/vagrant/AttackNmap.sh

sudo chmod +x /home/vagrant/AttackSQL.sh

sudo nohup ./AttackNmap.sh &

#sudo nohup ./AttackSQL.sh &




