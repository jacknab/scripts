#!/usr/bin/env bash
#########################################################
# Updated by jacknab for php-mpos and nomp pool...
# This script is intended to be run like this:
#
# curl https://raw.githubusercontent.com/jacknab/scripts/main/install.sh | bash
#
#########################################################

# Path to the Apache configuration file
APACHE_CONF="/root/etc/apache2/sites-available/000-default.conf"

# Check if the file exists
if [ -f "$APACHE_CONF" ]; then
  # Backup the original file
  sudo cp "$APACHE_CONF" "$APACHE_CONF.bak"
  
  # Use sed to replace 'html' with 'MPOS/public'
  sudo sed -i 's/html/MPOS\/public/g' "$APACHE_CONF"
  
  echo "The configuration file has been updated successfully."
else
  echo "The Apache configuration file does not exist at $APACHE_CONF."
fi

sudo systemctl restart apache2

