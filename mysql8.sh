#!/usr/bin/env bash
#########################################################
# Created by jacknab for php-mpos and nomp pool...
# This script is intended to be run on Debian 11 (Bullseye)
# like this:
# curl https://raw.githubusercontent.com/jacknab/scripts/main/mysql8.sh | bash
#
#########################################################

# Install necessary utilities
sudo apt install sudo wget -y

cd ~

# Step 1: Install required packages
sudo apt update
sudo apt install -y gnupg openssl

# Step 2: Download MySQL APT configuration package
wget -4 https://dev.mysql.com/get/mysql-apt-config_0.8.26-1_all.deb

# Step 3: Preconfigure MySQL APT package selections for MySQL 8.0 and Bullseye
echo "mysql-apt-config mysql-apt-config/select-server select mysql-8.0" | sudo debconf-set-selections
echo "mysql-apt-config mysql-apt-config/select-version select bullseye" | sudo debconf-set-selections

# Step 4: Install MySQL APT configuration without prompts
sudo DEBIAN_FRONTEND=noninteractive dpkg -i mysql-apt-config_0.8.26-1_all.deb

# Step 5: Update MySQL repository list (Ensure it's set for Bullseye, and MySQL 8.0)
sudo sed -i 's/bullseye/bullseye/g' /etc/apt/sources.list.d/mysql.list

# Step 6: Add the MySQL GPG key
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B7B3B788A8D3785C

# Step 7: Update package list again to reflect MySQL 8.0 repository
sudo apt update

# Step 8: Set MySQL root password in debconf before installing
echo "mysql-server mysql-server/root_password password 1825Logan305!" | sudo debconf-set-selections
echo "mysql-server mysql-server/root_password_again password 1825Logan305!" | sudo debconf-set-selections

# Step 9: Install MySQL server 8.0 without prompts
sudo DEBIAN_FRONTEND=noninteractive apt install -y mysql-server

# Step 10: Start and enable MySQL service
sudo systemctl start mysql
sudo systemctl enable mysql

# Step 11: Cleanup
rm -f mysql-apt-config_0.8.26-1_all.deb



# Final step: Execute additional setup script
# curl https://raw.githubusercontent.com/jacknab/scripts/main/php.sh | bash
