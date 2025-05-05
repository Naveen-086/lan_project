from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def home():
    return "Welcome to LAN Monitor Server."

@app.route('/devices', methods=['GET'])
def get_devices():
    dummy_devices = [
        {"ip": "192.168.39.100", "hostname": "PC-1", "status": "Online"},
        {"ip": "192.168.39.101", "hostname": "PC-2", "status": "Offline"}
    ]
    return jsonify(dummy_devices)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
