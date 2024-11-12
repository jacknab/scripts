#!/usr/bin/env bash
#########################################################
# Created by jacknab for php-mpos and nomp pool...
# This script is intended to be run on Debian 11
# like this:
# curl https://raw.githubusercontent.com/jacknab/scripts/main/instal.sh | bash
#
#########################################################

sudo apt install sudo wget -y

cd ~
# Step 1: Install required packages
sudo apt update
sudo apt install -y gnupg openssl

# Step 2: Download MySQL APT configuration package
wget -4 https://dev.mysql.com/get/mysql-apt-config_0.8.18-1_all.deb

# Step 3: Preconfigure MySQL APT package selections
echo "mysql-apt-config mysql-apt-config/select-server select mysql-5.7" | sudo debconf-set-selections
echo "mysql-apt-config mysql-apt-config/select-version select buster" | sudo debconf-set-selections

# Step 4: Install MySQL APT configuration without prompts
sudo DEBIAN_FRONTEND=noninteractive dpkg -i mysql-apt-config_0.8.18-1_all.deb

# Step 5: Replace 'bullseye' with 'buster' in the MySQL repository file
sudo sed -i 's/bullseye/buster/g' /etc/apt/sources.list.d/mysql.list

# Step 6: Add the MySQL GPG key
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B7B3B788A8D3785C

# Step 7: Update package list again
sudo apt update

# Step 8: Generate a random alphanumeric password for MySQL root
# MYSQL_ROOT_PASSWORD=$(openssl rand -base64 12)

# Save the password to a text file
# echo "1825Logan305!" | sudo tee /mysql_information.txt > /dev/null

# Step 9: Set MySQL root password in debconf before installing
echo "mysql-server mysql-server/root_password password 1825Logan305!" | sudo debconf-set-selections
echo "mysql-server mysql-server/root_password_again password 1825Logan305!" | sudo debconf-set-selections

# Step 10: Install MySQL server without prompts
sudo DEBIAN_FRONTEND=noninteractive apt install -y mysql-server

# Step 11: Start and enable MySQL service
sudo systemctl start mysql
sudo systemctl enable mysql

# Step 12: Cleanup
rm -f mysql-apt-config_0.8.18-1_all.deb

# Optional: Print out the generated password
echo "MySQL root password: 1825Logan305!"

cd ~
curl https://raw.githubusercontent.com/jacknab/scripts/main/php0.sh | bash

