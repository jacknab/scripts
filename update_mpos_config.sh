#!/usr/bin/env bash
#########################################################
# Updated by jacknab for php-mpos and nomp pool...
# This script is intended to be run like this:
#
# curl https://raw.githubusercontent.com/jacknab/scripts/main/install.sh | bash
#
#########################################################

# Define the file path
file_path="/var/www/MPOS/include/config/global.inc.php"

# Generate random strings: 27 characters and 28 characters
random_str_27=$(cat /dev/urandom | tr -dc 'A-Z' | fold -w 27 | head -n 1)
random_str_28=$(cat /dev/urandom | tr -dc 'A-Z' | fold -w 28 | head -n 1)

# Replace the text in the file
sed -i "s/\$config\['check_valid_coinaddress'\] = true;/\$config['check_valid_coinaddress'] = false;/g" "$file_path"
sed -i "s/PLEASEMAKEMESOMETHINGRANDOM/$random_str_27/g" "$file_path"
sed -i "s/THISSHOULDALSOBERRAANNDDOOM/$random_str_28/g" "$file_path"
sed -i "s/\$config\['db'\]\['user'\] = 'someuser';/\$config['db']['user'] = 'root';/g" "$file_path"
sed -i "s/\$config\['db'\]\['pass'\] = 'somepass';/\$config['db']['pass'] = '1825Logan305!';/g" "$file_path"

# Confirm changes
echo "Text replacement completed!"
echo "Random 27-character string: $random_str_27"
echo "Random 28-character string: $random_str_28"
cd ~
bash /update_apache_conf.sh
