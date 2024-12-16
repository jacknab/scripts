#!/usr/bin/env bash
#########################################################
# Created by jacknab for php-mpos and nomp pool...
# This script is intended to be run on Debian 11
# like this:
# curl https://raw.githubusercontent.com/jacknab/scripts/main/laravel.sh | bash
#
#########################################################

# Exit script on any error
set -e

# Variables (Adjust these as needed)
MYSQL_ROOT_PASSWORD="1825Logan305!"  # Set MySQL root password
DB_NAME="casinosh_aviator"
DB_USER="root"
DB_PASSWORD="1825Logan305!"
PHP_VERSION="8.1"
NODE_VERSION="18"

# Update and upgrade the system
echo "Updating system..."
sudo apt update && sudo apt upgrade -y

# Install required packages
echo "Installing prerequisites..."
sudo apt install -y software-properties-common curl unzip zip git nginx

# Add PHP repository and install PHP + extensions
echo "Installing PHP $PHP_VERSION..."
sudo add-apt-repository -y ppa:ondrej/php
sudo apt update
sudo apt install -y php$PHP_VERSION php$PHP_VERSION-fpm php$PHP_VERSION-mysql php$PHP_VERSION-cli php$PHP_VERSION-curl php$PHP_VERSION-mbstring php$PHP_VERSION-xml php$PHP_VERSION-zip

# Configure Nginx for Laravel
echo "Configuring Nginx..."
LARAVEL_CONF="/etc/nginx/sites-available/aviator"
sudo tee $LARAVEL_CONF > /dev/null <<EOL
server {
    listen 80;
    server_name _;
    root /var/www/html;

    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php$PHP_VERSION-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOL

# Enable Aviator site and restart Nginx
sudo ln -s $LARAVEL_CONF /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default
sudo systemctl restart nginx

# Install MySQL server
echo "Installing MySQL..."
sudo apt install -y mysql-server

# Configure MySQL with non-interactive root password
echo "Configuring MySQL..."
sudo mysql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$MYSQL_ROOT_PASSWORD';
FLUSH PRIVILEGES;
CREATE DATABASE $DB_NAME;
CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
CREATE DATABASE casinosh_aviator;
EXIT;
EOF

# Import SQL file into casinosh_aviator database
echo "Importing casinosh_aviator.sql..."
sudo mysql -u root -p"$MYSQL_ROOT_PASSWORD" casinosh_aviator < /opt/aviator/casinosh_aviator.sql

# Install Node.js
echo "Installing Node.js v$NODE_VERSION..."
curl -fsSL https://deb.nodesource.com/setup_$NODE_VERSION.x | sudo -E bash -
sudo apt install -y nodejs

# Install Composer (PHP dependency manager)
echo "Installing Composer..."
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Install phpMyAdmin
echo "Installing phpMyAdmin..."
sudo DEBIAN_FRONTEND=noninteractive apt install -y phpmyadmin

# Set permissions for web application folder
echo "Setting up Aviator application..."
sudo mkdir -p /var/www/html
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 775 /var/www/html

# Unzip aviator.zip and move .env
echo "Configuring Aviator application..."
sudo unzip /opt/aviator/aviator.zip -d /var/www/html
sudo rm /var/www/html/laravel/.env
sudo mv /opt/aviator/.env /var/www/html/laravel

# Final message
echo "Aviator environment setup completed!"
echo "MySQL root password: $MYSQL_ROOT_PASSWORD"
echo "Database: $DB_NAME, User: $DB_USER, Password: $DB_PASSWORD"
echo "Document root: /var/www/html"
