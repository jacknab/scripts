#!/usr/bin/env bash

echo "🧩 Step 4: Add rig_settings table and update rental reset logic"

# Update DB: add rig_settings table
mysql -u root -pstrongpassword -e "
USE mining_rental;
CREATE TABLE IF NOT EXISTS rig_settings (
  rig_id INT PRIMARY KEY,
  pool_url VARCHAR(255),
  worker_name VARCHAR(255),
  password VARCHAR(255)
);
"

# Rewrite check_rentals.py to use rig_settings
cat <<EOF > /root/mining_rental_app/check_rentals.py
import pymysql
import datetime
import requests

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
    cursor.execute("UPDATE rentals SET active=0 WHERE id=%s", (rental_id,))
    conn.commit()

    cursor.execute("SELECT pool_url, worker_name, password FROM rig_settings WHERE rig_id = %s", (rig_id,))
    result = cursor.fetchone()

    if result:
        pool_url, worker_name, password = result
        reset_payload = {
            "rig_id": rig_id,
            "pool_url": pool_url,
            "worker_name": worker_name,
            "password": password
        }
        try:
            res = requests.post("http://127.0.0.1:5000/update_pool", json=reset_payload)
            print("Reset response:", res.text)
        except Exception as e:
            print("Failed to reset rig:", e)
    else:
        print("No original rig settings found for rig", rig_id)

cursor.close()
conn.close()
EOF

echo "✅ Step 4 complete. Rig will now restore to owner's saved pool settings after rental ends."
