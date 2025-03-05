import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'createdevicepage.dart';

class DeviceListPage extends StatefulWidget {
  @override
  _DeviceListPageState createState() => _DeviceListPageState();
}

class _DeviceListPageState extends State<DeviceListPage> {
  final storage = FlutterSecureStorage();
  List devices = [];

  Future<void> fetchDevices() async {
    String? token = await storage.read(key: 'token');

    final response = await http.get(
      Uri.parse('https://ton-api.com/devices'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      setState(() {
        devices = jsonDecode(response.body);
      });
    }
  }

  Future<void> deleteDevice(int id) async {
    String? token = await storage.read(key: 'token');

    await http.delete(
      Uri.parse('https://ton-api.com/devices/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    fetchDevices();
  }

  @override
  void initState() {
    super.initState();
    fetchDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Appareils')),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final device = devices[index];
          return ListTile(
            title: Text(device['name'], style: TextStyle(color: Colors.white)),
            subtitle: Text("Prix: ${device['price']}",
                style: TextStyle(color: Colors.orange)),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => deleteDevice(device['id']),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(Icons.add, color: Colors.black),
        onPressed: () async {
          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateDevicePage()),
          );
          if (result == true) fetchDevices();
        },
      ),
    );
  }
}
