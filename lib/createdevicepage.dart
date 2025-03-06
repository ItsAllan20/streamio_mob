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
  final TextEditingController amountController = TextEditingController();
  final storage = FlutterSecureStorage();

  bool isMicroChecked = false;
  bool isCameraChecked = false;
  bool isCasqueChecked = false;
  Future<void> createDevice() async {
    if (isMicroChecked == false &&
        isCameraChecked == false &&
        isCasqueChecked == false) {
      return;
    }

    final response = await http.post(
      Uri.parse('http://localhost:3000/api/devices'),
      body: jsonEncode({
        'name': nameController.text,
        'price': double.tryParse(priceController.text),
        'amount': double.tryParse(amountController.text),
        'type':
            isCameraChecked
                ? "camera"
                : isMicroChecked
                ? "micro"
                : "casque",
      }),
    );

    if (response.statusCode == 201) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur lors de la création')));
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
              decoration: InputDecoration(labelText: 'Nom'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Prix'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Quantité'),
            ),
            CheckboxListTile(
              title: Text('Camera'),
              value: isCameraChecked,
              onChanged: (bool? value) {
                setState(() {
                  isCameraChecked = value ?? false;
                  isMicroChecked = value == true ? false : isMicroChecked;
                  isCasqueChecked = value == true ? false : isCasqueChecked;
                });
              },
            ),
            // Deuxième Checkbox pour "Studio"
            CheckboxListTile(
              title: Text('Micro'),
              value: isMicroChecked,
              onChanged: (bool? value) {
                setState(() {
                  isMicroChecked = value ?? false;
                  isCasqueChecked = value == true ? false : isCasqueChecked;
                  isCameraChecked = value == true ? false : isCameraChecked;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Casque'),
              value: isCasqueChecked,
              onChanged: (bool? value) {
                setState(() {
                  isCasqueChecked = value ?? false;
                  isMicroChecked = value == true ? false : isMicroChecked;
                  isCameraChecked = value == true ? false : isCameraChecked;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: createDevice, child: Text('Ajouter')),
          ],
        ),
      ),
    );
  }
}
