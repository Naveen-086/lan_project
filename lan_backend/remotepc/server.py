from flask import Flask, jsonify, request
import subprocess
import socket
import json
import os
import threading
import time
app = Flask(__name__)
@app.route('/')
def home():
    return "Welcome to LAN Monitor Server."
# 🔵 Shutdown a remote PC
@app.route('/shutdown', methods=['POST'])
def shutdown_pc():
    ip = request.json.get('ip')
    try:
        subprocess.call(["shutdown", "/m", f"\\\\{ip}", "/s", "/f", "/t", "0"])
        log_action(f"Shutdown command sent to {ip}")
        return jsonify({"message": "Shutdown command sent"})
    except Exception as e:
        return jsonify({"error": str(e)}), 500



if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=9360)