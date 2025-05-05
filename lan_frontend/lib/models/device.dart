class Device {
  final String hostname;
  final String ip;
  final String mac;
  final String status;

  Device({
    required this.hostname,
    required this.ip,
    required this.mac,
    required this.status,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      hostname: json['hostname'],
      ip: json['ip'],
      mac: json['mac'],
      status: json['status'],
    );
  }
}
