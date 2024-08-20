#!/bin/bash

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

sudo yum -y update
#sudo yum -y upgrade

sudo yum install -y epel-release

#sudo yum install -y wget make cmake build-essential libpcap-dev libpcre3-dev zlib1g-dev bison flex autoconf libtool check luajit libluajit-5.1-dev libssl-dev zip


sudo yum install -y wget make cmake gcc gcc-c++

sudo dnf --enablerepo=crb install -y libpcap-devel
sudo dnf --enablerepo=crb install -y libtirpc-devel

sudo dnf install -y pcre-devel

wget https://github.com/ofalk/libdnet/archive/refs/tags/libdnet-1.12.tar.gz

tar -xzvf libdnet-1.12.tar.gz

cd libdnet-libdnet-1.12

./configure && make && sudo make install

sudo ldconfig

cd ..

wget https://www.snort.org/downloads/snort/daq-2.0.7.tar.gz

tar zxvf daq-2.0.7.tar.gz

cd daq-2.0.7/

export PATH=$PATH:/usr/local/bin

./configure --with-libpcap-includes=/opt/napatech3/include/ --with-libpcap-libraries=/opt/napatech3/lib/

make

sudo make install

cd ..

wget https://www.snort.org/downloads/snort/snort-2.9.20.tar.gz

tar zxvf snort-2.9.20.tar.gz

cd snort-2.9.20/

CPPFLAGS="-I/usr/include/tirpc" LDFLAGS="-L/usr/lib64" ./configure --enable-sourcefire --disable-open-appid --prefix=/usr/local/snort --with-libpcap-includes=/opt/napatech3/include/ --with-libpcap-libraries=/opt/napatech3/lib/

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


