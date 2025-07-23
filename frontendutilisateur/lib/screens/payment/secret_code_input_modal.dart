import 'package:flutter/material.dart';
import '/config/app_theme.dart';

class SecretCodeInputModal extends StatefulWidget {
  final String paymentMethodName;

  const SecretCodeInputModal({super.key, required this.paymentMethodName});

  @override
  State<SecretCodeInputModal> createState() => _SecretCodeInputModalState();
}

class _SecretCodeInputModalState extends State<SecretCodeInputModal> {
  final TextEditingController _secretCodeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _secretCodeController.dispose();
    super.dispose();
  }

  void _submitCode() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(_secretCodeController.text); // Retourne le code secret
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min, // Prend juste la taille nécessaire
            children: [
              Text(
                'Saisissez votre code secret ${widget.paymentMethodName}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
              ),
              const SizedBox(height: 24.0),
              TextFormField(
                controller: _secretCodeController,
                obscureText: true, // Cache le texte pour un code secret
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Code Secret',
                  hintText: 'Entrez votre code secret',
                  prefixIcon: Icon(Icons.lock, color: AppColors.primaryBlue),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre code secret';
                  }
                  if (value.length < 4) { // Exemple: code de 4 chiffres minimum
                    return 'Le code doit contenir au moins 4 chiffres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Annule la saisie
                    },
                    child: const Text('Annuler'),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: _submitCode,
                    child: const Text('Confirmer'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
