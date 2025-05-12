#!/usr/bin/env bash

echo "🔧 Step 2: MySQL + Systemd + Nginx Setup"

# Install MySQL Server
apt install -y mysql-server

# Secure MySQL (optional: automate if needed)
mysql_secure_installation

# Create the database and user (adjust as needed)
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS mining_rental;
CREATE USER IF NOT EXISTS 'miner_admin'@'localhost' IDENTIFIED BY 'strongpassword';
GRANT ALL PRIVILEGES ON mining_rental.* TO 'miner_admin'@'localhost';
FLUSH PRIVILEGES;
EOF

# Create a sample table for rentals
mysql -u root mining_rental <<EOF
CREATE TABLE IF NOT EXISTS rentals (
  id INT AUTO_INCREMENT PRIMARY KEY,
  rig_id INT,
  renter_wallet VARCHAR(64),
  rental_cost DECIMAL(16,8),
  start_time DATETIME,
  end_time DATETIME,
  active BOOLEAN DEFAULT TRUE
);
EOF

# Create a systemd service to run the Flask app
cat <<EOF > /etc/systemd/system/miningrental.service
[Unit]
Description=Mining Rental Flask App
After=network.target

[Service]
User=root
WorkingDirectory=/root/mining_rental_app
Environment="PATH=/root/mining_rental_app/venv/bin"
ExecStart=/root/mining_rental_app/venv/bin/python /root/mining_rental_app/app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Enable + start the service
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable miningrental
systemctl start miningrental

# Install Nginx if not already
apt install -y nginx

# Basic Nginx config for Flask reverse proxy
cat <<EOF > /etc/nginx/sites-available/miningrental
server {
    listen 80;
    server_name 207.148.7.151;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF

# Enable the site
ln -sf /etc/nginx/sites-available/miningrental /etc/nginx/sites-enabled/miningrental
rm -f /etc/nginx/sites-enabled/default
systemctl restart nginx

echo "✅ Step 2 complete. App is now live on your server IP via port 80."

# Optional chain to step 3
# curl -s https://raw.githubusercontent.com/jacknab/scripts/main/step-3.sh | bash
