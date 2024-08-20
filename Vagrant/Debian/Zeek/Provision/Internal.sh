#!/bin/bash

# Update the netplan configuration file
sudo bash -c "cat > /etc/netplan/50-vagrant.yaml <<EOF
network:
  version: 2
  ethernets:
    eth1:
      dhcp4: no
      addresses:
        - 172.10.0.10/24
      gateway4: 172.10.0.254
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4
EOF"

# Install necessary packages
sudo apt-get update
sudo apt-get install -y apache2 mysql-server php php-mysql libapache2-mod-php

sudo systemctl enable apache2
sudo systemctl enable mysql


sudo systemctl start apache2
sudo systemctl start mysql

sudo cp /vagrant/Provision/Vuln.php /var/www/html/vulnerable.php

sudo mysql -u root -p'YOUR_MYSQL_ROOT_PASSWORD' <<EOF
CREATE DATABASE testdb;
USE testdb;
CREATE TABLE users (id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY, name VARCHAR(30) NOT NULL);
INSERT INTO users (name) VALUES ('John Doe');
INSERT INTO users (name) VALUES ('Jane Doe');
EOF

sudo chown -R www-data:www-data /var/www/html

echo "Setup complete. The vulnerable PHP application is available at http://172.10.0.10/vulnerable.php"

# Apply the netplan configuration
sudo netplan apply