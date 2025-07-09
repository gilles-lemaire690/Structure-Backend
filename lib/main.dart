import 'package:flutter/material.dart';
import 'package:structure_front/screens/auth/login_screen.dart'; // Importez votre écran de connexion

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Structure Front',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey, // Une couleur sobre pour la primarySwatch
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(), // Démarrez l'application avec l'écran de connexion
    );
  }
}