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
  List devices = [
    {"id": "test", "name": "caca", "price": "30000"},
  ];

  Future<void> fetchDevices() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/devices'),
    );

    if (response.statusCode == 200) {
      setState(() {
        print(response.body);
        devices = jsonDecode(response.body)['data'];
      });
    }
  }

  Future<void> deleteDevice(String id) async {
    setState(() {
      devices.removeWhere((d) => d["id"] == id);
    });

    final response = await http.delete(
      Uri.parse('http://localhost:3000/api/devices'),
      body: jsonEncode({'deviceId': id}),
    );
    jsonDecode(response.body);
    print(response.body);
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
            subtitle: Text(
              "Prix: ${device['price']}",
              style: TextStyle(color: Colors.orange),
            ),
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
          // setState(() {
          //   devices.add({
          //     "id": devices.length.toString(),
          //     "name": "caca",
          //     "price": "30000",
          //   });
          // });
          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateDevicePage()),
          );
          fetchDevices();
          // if (result == true) fetchDevices();
        },
      ),
    );
  }
}
