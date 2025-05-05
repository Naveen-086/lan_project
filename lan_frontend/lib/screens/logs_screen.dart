import 'package:flutter/material.dart';
import '../services/api_service.dart';

class LogsScreen extends StatelessWidget {
  final String ip;
  const LogsScreen({super.key, required this.ip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Logs for $ip')),
      body: FutureBuilder<List<String>>(
        future: ApiService.getLogsForIP(ip),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Failed to load logs.'));
          }

          final logs = snapshot.data!;
          return ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(logs[index]),
            ),
          );
        },
      ),
    );
  }
}
