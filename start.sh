#!/usr/bin/env bash
#########################################################
# Created by jacknab for php-mpos and nomp pool...
# This script allows you to choose the OS to run specific setup scripts
# like this:
# curl https://raw.githubusercontent.com/jacknab/scripts/main/start.sh | bash
#
#########################################################

# Sleep for a second to make sure the terminal gets time to load
sleep 1

echo "Please select your operating system:"
echo "[1] Debian 11"
echo "[2] Ubuntu 20.04"
echo "[3] Ubuntu 22.04"

# Read user input
read -p "Enter your choice [1, 2, or 3]: " os_choice

# Validate input and execute corresponding script
case $os_choice in
    1)
        echo "You selected Debian 11"
        curl https://raw.githubusercontent.com/jacknab/scripts/main/install-debian11.sh | bash
        ;;
    2)
        echo "You selected Ubuntu 20.04"
        curl https://raw.githubusercontent.com/jacknab/scripts/main/install-ubuntu20.sh | bash
        ;;
    3)
        echo "You selected Ubuntu 22.04"
        curl https://raw.githubusercontent.com/jacknab/scripts/main/install-ubuntu22.sh | bash
        ;;
    *)
        echo "Invalid selection. Please select 1, 2, or 3."
        exit 1
        ;;
esac
