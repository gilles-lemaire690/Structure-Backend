
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '/config/app_theme.dart';
import '/domain/entities/service_entity.dart';
import '/core/utils/pdf_generator.dart'; // Importez notre utilitaire PDF
import 'package:intl/intl.dart'; // Pour le formatage de la date et de l'heure
import '/screens/payment/secret_code_input_modal.dart'; // Importez la modale

class PaymentFormScreen extends ConsumerStatefulWidget {
  final ServiceEntity selectedService;

  const PaymentFormScreen({super.key, required this.selectedService});

  @override
  ConsumerState<PaymentFormScreen> createState() => _PaymentFormScreenState();
}

class _PaymentFormScreenState extends ConsumerState<PaymentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  String? _selectedPaymentMethod;
  String? _secretCode; // Pour stocker le code secret
  bool _isProcessingPayment = false;

  // Map des méthodes de paiement avec leurs chemins d'image
  final Map<String, String> _paymentMethods = {
    'MTN Money': 'assets/mtn_money.png', // Chemin corrigé
    'Orange Money': 'assets/orange.jfif', // Chemin corrigé
    'CAM-POST': 'assets/campost.jfif', // Chemin corrigé
  };

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  // Nouvelle fonction pour gérer la sélection de la méthode de paiement et ouvrir la modale
  void _onPaymentMethodSelected(String? method) async {
    if (method != null) {
      setState(() {
        _selectedPaymentMethod = method;
      });

      // Ouvrir la modale pour le code secret
      final enteredCode = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return SecretCodeInputModal(paymentMethodName: method);
        },
      );

      if (enteredCode != null && enteredCode.isNotEmpty) {
        setState(() {
          _secretCode = enteredCode;
        });
        _showMessage(context, 'Code secret enregistré pour $method.');
        // Le processus de paiement réel sera déclenché par le bouton "Payer"
      } else {
        setState(() {
          _selectedPaymentMethod = null; // Désélectionner si le code n'est pas entré
          _secretCode = null;
        });
        _showMessage(context, 'Saisie du code secret annulée ou vide.');
      }
    }
  }

  Future<void> _processPayment() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedPaymentMethod == null) {
        _showMessage(context, 'Veuillez sélectionner une méthode de paiement.');
        return;
      }
      if (_secretCode == null || _secretCode!.isEmpty) {
        _showMessage(context, 'Veuillez d\'abord saisir votre code secret pour la méthode sélectionnée.');
        return;
      }

      setState(() {
        _isProcessingPayment = true;
      });

      // Simuler un délai de traitement de paiement
      await Future.delayed(const Duration(seconds: 2));

      // Ici, vous intégreriez la logique réelle de paiement
      // Vous enverriez _selectedPaymentMethod et _secretCode à votre API de paiement
      print('Simulating payment with method: $_selectedPaymentMethod and code: $_secretCode');
      bool paymentSuccess = true; // Simuler un succès

      setState(() {
        _isProcessingPayment = false;
      });

      if (paymentSuccess) {
        _showMessage(context, 'Paiement réussi !');
        // Générer et télécharger le reçu
        _generateAndDownloadReceipt();
      } else {
        _showMessage(context, 'Échec du paiement. Veuillez réessayer.');
      }
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _generateAndDownloadReceipt() async {
    final Map<String, dynamic> paymentDetails = {
      'serviceName': widget.selectedService.name,
      'serviceDescription': widget.selectedService.description,
      'price': '${widget.selectedService.price.toStringAsFixed(0)} ${widget.selectedService.currency}',
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'phoneNumber': _phoneNumberController.text,
      'paymentMethod': _selectedPaymentMethod,
      'transactionDate': DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
      'transactionId': 'TXN-${DateTime.now().millisecondsSinceEpoch}', // ID de transaction simulé
    };

    try {
      final String? filePath = await PdfGenerator.generateAndSaveReceiptPdf(paymentDetails);
      if (filePath != null) {
        _showReceiptDownloadSuccess(context, filePath);
      } else {
        _showMessage(context, 'Échec de la génération du reçu.');
      }
    } catch (e) {
      _showMessage(context, 'Erreur lors de la génération du reçu: $e');
    }
  }

  void _showReceiptDownloadSuccess(BuildContext context, String filePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reçu Téléchargé'),
          content: Text('Le reçu a été téléchargé avec succès dans: \n$filePath'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/structures'); // Retour à la liste des structures
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulaire de Paiement'),
        leading: IconButton( // Ajout de la flèche de retour
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop(); // Revient à la page précédente dans la pile de navigation
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                margin: const EdgeInsets.only(bottom: 24.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Service sélectionné:',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkGrey,
                            ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        widget.selectedService.name,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        widget.selectedService.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.darkGrey.withOpacity(0.7),
                            ),
                      ),
                      const SizedBox(height: 8.0),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          'Prix: ${widget.selectedService.price.toStringAsFixed(0)} ${widget.selectedService.currency}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.accentBlue,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                'Vos informations personnelles',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGrey,
                    ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'Nom',
                  hintText: 'Entrez votre nom',
                  prefixIcon: Icon(Icons.person, color: AppColors.primaryBlue),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Prénom',
                  hintText: 'Entrez votre prénom',
                  prefixIcon: Icon(Icons.person_outline, color: AppColors.primaryBlue),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre prénom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Numéro de Téléphone',
                  hintText: 'Ex: 67X XXX XXX',
                  prefixIcon: Icon(Icons.phone, color: AppColors.primaryBlue),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre numéro de téléphone';
                  }
                  if (!RegExp(r'^\d{9}$').hasMatch(value)) { // Simple validation pour 9 chiffres
                    return 'Veuillez entrer un numéro de téléphone valide (9 chiffres)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              Text(
                'Méthode de Paiement',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGrey,
                    ),
              ),
              const SizedBox(height: 16.0),
              // Itérer sur les méthodes de paiement pour créer les RadioListTiles
              ..._paymentMethods.entries.map((entry) {
                final methodName = entry.key;
                final imagePath = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Card( // Enveloppez chaque RadioListTile dans une Card pour un meilleur style
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: RadioListTile<String>(
                      title: Row(
                        children: [
                          Image.asset(
                            imagePath,
                            height: 30, // Taille de l'image
                            width: 30,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.payment, size: 30, color: AppColors.primaryBlue); // Fallback icon
                            },
                          ),
                          const SizedBox(width: 12.0),
                          Text(methodName),
                        ],
                      ),
                      value: methodName,
                      groupValue: _selectedPaymentMethod,
                      onChanged: _onPaymentMethodSelected, // Appel de la nouvelle fonction
                      activeColor: AppColors.primaryBlue,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: _selectedPaymentMethod == methodName
                            ? const BorderSide(color: AppColors.accentBlue, width: 2.0) // Bordure pour la sélection
                            : BorderSide.none,
                      ),
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 32.0),
              Center(
                child: _isProcessingPayment
                    ? const CircularProgressIndicator(color: AppColors.primaryBlue)
                    : ElevatedButton.icon(
                        onPressed: _processPayment, // Le bouton déclenche le paiement après la saisie du code
                        icon: const Icon(Icons.payment),
                        label: const Text('Payer et Obtenir le Reçu'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          textStyle: const TextStyle(fontSize: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
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
