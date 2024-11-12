#!/bin/bash

# Check the operating system
OS=$(lsb_release -d | awk -F"\t" '{print $2}' | awk '{print $1}')

# Function to install on Debian 11
install_debian11() {
    echo "Detected Debian 11. Running Debian 11 specific installation script..."
    # Replace this with the actual Debian 11 script command or wget to a file
    curl -sL https://raw.githubusercontent.com/jacknab/scripts/main/install-Debian11.sh | bash
}

# Function to install on Ubuntu 22.04
install_ubuntu2204() {
    echo "Detected Ubuntu 22.04. Running Ubuntu 22.04 specific installation script..."
    # Replace this with the actual Ubuntu 22.04 script command or wget to a file
    curl -sL https://raw.githubusercontent.com/jacknab/scripts/main/php-Ubuntu22.sh | bash
}

# Check the OS version and execute the corresponding function
if [[ "$OS" == "Ubuntu" ]]; then
    VERSION=$(lsb_release -r | awk '{print $2}')
    if [[ "$VERSION" == "22.04" ]]; then
        install_ubuntu2204
    else
        echo "This script is designed for Ubuntu 22.04. Exiting."
        exit 1
    fi
elif [[ "$OS" == "Debian" ]]; then
    VERSION=$(lsb_release -r | awk '{print $2}')
    if [[ "$VERSION" == "11" ]]; then
        install_debian11
    else
        echo "This script is designed for Debian 11. Exiting."
        exit 1
    fi
else
    echo "Unsupported operating system. This script supports only Ubuntu 22.04 or Debian 11."
    exit 1
fi
