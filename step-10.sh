#!/bin/bash

echo "[+] Step 10: Setting up hashrate monitoring for active rentals..."

cd ~/mining_rental_app
source venv/bin/activate
pip install requests schedule pymysql

# Create monitor_hashrate.py
cat << 'EOF' > monitor_hashrate.py
import pymysql
import schedule
import time
import json
import requests
from datetime import datetime

DB = {
    "host": "localhost",
    "user": "root",
    "password": "",
    "database": "rental_service"
}

def get_hashrate_from_rig(ip):
    try:
        res = requests.get(f"http://{ip}/cgi-bin/minerStatus.cgi", timeout=5)
        data = res.json()
        return data.get('summary', [{}])[0].get('GHASH av', 0)
    except Exception as e:
        print(f"Error fetching hashrate from {ip}: {e}")
        return 0

def log_hashrates():
    conn = pymysql.connect(**DB)
    cursor = conn.cursor(pymysql.cursors.DictCursor)

    cursor.execute("SELECT * FROM rentals WHERE active = 1")
    active_rentals = cursor.fetchall()

    for rental in active_rentals:
        cursor.execute("SELECT * FROM rigs WHERE id = %s", (rental['rig_id'],))
        rig = cursor.fetchone()
        if rig:
            hr = get_hashrate_from_rig(rig['ip_address'])
            ts = int(time.time())
            print(f"Rig {rig['id']} - Hashrate: {hr} GH/s")
            cursor.execute(
                "INSERT INTO rental_hashrates (rental_id, rig_id, timestamp, hashrate) VALUES (%s, %s, %s, %s)",
                (rental['id'], rig['id'], ts, hr)
            )
            conn.commit()

    cursor.close()
    conn.close()

schedule.every(5).minutes.do(log_hashrates)

print("[✓] Hashrate monitor started.")
while True:
    schedule.run_pending()
    time.sleep(1)
EOF

# Create hashrate table if not exists
mysql -u root -e "
CREATE DATABASE IF NOT EXISTS rental_service;
USE rental_service;
CREATE TABLE IF NOT EXISTS rental_hashrates (
    id INT AUTO_INCREMENT PRIMARY KEY,
    rental_id INT NOT NULL,
    rig_id INT NOT NULL,
    timestamp INT NOT NULL,
    hashrate FLOAT NOT NULL
);
"

# Start in screen
screen -dmS hashrate_monitor bash -c "cd ~/mining_rental_app && source venv/bin/activate && python3 monitor_hashrate.py"

echo "[✓] Hashrate monitor is now logging every 5 minutes."
curl -s https://raw.githubusercontent.com/jacknab/scripts/main/step-11.sh | bash
