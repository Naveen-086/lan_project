from flask import Flask, jsonify, request
import subprocess
import socket
import json
import os
import threading
import time

app = Flask(__name__)

LOG_FILE = 'log.txt'
devices = []

# 🔵 Get the subnet dynamically based on the current device IP
def get_subnet():
    hostname = socket.gethostname()
    local_ip = socket.gethostbyname(hostname)
    subnet_parts = local_ip.split('.')  # Example: ['192', '168', '1', '45']
    subnet = '.'.join(subnet_parts[:3]) + '.'
    return subnet

# 🔵 Get the MAC address using ARP table
def get_mac_address(ip):
    try:
        output = subprocess.check_output(["arp", "-a", ip], text=True)
        lines = output.splitlines()
        for line in lines:
            if ip in line:
                return line.split()[1]  # MAC address is usually second column
        return "Unknown"
    except Exception:
        return "Unknown"

# 🔵 Ping a device to check if it's online or offline
def ping_device(ip):
    try:
        subprocess.check_output(["ping", "-n", "1", "-w", "1000", ip], stderr=subprocess.DEVNULL)
        return "Online"
    except subprocess.CalledProcessError:
        return "Offline"

# 🔵 Discover all devices in the network
import concurrent.futures

def discover_devices():
    found_devices = []
    subnet = get_subnet()

    def ping_and_collect(i):
        ip = subnet + str(i)
        try:
            subprocess.check_output(["ping", "-n", "1", "-w", "500", ip], stderr=subprocess.DEVNULL)
            try:
                hostname = socket.gethostbyaddr(ip)[0]
            except socket.herror:
                hostname = "Unknown"
            return {
                "ip": ip,
                "mac": get_mac_address(ip),
                "hostname": hostname,
                "status": "Online"
            }
        except subprocess.CalledProcessError:
            return None

    with concurrent.futures.ThreadPoolExecutor(max_workers=100) as executor:
        results = list(executor.map(ping_and_collect, range(1, 255)))

    for device in results:
        if device:
            found_devices.append(device)

    return found_devices


# 🔵 Background scanning thread
def background_scan():
    global devices
    while True:
        devices = discover_devices()
        time.sleep(30)  # Scan every 30 seconds

# 🔵 Flask route to get devices

@app.route('/')
def home():
    return "Welcome to LAN Monitor Server."

@app.route('/devices', methods=['GET'])
def get_devices():
    return jsonify(devices)

# 🔵 Shutdown a remote PC
@app.route('/shutdown', methods=['POST'])
def shutdown_pc():
    ip = request.json.get('ip')
    try:
        subprocess.call(["shutdown", "/m", f"\\\\{ip}", "/s", "/t", "0"])
        log_action(f"Shutdown command sent to {ip}")
        return jsonify({"message": "Shutdown command sent"})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# 🔵 Wake a PC using Wake-on-LAN
@app.route('/wake', methods=['POST'])
def wake_pc():
    mac = request.json.get('mac')
    try:
        subprocess.call(["wakeonlan", mac])
        log_action(f"Wake-on-LAN packet sent to {mac}")
        return jsonify({"message": "Wake-on-LAN packet sent"})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# 🔵 Get server logs
@app.route('/logs', methods=['GET'])
def get_logs():
    if not os.path.exists(LOG_FILE):
        return jsonify([])
    with open(LOG_FILE, 'r') as f:
        lines = f.readlines()
    return jsonify(lines)

# 🔵 Logging actions
def log_action(action):
    with open(LOG_FILE, 'a') as f:
        f.write(f"{action}\n")

# 🔵 Start background scanner thread before running Flask app
if __name__ == '__main__':
    threading.Thread(target=background_scan, daemon=True).start()
    app.run(debug=True, host='0.0.0.0', port=9360)
