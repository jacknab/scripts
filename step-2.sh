#!/usr/bin/env bash

echo "🔧 Step 2: MySQL + Systemd + Nginx Setup"

# Install MySQL Server
apt install -y mysql-server

# Start MySQL service
systemctl enable mysql
systemctl start mysql

# Secure MySQL: Set root password & remove test DB and anonymous users
MYSQL_ROOT_PASSWORD="r7)Kmof8tc8)EKm3"

mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}';
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
EOF

# Create the database and user (adjust password!)
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" <<EOF
CREATE DATABASE IF NOT EXISTS mining_rental;
CREATE USER IF NOT EXISTS 'miner_admin'@'localhost' IDENTIFIED BY 'strongpassword';
GRANT ALL PRIVILEGES ON mining_rental.* TO 'miner_admin'@'localhost';
FLUSH PRIVILEGES;
EOF

# Create rentals table
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" mining_rental <<EOF
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

# Create systemd service
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

systemctl daemon-reexec
systemctl daemon-reload
systemctl enable miningrental
systemctl start miningrental

# Nginx setup
apt install -y nginx

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

ln -sf /etc/nginx/sites-available/miningrental /etc/nginx/sites-enabled/miningrental
rm -f /etc/nginx/sites-enabled/default
systemctl restart nginx

echo "✅ Step 2 complete. App is now live on your server IP via port 80."
