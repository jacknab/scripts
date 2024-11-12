#!/usr/bin/env bash
#########################################################
# Created by jacknab for php-mpos and nomp pool...
# This script is intended to be run on Ubuntu 22.04
# like this:
# curl https://raw.githubusercontent.com/jacknab/scripts/main/install-ubuntu22.sh | bash
#
#########################################################

# Install required packages and update system
sudo apt update
sudo apt install -y sudo wget gnupg openssl lsb-release

cd ~

# Step 1: Install MySQL APT configuration package for MySQL 5.7
wget -4 https://dev.mysql.com/get/mysql-apt-config_0.8.18-1_all.deb

# Step 2: Preconfigure MySQL APT package selections
echo "mysql-apt-config mysql-apt-config/select-server select mysql-5.7" | sudo debconf-set-selections
echo "mysql-apt-config mysql-apt-config/select-version select focal" | sudo debconf-set-selections

# Step 3: Install MySQL APT configuration without prompts
sudo DEBIAN_FRONTEND=noninteractive dpkg -i mysql-apt-config_0.8.18-1_all.deb

# Step 4: Update the MySQL repository file for Ubuntu 22.04 (focal)
sudo sed -i 's/bullseye/focal/g' /etc/apt/sources.list.d/mysql.list

# Step 5: Add the MySQL GPG key (Ubuntu 22.04)
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B7B3B788A8D3785C

# Step 6: Update package list again
sudo apt update

# Step 7: Set MySQL root password and configure MySQL installation
echo "mysql-server mysql-server/root_password password 1825Logan305!" | sudo debconf-set-selections
echo "mysql-server mysql-server/root_password_again password 1825Logan305!" | sudo debconf-set-selections

# Step 8: Install MySQL server without prompts
sudo DEBIAN_FRONTEND=noninteractive apt install -y mysql-server

# Step 9: Start and enable MySQL service
sudo systemctl start mysql
sudo systemctl enable mysql

# Step 10: Cleanup
rm -f mysql-apt-config_0.8.18-1_all.deb

# Optional: Print out the generated password (for reference, not needed in production)
echo "MySQL root password: 1825Logan305!"

# Running the next script to install PHP and other dependencies
curl https://raw.githubusercontent.com/jacknab/scripts/main/php-Ubuntu22.sh | bash
