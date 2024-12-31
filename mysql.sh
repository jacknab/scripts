#!/usr/bin/env bash
#########################################################
# Modified to install the latest MySQL on Debian 12 (Bookworm)
#########################################################

# Step 1: Install required packages
sudo apt update
sudo apt install -y gnupg wget lsb-release ca-certificates

# Step 2: Add MySQL APT repository for Debian Bookworm (latest MySQL version)
echo "deb [arch=amd64] https://repo.mysql.com/apt/debian/ $(lsb_release -cs) mysql-8.0" | sudo tee /etc/apt/sources.list.d/mysql.list

# Step 3: Download and install MySQL APT repository configuration package
wget https://dev.mysql.com/get/mysql-apt-config_0.8.26-1_all.deb
sudo dpkg -i mysql-apt-config_0.8.26-1_all.deb

# Step 4: Add the MySQL GPG key
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B7B3B788A8D3785C

# Step 5: Update package list
sudo apt update

# Step 6: Set MySQL root password in debconf before installing
echo "mysql-server mysql-server/root_password password 1825Logan305!" | sudo debconf-set-selections
echo "mysql-server mysql-server/root_password_again password 1825Logan305!" | sudo debconf-set-selections

# Step 7: Install the latest MySQL server without prompts
sudo DEBIAN_FRONTEND=noninteractive apt install -y mysql-server

# Step 8: Start and enable MySQL service
sudo systemctl start mysql
sudo systemctl enable mysql

# Step 9: Clean up
rm -f mysql-apt-config_0.8.26-1_all.deb

# Step 10: Verify MySQL version
mysql --version
