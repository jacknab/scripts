#!/bin/bash

echo "[+] Step 11: Setting up admin dashboard and rental status page..."

cd ~/mining_rental_app/web
mkdir -p templates static

# Install Flask if not already
cd ..
source venv/bin/activate
pip install flask pymysql

# dashboard.py
cat << 'EOF' > web/dashboard.py
from flask import Flask, render_template
import pymysql
import time

app = Flask(__name__)

DB = {
    "host": "localhost",
    "user": "root",
    "password": "",
    "database": "rental_service"
}

@app.route("/")
def index():
    conn = pymysql.connect(**DB)
    cursor = conn.cursor(pymysql.cursors.DictCursor)

    cursor.execute("SELECT * FROM rentals WHERE active=1")
    rentals = cursor.fetchall()

    for r in rentals:
        cursor.execute("SELECT * FROM rigs WHERE id = %s", (r["rig_id"],))
        rig = cursor.fetchone()
        r["rig"] = rig

        cursor.execute("""
            SELECT hashrate, timestamp FROM rental_hashrates
            WHERE rental_id = %s ORDER BY timestamp DESC LIMIT 1
        """, (r["id"],))
        hr = cursor.fetchone()
        r["latest_hashrate"] = hr["hashrate"] if hr else 0
        r["last_updated"] = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(hr["timestamp"])) if hr else "N/A"

    cursor.close()
    conn.close()
    return render_template("dashboard.html", rentals=rentals)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=6000)
EOF

# dashboard.html
cat << 'EOF' > web/templates/dashboard.html
<!DOCTYPE html>
<html>
<head>
  <title>Rental Dashboard</title>
  <style>
    body { font-family: sans-serif; background: #f2f2f2; padding: 20px; }
    table { border-collapse: collapse; width: 100%; background: #fff; }
    th, td { padding: 12px; border: 1px solid #ccc; text-align: left; }
    th { background: #333; color: #fff; }
  </style>
</head>
<body>
  <h2>Active Rentals</h2>
  <table>
    <tr>
      <th>Rental ID</th>
      <th>Renter</th>
      <th>Rig IP</th>
      <th>Worker Masked</th>
      <th>Latest Hashrate (GH/s)</th>
      <th>Last Updated</th>
    </tr>
    {% for r in rentals %}
    <tr>
      <td>{{ r.id }}</td>
      <td>{{ r.renter_username }}</td>
      <td>{{ r.rig.ip_address }}</td>
      <td>{{ r.renter_worker }}</td>
      <td>{{ r.latest_hashrate }}</td>
      <td>{{ r.last_updated }}</td>
    </tr>
    {% endfor %}
  </table>
</body>
</html>
EOF

# Start in screen
screen -dmS dashboard bash -c "cd ~/mining_rental_app/web && source ../venv/bin/activate && python3 dashboard.py"

echo "[✓] Admin dashboard running on port 6000 — open http://your-server-ip:6000"
