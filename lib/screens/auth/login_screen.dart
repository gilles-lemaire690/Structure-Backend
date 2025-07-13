import 'package:flutter/material.dart';
import 'package:structure_front/screens/admin/super_admin_dashboard_screen.dart';
import 'package:structure_front/screens/admin/admin_dashboard_screen.dart';
import 'package:structure_front/themes/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true; // Pour masquer/afficher le mot de passe

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    print('Tentative de connexion...');
    print('Email: $email');
    print('Password: $password');

    // Simuler la connexion en fonction des identifiants
    if (email == 'superadmin@example.com' && password == 'password') {
      print('Connexion Super Admin réussie !');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const SuperAdminDashboardScreen(),
        ),
      );
    } else if (email.startsWith('admin') && password == 'password') { // Exemple: admin1@structureA.com, admin2@structureB.com
      print('Connexion Admin réussie !');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AdminDashboardScreen(adminEmail: email), // Passe l'email à l'AdminDashboard
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('E-mail ou mot de passe incorrect.')),
      );
      print('Échec de la connexion.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: SingleChildScrollView( // Permet le défilement si le clavier apparaît
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // --- Logo ou Icône (Optionnel) ---
              // Remplacez 'assets/logo.png' par le chemin de votre logo si vous en avez un.
              // Sinon, vous pouvez utiliser une icône temporaire ou la supprimer.
              const Icon(
                Icons.business, // Icône temporaire, remplacez par votre logo
                size: 80,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 20),
              const Text(
                'Connexion Administrateur',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 40),

              // --- Champ E-mail ---
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  hintText: 'entrez votre adresse e-mail',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: const Icon(Icons.email, color: AppTheme.primaryColor),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // --- Champ Mot de passe ---
              TextFormField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  hintText: 'entrez votre mot de passe',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: const Icon(Icons.lock, color: AppTheme.primaryColor),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: AppTheme.primaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 10),

              // --- Bouton Mot de passe oublié ? ---
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Logique pour le mot de passe oublié
                    print('Mot de passe oublié pressed');
                  },
                  child: const Text(
                    'Mot de passe oublié ?',
                    style: TextStyle(color: AppTheme.primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // --- Bouton Se connecter ---
              SizedBox(
                width: double.infinity, // Prend toute la largeur disponible
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor, // Couleur de bouton plus foncée et sobre
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Se connecter',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}