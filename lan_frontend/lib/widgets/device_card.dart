import 'package:flutter/material.dart';

class DeviceCard extends StatelessWidget {
  final String ip;
  final String mac;
  final String hostname;
  final String status;
  final VoidCallback onShutdown;
  final VoidCallback onWake;
  final VoidCallback onViewLogs;

  const DeviceCard({
    Key? key,
    required this.ip,
    required this.mac,
    required this.hostname,
    required this.status,
    required this.onShutdown,
    required this.onWake,
    required this.onViewLogs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ListTile(
        title: Text(hostname),
        subtitle: Text('IP: $ip\nMAC: $mac\nStatus: $status'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: status == 'Online' ? onShutdown : null,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Shutdown'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: onViewLogs, // When pressed, it navigates to LogsScreen
              style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 3, 255, 95)),
              child: const Text('View Logs'),
            ),
          ],
        ),
      ),
    );
  }
}
