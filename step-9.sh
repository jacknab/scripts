#!/bin/bash

echo "[+] Step 9: Setting up rental cron watcher to end expired rentals and revert rigs..."

cd ~/mining_rental_app
source venv/bin/activate
pip install schedule pymysql

# Create rental_watcher.py
cat << 'EOF' > rental_watcher.py
import pymysql
import time
import schedule
import requests
from datetime import datetime

DB = {
    "host": "localhost",
    "user": "root",
    "password": "",
    "database": "rental_service"
}

def check_rentals():
    now = int(time.time())
    conn = pymysql.connect(**DB)
    cursor = conn.cursor(pymysql.cursors.DictCursor)
    cursor.execute("SELECT * FROM rentals WHERE active = 1 AND end_time <= %s", (now,))
    expired = cursor.fetchall()

    for rental in expired:
        print(f"[!] Ending rental ID {rental['id']} for rig {rental['rig_id']}")
        
        # Revert rig back to owner's original pool
        cursor.execute("SELECT * FROM rigs WHERE id = %s", (rental['rig_id'],))
        rig = cursor.fetchone()
        if rig:
            data = {
                "rig_id": rig['id'],
                "pool_url": rig['original_pool_url'],
                "worker_name": rig['original_worker'],
                "password": rig['original_pass']
            }
            try:
                res = requests.post("http://localhost:5000/update_pool", json=data, timeout=5)
                print(f"Reverted pool for rig {rig['id']}, response: {res.text}")
            except Exception as e:
                print(f"Error reverting rig {rig['id']}: {e}")

        cursor.execute("UPDATE rentals SET active = 0 WHERE id = %s", (rental['id'],))
        conn.commit()

    cursor.close()
    conn.close()

schedule.every(60).seconds.do(check_rentals)

print("[✓] Rental watcher started.")
while True:
    schedule.run_pending()
    time.sleep(1)
EOF

# Start in background using screen
screen -dmS rental_watcher bash -c "cd ~/mining_rental_app && source venv/bin/activate && python3 rental_watcher.py"

echo "[✓] Rental cron watcher active and checking every minute."
