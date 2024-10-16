#!/usr/bin/env bash
#########################################################
# Created by jacknab for php-mpos and nomp pool...
# This script is intended to be run on Debian 11
# like this:
# curl https://raw.githubusercontent.com/jacknab/scripts/main/install.sh | bash
# This is for scrypt algo for NOMP
#########################################################

# File paths and URLs
A_PATH="/root/nomp/libs/profitSwitch.js"
A1_URL="https://raw.githubusercontent.com/jacknab/scripts/main/profitSwitch.js"
A2_URL="https://raw.githubusercontent.com/jacknab/scripts/main/profitSwitch.js"

B_PATH="/root/nomp/node_modules/stratum-pool/lib/pool.js"
B1_URL="https://raw.githubusercontent.com/jacknab/scripts/main/pool.js"
B2_URL="https://raw.githubusercontent.com/jacknab/scripts/main/pool.js"

# Function to replace a file and download it from two potential URLs if needed
replace_file() {
  local FILE_PATH=$1
  local PRIMARY_URL=$2
  local SECONDARY_URL=$3

  # Attempt to remove the file
  sudo rm -f "$FILE_PATH"
  
  # Check if the file still exists
  if [ -f "$FILE_PATH" ]; then
    echo "File $FILE_PATH still exists. Attempting removal again..."
    sudo rm -f "$FILE_PATH"
  fi

  # Verify the file was removed
  if [ ! -f "$FILE_PATH" ]; then
    echo "File removed successfully. Proceeding with download for $FILE_PATH..."
    
    # Try to download the file from the primary URL
    wget -4 "$FILE_PATH" "$PRIMARY_URL"
    
    # Check if the file was downloaded
    if [ -f "$FILE_PATH" ]; then
      echo "File downloaded successfully from primary URL."
    else
      echo "Failed to download $FILE_PATH from primary URL. Trying secondary URL..."
      
      # Attempt to download from the secondary URL
      wget "$FILE_PATH" "$SECONDARY_URL"
      
      # Verify if the file was downloaded from the secondary URL
      if [ -f "$FILE_PATH" ]; then
        echo "File downloaded successfully from secondary URL."
      else
        echo "Failed to download $FILE_PATH from both URLs."
      fi
    fi
  else
    echo "File $FILE_PATH could not be removed. Check permissions or path."
  fi
}

# Replace the first file (profitSwitch.js)
replace_file "$A_PATH" "$A1_URL" "$A2_URL"

# Replace the second file (pool.js)
replace_file "$B_PATH" "$B1_URL" "$B2_URL"


cd ~
echo "Replacements completed successfully!"




