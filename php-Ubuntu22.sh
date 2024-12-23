#!/usr/bin/env bash
#########################################################
# Created by jacknab for php-mpos and nomp pool...
# This script is intended to be run on Ubuntu 22.04
# like this:
# curl https://raw.githubusercontent.com/jacknab/scripts/main/install-ubuntu22.04.sh | bash
#
#########################################################

# Install necessary packages for adding repositories
sudo apt -y install software-properties-common
sudo apt install -y lsb-release ca-certificates apt-transport-https
sudo apt install -y git curl zip wget

# Run with a title (this function should be implemented in your script or removed if unnecessary)
run_with_title "Installing additional packages for MPOS..." "sudo apt-get install -y build-essential libcurl4-openssl-dev libdb5.3-dev libdb5.3++-dev"
run_with_title "Installing Python dependencies..." "sudo apt-get install -y python-twisted python-mysqldb python-dev python-setuptools python-memcache python-simplejson python-pylibmc"

# Stop and start Apache
run_with_title "Restarting Apache..." "sudo systemctl restart apache2"

# Install Boost libraries
run_with_title "Installing Boost libraries..." "sudo apt-get install -y libboost-all-dev"

# Step 2: Add PHP 7.4 repository and install PHP 7.4
echo "Adding PHP 7.4 repository..."
sudo add-apt-repository -y ppa:ondrej/php
sudo apt update
sudo apt -y install php7.4 php7.4-cli php7.4-curl php7.4-mysql php7.4-mbstring php7.4-xml php7.4-zip php7.4-gd php7.4-json libapache2-mod-php7.4

# Install PHP 7.4 extensions
sudo apt-get -y install php7.4-cli php7.4-json php7.4-common php7.4-mysql php7.4-zip php7.4-gd php7.4-mbstring php7.4-curl php7.4-xml php7.4-bcmath

# Install Memcached and other required PHP packages
sudo apt-get -y install memcached php7.4-memcached

# Step 3: Install Python 2.7 and pip
echo "Installing Python 2.7..."
sudo apt-get -y install python2.7
sudo ln -s /usr/bin/python2.7 /usr/bin/python
wget -4 https://bootstrap.pypa.io/pip/2.7/get-pip.py
sudo python2.7 get-pip.py
sudo apt-get -y install python-pip
sudo apt-get -y install libmysqlclient-dev
sudo apt-get -y install python2-dev
sudo apt-get -y install python2.7-dev build-essential
sudo apt-get -y install python-setuptools
pip install -y python-memcached
sudo apt-get -y install python-memcached
sudo apt-get -y install libmemcached-dev
sudo apt-get -y install python-dev
sudo apt-get -y install python-setuptools
pip2 install -y pylibmc

sudo apt-get -y install python-twisted python-mysqldb python-dev python-setuptools python-memcache python-simplejson
pip install twisted --no-input
pip install python-mysqldb --no-input
pip install MySQL-python --no-input
pip install python-setuptools --no-input
pip install python-simplejson --no-input
pip2 install setuptools --no-input

# Set phpMyAdmin selections using the retrieved MySQL root password
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password 1825Logan305!" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password 1825Logan305!" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password 1825Logan305!" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | sudo debconf-set-selections

# Install phpMyAdmin without prompts
sudo apt install -y phpmyadmin

# Install Composer
sudo apt install -y php-cli unzip curl
curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
sudo rm composer-setup.php
composer self-update
composer config --global --list
sudo systemctl restart apache2
composer update

# Clone MPOS Repository
sudo apt -y install git
cd ~
cd /var/www
sudo git clone https://github.com/jacknab/php-mpos.git MPOS
cd MPOS
sudo update-alternatives --set php /usr/bin/php7.4
sudo a2dismod php8.3
sudo a2enmod php7.4
sudo systemctl restart apache2

# Install MPOS dependencies using Composer
cd ~
cd /var/www/MPOS
sudo php composer.phar install

# MPOS Database Setup
cd ~
cd /var/www/MPOS

# Use the generated MySQL root password for the command
sudo mysql -u root -p"1825Logan305!" -e "CREATE DATABASE mpos;"
sudo mysql -u root -p"1825Logan305!" mpos < sql/000_base_structure.sql

# Set MPOS Folder Permissions
sudo chown -R www-data templates/compile templates/cache logs
sudo cp include/config/global.inc.dist.php include/config/global.inc.php

# Change the authentication method for the root user
sudo mysql -u root -p"1825Logan305!" -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '1825Logan305!';"
sudo mysql -u root -p"1825Logan305!" -e "FLUSH PRIVILEGES;"

# Set the global sql_mode
sudo mysql -u root -p"1825Logan305!" -e "SET GLOBAL sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';"

# Restart Apache to apply changes
echo "Restarting Apache..."
sudo systemctl restart apache2

cd ~
curl https://raw.githubusercontent.com/jacknab/scripts/main/nomp.sh | bash
