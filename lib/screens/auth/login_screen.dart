import 'package:flutter/material.dart';
import 'package:structure_front/l10n/app_localizations.dart';
import 'package:structure_front/screens/admin/super_admin_dashboard_screen.dart';
import 'package:structure_front/screens/admin/admin_dashboard_screen.dart';


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
    } else if (email.startsWith('admin') && password == 'password') {
      print('Connexion Admin réussie !');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AdminDashboardScreen(adminEmail: email),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.incorrectEmailPassword)),
      );
      print('Échec de la connexion.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!; // Access translations

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.business,
                size: 80,
                color: Colors.blueGrey,
              ),
              const SizedBox(height: 20),
              Text(
                appLocalizations.loginScreenTitle,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 40),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: appLocalizations.emailLabel,
                  hintText: 'entrez votre adresse e-mail',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: const Icon(Icons.email, color: Colors.blueGrey),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: appLocalizations.passwordLabel,
                  hintText: 'entrez votre mot de passe',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: const Icon(Icons.lock, color: Colors.blueGrey),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.blueGrey,
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

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    print('Mot de passe oublié pressed');
                  },
                  child: Text(
                    appLocalizations.forgotPassword,
                    style: const TextStyle(color: Colors.blueGrey),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[700],
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    appLocalizations.signIn,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
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