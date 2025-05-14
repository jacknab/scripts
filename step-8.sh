#!/bin/bash

echo "[+] Step 8: Setting up ASICS API integration for automatic pool switching..."

cd ~/mining_rental_app
source venv/bin/activate
pip install flask requests netaddr

# Create asic_pool_switcher.py
cat << 'EOF' > asic_pool_switcher.py
import requests
import json
import time
from flask import Flask, request, jsonify

app = Flask(__name__)

def update_asic_pool(ip, pool_url, worker, password):
    try:
        url = f"http://{ip}/cgi-bin/set_miner_conf.cgi"
        config = {
            "pools": [{
                "url": pool_url,
                "user": worker,
                "pass": password
            }]
        }
        headers = {'Content-Type': 'application/json'}
        response = requests.post(url, data=json.dumps(config), headers=headers, timeout=5)
        return response.status_code == 200
    except Exception as e:
        print(f"Error updating {ip}: {e}")
        return False

@app.route('/asic/update_pool', methods=['POST'])
def update_pool():
    data = request.get_json()
    ip = data.get('ip')
    pool_url = data.get('pool_url')
    worker = data.get('worker')
    password = data.get('password', 'x')

    if not all([ip, pool_url, worker]):
        return jsonify({"error": "Missing parameters"}), 400

    success = update_asic_pool(ip, pool_url, worker, password)
    return jsonify({"success": success}), 200 if success else 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5050)
EOF

# Add service start to systemd or screen if preferred
# Example: background the script in screen
screen -dmS asic_pool_switcher bash -c "cd ~/mining_rental_app && source venv/bin/activate && python3 asic_pool_switcher.py"

echo "[✓] ASIC API integration running at http://localhost:5050/asic/update_pool"
curl -s https://raw.githubusercontent.com/jacknab/scripts/main/step-9.sh | bash
