#!/usr/bin/env bash
#########################################################
# Created by jacknab for php-mpos and nomp pool...
# This script is intended to be run on Debian 11
# like this:
# curl https://raw.githubusercontent.com/jacknab/scripts/main/install.sh | bash
#
#########################################################

# Log file location
LOG_FILE="/root/mpos_installation.log"

# Function to log messages and execute commands
function run_with_title() {
    local title="$1"
    local command="$2"
    
    # Log title and timestamp
    echo -e "\033[1;33m$title\033[0m" | tee -a "$LOG_FILE"
    echo -e "\033[5m"  # Start blinking text
    
    # Run the command and log output
    { 
        eval "$command" 
        echo "Success: $title" >> "$LOG_FILE"  # Log success
    } || {
        echo "Error: $title" >> "$LOG_FILE"  # Log error
        exit 1  # Exit on failure
    }

    echo -e "\033[25m"  # Stop blinking text
}

# Retrieve the MySQL root password from the file
# MYSQL_ROOT_PASSWORD=$(cat /root/mysql_information.txt)

# Hold MySQL packages to prevent them from being updated
sudo apt-mark hold mysql-server mysql-client

# Install necessary packages for adding repositories
sudo apt -y install software-properties-common
sudo apt install -y lsb-release ca-certificates apt-transport-https
sudo apt instal -y git curl zip wget

# Step 1: Install Webmin (commented out)
# echo "Installing Webmin..."
# echo "deb http://download.webmin.com/download/repository sarge contrib" | sudo tee /etc/apt/sources.list.d/webmin.list
# wget -qO - http://www.webmin.com/jcameron-key.asc | sudo apt-key add -
# sudo apt update
# sudo apt install -y webmin

run_with_title "Installing additional packages for MPOS..." "sudo apt-get install -y build-essential libcurl4-openssl-dev libdb5.3-dev libdb5.3++-dev"
run_with_title "Installing Python dependencies..." "sudo apt-get install -y python-twisted python-mysqldb python-dev python-setuptools python-memcache python-simplejson python-pylibmc"

# Stop and start Apache
run_with_title "Restarting Apache..." "sudo systemctl restart apache2"

# Install Boost libraries
run_with_title "Installing Boost libraries..." "sudo apt-get install -y libboost-all-dev"

# Install BerkeleyDB
# run_with_title "Installing BerkeleyDB..." "wget http://download.oracle.com/berkeley-db/db-4.8.30.zip && unzip db-4.8.30.zip && cd db-4.8.30 && cd build_unix/ && ../dist/configure --prefix=/usr/local --enable-cxx && make && sudo make install"

# Step 2: Install PHP 7.4.3
echo "Installing PHP 7.4.3..."
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
wget -qO - https://packages.sury.org/php/apt.gpg | sudo apt-key add -
sudo apt update
sudo apt -y install php7.4
sudo apt -y install memcached php7.4-memcached php7.4-mysql php7.4-cli php7.4-curl php7.4-mbstring php7.4-xml php7.4-zip php7.4-gd php7.4-json libapache2-mod-php7.4 curl
sudo apt-get -y install php7.4-cli php7.4-json php7.4-common php7.4-mysql php7.4-zip php7.4-gd php7.4-mbstring php7.4-curl php7.4-xml php7.4-bcmath
# php7.4 version
sudo apt-get -y install php7.4-mbstring php7.4-xml
sudo apt-get -y install php-mbstring php-xml php-mysql php-json php-curl php-zip
# common PHP extensions
sudo apt-get -y install php-mbstring php-json php-curl php-xml php-mysql php-mcrypt php-zip

# Step 3: Install Python 2.7
# Install python 2.7
sudo apt-get -y install python2.7
sudo ln -s /usr/bin/python2.7 /usr/bin/python
wget -4 https://bootstrap.pypa.io/pip/2.7/get-pip.py
sudo python2.7 get-pip.py
sudo apt-get install python-pip
sudo apt-get install libmysqlclient-dev
sudo apt-get install python2-dev
sudo apt-get install -y python2.7-dev build-essential
sudo apt-get install python-setuptools
pip install python-memcached
sudo apt-get install python-memcached
sudo apt-get install libmemcached-dev 
sudo apt-get install python-dev 
sudo apt-get install python-setuptools 
pip2 install pylibmc

# Python dependencies
sudo apt-get -y install python-twisted python-mysqldb python-dev python-setuptools python-memcache python-simplejson
pip install twisted
pip install python-mysqldb
pip install MySQL-python
pip install python-setuptools
pip install python-simplejson
pip2 install setuptools


# Set phpMyAdmin selections using the retrieved MySQL root password
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password 1825Logan305!" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password 1825Logan305!" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password 1825Logan305!" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | sudo debconf-set-selections

# Install phpMyAdmin without prompts
sudo apt install -y phpmyadmin

# Install Composer
echo "Installing Composer..."
sudo apt install php-cli unzip curl -y
curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
rm composer-setup.php

# Clone MPOS Repository
echo "Cloning MPOS repository..."
sudo apt install git -y
cd ~
cd /var/www
sudo git clone https://github.com/jacknab/php-mpos.git MPOS
cd MPOS
sudo update-alternatives --set php /usr/bin/php7.4
sudo a2dismod php8.3
sudo a2enmod php7.4
sudo systemctl restart apache2

# Install MPOS dependencies using Composer
echo "Installing MPOS dependencies..."
cd ~
cd /var/www/MPOS
php composer.phar install

# MPOS Database Setup
echo "Setting up the database..."
cd ~
cd /var/www/MPOS

# Use the generated MySQL root password for the command
sudo mysql -u root -p"1825Logan305!" -e "CREATE DATABASE mpos;"
sudo mysql -u root -p"1825Logan305!" mpos < sql/000_base_structure.sql

# Set MPOS Folder Permissions
echo "Setting folder permissions..."
sudo chown -R www-data templates/compile templates/cache logs
sudo cp include/config/global.inc.dist.php include/config/global.inc.php

# Change the authentication method for the root user
sudo mysql -u root -p"1825Logan305!" -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '1825Logan305!';"
sudo mysql -u root -p"1825Logan305!" -e "FLUSH PRIVILEGES;"

# Set the global sql_mode
sudo mysql -u root -p"1825Logan305!" -e "SET GLOBAL sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';"

echo -e "\033[1;32mInstallation completed successfully!\033[0m" | tee -a "$LOG_FILE"

# Restart Apache to apply changes
echo "Restarting Apache..."
sudo systemctl restart apache2
cd ~
curl https://raw.githubusercontent.com/jacknab/scripts/main/nomp.sh | bash

