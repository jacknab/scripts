#!/bin/bash

# Step 6: Install dependencies and setup rig controller for ASIC pool updates

# Update packages
apt update && apt install -y python3 python3-pip

# Create directory for the controller script
mkdir -p ~/mining_rental_app/controllers
cd ~/mining_rental_app/controllers

# Create rig_controller.py
cat <<EOF > rig_controller.py
import socket
import json
import sys

def send_cgminer_cmd(host, port, cmd):
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.settimeout(5)
        s.connect((host, port))
        payload = json.dumps({"command": cmd})
        s.send(payload.encode())
        response = s.recv(4096)
        s.close()
        return json.loads(response.decode('utf-8', errors='ignore'))
    except Exception as e:
        return {"error": str(e)}

def set_pool(host, url, user, password):
    config_cmd = {
        "command": "config",
        "parameter": {
            "pools": [
                {
                    "url": url,
                    "user": user,
                    "pass": password
                }
            ]
        }
    }
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.settimeout(5)
        s.connect((host, 4028))
        s.send(json.dumps(config_cmd).encode())
        resp = s.recv(4096)
        s.close()
        print("Response:", resp.decode())
    except Exception as e:
        print("Failed to set pool:", e)

if __name__ == "__main__":
    if len(sys.argv) != 5:
        print("Usage: python3 rig_controller.py <host> <pool_url> <username> <password>")
        sys.exit(1)

    _, host, pool_url, username, password = sys.argv
    set_pool(host, pool_url, username, password)
EOF

# Install any required pip modules (currently none specifically needed)
pip3 install --upgrade pip

# Done
echo "Step 6 complete: rig_controller.py created and ready to be used."
echo "Usage: python3 ~/mining_rental_app/controllers/rig_controller.py <rig_ip> <pool_url> <username> <password>"
