#!/bin/bash

echo "🔁 Step 3: Setup cron job to monitor rental expirations"

# Create Python script to check rentals
cat <<EOF > /root/mining_rental_app/check_rentals.py
import pymysql
import datetime
import requests

# DB connection
conn = pymysql.connect(
    host='localhost',
    user='miner_admin',
    password='strongpassword',
    database='mining_rental'
)
cursor = conn.cursor()

now = datetime.datetime.utcnow()
cursor.execute("SELECT id, rig_id FROM rentals WHERE active=1 AND end_time <= %s", (now,))
expired = cursor.fetchall()

for rental_id, rig_id in expired:
    print(f"Ending rental {rental_id} for rig {rig_id}")
    # Update DB to mark rental inactive
    cursor.execute("UPDATE rentals SET active=0 WHERE id=%s", (rental_id,))
    conn.commit()

    # Reset rig to owner's original pool (you can replace this with actual saved values later)
    reset_payload = {
        "rig_id": rig_id,
        "pool_url": "stratum+tcp://original.pool.url:3333",
        "worker_name": "originalWorker",
        "password": "x"
    }

    try:
        res = requests.post("http://127.0.0.1:5000/update_pool", json=reset_payload)
        print("Reset response:", res.text)
    except Exception as e:
        print("Failed to reset rig:", e)

cursor.close()
conn.close()
EOF

# Make sure the venv python runs this script
echo "* * * * * root /root/mining_rental_app/venv/bin/python /root/mining_rental_app/check_rentals.py >> /var/log/check_rentals.log 2>&1" > /etc/cron.d/rental-check

chmod 644 /etc/cron.d/rental-check
touch /var/log/check_rentals.log

echo "✅ Step 3 complete. Cron will check rentals every minute."
# Optional chain to step 3
curl -s https://raw.githubusercontent.com/jacknab/scripts/main/step-4.sh | bash
