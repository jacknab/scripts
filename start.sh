#!/usr/bin/env bash
#########################################################
# Created by jacknab | jacknabvoip@mgail.com
# Start script for setting up MPOS and NOMP on different OS
#########################################################

# Prompt user to select OS
echo "Please select your operating system:"
echo "[1] Debian 11"
echo "[2] Ubuntu 20.04"
echo "[3] Ubuntu 22.04"
read -p "Enter the number of your choice: " os_choice

# Based on the user's choice, run the corresponding install script
case $os_choice in
  1)
    echo "You selected Debian 11. Running the Debian 11 setup script..."
    curl https://raw.githubusercontent.com/jacknab/scripts/main/install-debian11.sh | bash
    ;;
  2)
    echo "You selected Ubuntu 20.04. Running the Ubuntu 20.04 setup script..."
    curl https://raw.githubusercontent.com/jacknab/scripts/main/install-ubuntu20.sh | bash
    ;;
  3)
    echo "You selected Ubuntu 22.04. Running the Ubuntu 22.04 setup script..."
    curl https://raw.githubusercontent.com/jacknab/scripts/main/install-Ubuntu22.sh | bash
    ;;
  *)
    echo "Invalid selection. Please select 1, 2, or 3."
    exit 1
    ;;
esac
