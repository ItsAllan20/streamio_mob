import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'devicelistpage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final storage = FlutterSecureStorage();

  Future<void> login() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DeviceListPage()),
    );
    // final response = await http.post(
    //   Uri.parse('https://ton-api.com/login'),
    //   body: {
    //     'username': usernameController.text,
    //     'password': passwordController.text,
    //   },
    // );
    //
    // if (response.statusCode == 200) {
    //   final data = jsonDecode(response.body);
    //   await storage.write(key: 'token', value: data['token']);
    //
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => DeviceListPage()),
    //   );
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Connexion échouée')),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Identifiant'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: login,
                child: Text('Se connecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
