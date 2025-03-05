import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CreateDevicePage extends StatefulWidget {
  @override
  _CreateDevicePageState createState() => _CreateDevicePageState();
}

class _CreateDevicePageState extends State<CreateDevicePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final storage = FlutterSecureStorage();

  Future<void> createDevice() async {
    String? token = await storage.read(key: 'token');

    final response = await http.post(
      Uri.parse('https://ton-api.com/devices'),
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'name': nameController.text,
        'price': priceController.text,
        'description': descriptionController.text,
      },
    );

    if (response.statusCode == 201) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la création')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Créer un appareil')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nom')),
            SizedBox(height: 10),
            TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Prix')),
            SizedBox(height: 10),
            TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: createDevice, child: Text('Ajouter')),
          ],
        ),
      ),
    );
  }
}
