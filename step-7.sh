#!/bin/bash

echo "[+] Step 7: Setting up rental watchdog..."

# Navigate to app directory
cd ~/mining_rental_app

# Install required Python modules
source venv/bin/activate
pip install requests schedule

# Create the rental_monitor.py script
cat << 'EOF' > rental_monitor.py
import time
import schedule
import requests
from datetime import datetime
import pymysql

def check_rentals():
    conn = pymysql.connect(host='localhost', user='root', password='password', database='rental_service')
    cursor = conn.cursor(pymysql.cursors.DictCursor)
    
    now = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
    cursor.execute("SELECT * FROM rentals WHERE end_time <= %s AND status = 'active'", (now,))
    expired = cursor.fetchall()

    for rental in expired:
        rig_id = rental['rig_id']
        print(f"[!] Ending rental for rig {rig_id}")
        # Reset rig to owner's pool config (this assumes we have it stored)
        cursor.execute("SELECT original_pool_url, original_worker, original_password FROM rigs WHERE id = %s", (rig_id,))
        rig = cursor.fetchone()
        if rig:
            payload = {
                "rig_id": rig_id,
                "pool_url": rig['original_pool_url'],
                "worker_name": rig['original_worker'],
                "password": rig['original_password']
            }
            requests.post("http://localhost/update_pool", json=payload)

        # Update rental status
        cursor.execute("UPDATE rentals SET status = 'expired' WHERE id = %s", (rental['id'],))
        conn.commit()

    cursor.close()
    conn.close()

schedule.every(1).minutes.do(check_rentals)

print("[+] Rental monitor running every 1 minute.")
while True:
    schedule.run_pending()
    time.sleep(1)
EOF

# Make sure monitor script is executable
chmod +x rental_monitor.py

# Add cron job
(crontab -l 2>/dev/null; echo "* * * * * cd ~/mining_rental_app && source venv/bin/activate && python3 rental_monitor.py >> ~/rental_monitor.log 2>&1") | crontab -

echo "[✓] Rental watchdog setup complete and cron job installed."
curl -s https://raw.githubusercontent.com/jacknab/scripts/main/step-8.sh | bash
