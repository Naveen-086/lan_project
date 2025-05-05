import 'package:flutter/material.dart';
import 'home_screen.dart';

class IpAddressInputScreen extends StatefulWidget {
  const IpAddressInputScreen({super.key});

  @override
  State<IpAddressInputScreen> createState() => _IpAddressInputScreenState();
}

class _IpAddressInputScreenState extends State<IpAddressInputScreen> {
  final _ipController = TextEditingController();
  String errorMessage = '';

  void _connect() {
    final ip = _ipController.text.trim();

    if (ip.isEmpty || !RegExp(r'^\d{1,3}(\.\d{1,3}){3}$').hasMatch(ip)) {
      setState(() {
        errorMessage = 'Invalid IP address';
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(ipAddress: ip)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter IP Address')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _ipController,
              decoration: const InputDecoration(labelText: 'IP Address'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _connect,
              child: const Text('Connect'),
            ),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(errorMessage, style: const TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}
