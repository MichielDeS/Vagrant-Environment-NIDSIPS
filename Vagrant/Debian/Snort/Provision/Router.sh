#!/bin/bash

# Enable IP forwarding
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
sudo sysctl -w net.ipv4.ip_forward=1

sudo apt update
sudo apt upgrade -y

sudo apt install -y build-essential libpcap-dev libpcre3-dev zlib1g-dev bison flex autoconf libtool check luajit libluajit-5.1-dev libssl-dev zip

wget https://github.com/ofalk/libdnet/archive/refs/tags/libdnet-1.12.tar.gz

tar -xzvf libdnet-1.12.tar.gz

cd libdnet-libdnet-1.12

./configure && make && sudo make install

sudo ldconfig

cd ..

wget https://www.snort.org/downloads/snort/daq-2.0.7.tar.gz

tar zxvf daq-2.0.7.tar.gz

cd daq-2.0.7/

./configure --with-libpcap-includes=/opt/napatech3/include/ --with-libpcap-libraries=/opt/napatech3/lib/

make

sudo make install

cd ..

wget https://www.snort.org/downloads/snort/snort-2.9.20.tar.gz

tar zxvf snort-2.9.20.tar.gz

cd snort-2.9.20/

./configure --enable-sourcefire --prefix=/usr/local/snort --with-libpcap-includes=/opt/napatech3/include/ --with-libpcap-libraries=/opt/napatech3/lib/

make

sudo make install

sudo mkdir /var/log/snort

export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

sudo mkdir /usr/local/snort/etc
sudo mkdir /usr/local/snort/rules

sudo cp /vagrant/Provision/snort.conf /usr/local/snort/etc/snort.conf
sudo cp /vagrant/Provision/custom.rules /usr/local/snort/rules/Custom.rules

sudo cp /home/vagrant/snort-2.9.20/etc/classification.config /home/vagrant/snort-2.9.20/etc/reference.config /home/vagrant/snort-2.9.20/etc/threshold.conf /home/vagrant/snort-2.9.20/etc/unicode.map /usr/local/snort/etc/

sudo touch /usr/local/snort/rules/black_list.rules
sudo touch /usr/local/snort/rules/white_list.rules

sudo mkdir -p /usr/local/snort/lib/snort_dynamicrules


sudo nohup env LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH /usr/local/snort/bin/snort -c /usr/local/snort/etc/snort.conf -i eth2 > /home/vagrant/output.log 2>&1 &

sudo cp /vagrant/Provision/TestScript.sh /home/vagrant/TestScript.sh

sudo chmod +x /home/vagrant/TestScript.sh

cd /home/vagrant

./TestScript.sh