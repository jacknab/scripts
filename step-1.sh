#!/usr/bin/env bash

echo "🚀 Step 1: System Prep + Python App Setup"

# Update system
apt update && apt upgrade -y

# Install essentials
apt install -y python3 python3-pip python3-venv git curl unzip

# Set working dir
mkdir -p /root/mining_rental_app
cd /root/mining_rental_app

# Set up Python virtual environment
python3 -m venv venv
source venv/bin/activate

# Install required Python packages
pip install flask pymysql

# Create a minimal Flask app to confirm things work
cat <<EOF > app.py
from flask import Flask
app = Flask(__name__)

@app.route("/")
def home():
    return "Mining Rental App is running."

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
EOF

# Optional: start app in background
nohup python3 app.py &

# Chain to step-2
echo "✅ Step 1 complete. Running step-2..."
curl -s https://raw.githubusercontent.com/jacknab/scripts/main/step-2.sh | bash
