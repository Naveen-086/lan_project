import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static String _baseUrl = '';

  static void setBaseUrl(String ip) {
    _baseUrl = 'http://$ip:9360'; 
  }

  // Fetch the devices from the backend
  static Future<List<dynamic>> getDevices() async {
    final response = await http.get(Uri.parse('$_baseUrl/devices'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load devices');
    }
  }

  // Shutdown a PC
  static Future<String> shutdownPC(String ip) async {
    final response = await http.post(
      Uri.parse('http://$ip:9360/shutdown'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({'ip': ip}),
    );
    if (response.statusCode == 200) {
      return 'Shutdown command sent to $ip';
    } else {
      return 'Failed to send shutdown command';
    }
  }

  // Wake a PC
  static Future<String> wakePC(String mac) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/wake'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({'mac': mac}),
    );
    if (response.statusCode == 200) {
      return 'Wake-on-LAN packet sent to $mac';
    } else {
      return 'Failed to send Wake-on-LAN packet';
    }
  }

  // Fetch logs from the backend
  static Future<List<String>> getLogsForIP(String ip) async {
    final response = await http.get(Uri.parse('$_baseUrl/logs'));
    if (response.statusCode == 200) {
      List<String> logs = List<String>.from(json.decode(response.body));
      return logs;
    } else {
      throw Exception('Failed to load logs');
    }
  }
}
