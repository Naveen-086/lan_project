import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/device_card.dart';
import 'logs_screen.dart';

class HomeScreen extends StatefulWidget {
  final String ipAddress;
  const HomeScreen({super.key, required this.ipAddress});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _devices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    ApiService.setBaseUrl(widget.ipAddress);
    _fetchDevices();
  }

  Future<void> _fetchDevices() async {
    final devices = await ApiService.getDevices();
    setState(() {
      _devices = devices;
      _isLoading = false;
    });
  }

  void _shutdown(String ip) async {
    final message = await ApiService.shutdownPC(ip);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _wake(String mac) async {
    final message = await ApiService.wakePC(mac);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    _fetchDevices(); // Refresh
  }

  void _viewLogs(String ip) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LogsScreen(ip: ip)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connected Devices')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (context, index) {
                final device = _devices[index];
                return DeviceCard(
                  ip: device['ip'],
                  mac: device['mac'],
                  hostname: device['hostname'],
                  status: device['status'],
                  onShutdown: () => _shutdown(device['ip']),
                  onWake: () => _wake(device['mac']),
                  onViewLogs: () => _viewLogs(device['ip']), // This will open the LogsScreen
                );
              },
            ),
    );
  }
}
