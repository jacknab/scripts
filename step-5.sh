#!/bin/bash

echo "[*] Installing required Python packages for proxy logic..."
source ~/mining_rental_app/venv/bin/activate
pip install twisted

echo "[*] Setting up updated stratum proxy logic with worker masking..."

cat > ~/mining_rental_app/proxy.py << 'EOF'
import re
import socket
import threading
import json
import pymysql

LISTEN_HOST = '0.0.0.0'
LISTEN_PORT = 5000

def get_rig_mapping(worker_login):
    try:
        username, rig_id = worker_login.split('.')
        conn = pymysql.connect(host='localhost', user='root', password='', database='rental_service')
        with conn.cursor() as cursor:
            cursor.execute("SELECT pool_url, worker_name, password FROM rig_rentals WHERE rig_id=%s AND active=1", (rig_id,))
            result = cursor.fetchone()
            if result:
                pool_url, worker_name, password = result
                return pool_url, worker_name, password
        conn.close()
    except Exception as e:
        print(f"[!] DB error or malformed worker name: {e}")
    return None, None, None

def handle_connection(client_socket):
    try:
        first_packet = client_socket.recv(4096).decode()
        print("[>] First packet from miner:", first_packet.strip())

        match = re.search(r'"login"\s*:\s*"([^"]+)"', first_packet)
        if not match:
            print("[!] No worker login found in packet")
            client_socket.close()
            return

        original_worker = match.group(1)
        target_pool, new_worker, new_password = get_rig_mapping(original_worker)
        if not target_pool:
            print("[!] No rental found for this rig")
            client_socket.close()
            return

        host, port = target_pool.replace("stratum+tcp://", "").split(':')
        backend = socket.create_connection((host, int(port)))

        # Replace login line
        modified_packet = first_packet.replace(original_worker, new_worker)
        if "password" in modified_packet and new_password:
            modified_packet = re.sub(r'"password"\s*:\s*"[^"]+"', f'"password":"{new_password}"', modified_packet)

        backend.send(modified_packet.encode())

        def forward(source, dest):
            try:
                while True:
                    data = source.recv(4096)
                    if not data:
                        break
                    dest.send(data)
            finally:
                source.close()
                dest.close()

        threading.Thread(target=forward, args=(client_socket, backend)).start()
        threading.Thread(target=forward, args=(backend, client_socket)).start()

    except Exception as e:
        print(f"[!] Proxy error: {e}")
        client_socket.close()

def start_proxy():
    print(f"[*] Proxy listening on {LISTEN_HOST}:{LISTEN_PORT}")
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.bind((LISTEN_HOST, LISTEN_PORT))
    server.listen(20)
    while True:
        client, _ = server.accept()
        threading.Thread(target=handle_connection, args=(client,)).start()

if __name__ == "__main__":
    start_proxy()
EOF

echo "[*] Restarting proxy..."
pkill -f proxy.py
nohup python3 ~/mining_rental_app/proxy.py > ~/proxy.log 2>&1 &

echo "[✔] Proxy now supports rig masking and rental forwarding!"
