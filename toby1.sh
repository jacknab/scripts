#!/usr/bin/env bash
#########################################################
# Created by jacknab for php-mpos and nomp pool...
# This script is intended to be run on Debian 11
# like this:
# curl https://raw.githubusercontent.com/jacknab/scripts/main/toby1.sh | bash
#
#########################################################

# Install necessary packages for adding repositories
sudo apt -y install software-properties-common
sudo apt install -y lsb-release ca-certificates apt-transport-https
sudo apt instal -y git curl zip wget

run_with_title "Installing additional packages for MPOS..." "sudo apt-get install -y build-essential libcurl4-openssl-dev libdb5.3-dev libdb5.3++-dev"
run_with_title "Installing Python dependencies..." "sudo apt-get install -y python-twisted python-mysqldb python-dev python-setuptools python-memcache python-simplejson python-pylibmc"

# Stop and start Apache
run_with_title "Restarting Apache..." "sudo systemctl restart apache2"

# Install Boost libraries
run_with_title "Installing Boost libraries..." "sudo apt-get install -y libboost-all-dev"
sudo apt update
sudo apt-get -y install php-mbstring php-xml php-mysql php-json php-curl php-zip
# common PHP extensions
sudo apt-get -y install php-mbstring php-json php-curl php-xml php-mysql php-mcrypt php-zip


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









# Change the authentication method for the root user
sudo mysql -u root -p"1825Logan305!" -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '1825Logan305!';"
sudo mysql -u root -p"1825Logan305!" -e "FLUSH PRIVILEGES;"

# Restart Apache to apply changes
echo "Restarting Apache..."
sudo systemctl restart apache2
