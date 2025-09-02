import 'dart:math';

import 'package:flutter/material.dart';
import 'package:structure_mobile/core/constants/app_constants.dart';
import 'package:structure_mobile/core/widgets/loading_widget.dart';
import 'package:structure_mobile/features/user/models/models.dart';
import 'package:structure_mobile/features/user/widgets/payment_form.dart';

class PaymentScreen extends StatefulWidget {
  final StructureModel structure;
  final List<Map<String, dynamic>>
  selectedServices; // Liste des services sélectionnés avec quantités
  final double totalAmount;

  const PaymentScreen({
    super.key,
    required this.structure,
    required this.selectedServices,
    required this.totalAmount,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _secretCodeController = TextEditingController();
  final bool _isLoading = false;
  bool _isProcessing = false;
  bool _isSuccess = false;
  String? _errorMessage;
  PaymentMethod _selectedPaymentMethod = PaymentMethod.mtnMoney;

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _secretCodeController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      // Simuler un traitement de paiement
      await Future.delayed(const Duration(seconds: 2));

      // Simuler une erreur aléatoire (10% de chance)
      final hasError = Random().nextInt(10) == 0;

      if (hasError) {
        throw Exception(
          'Échec du traitement du paiement. Veuillez réessayer ou utiliser un autre moyen de paiement.',
        );
      }

      // Paiement réussi
      if (!mounted) return;

      // Naviguer vers l'écran de succès
      final transactionId = 'TXN-${DateTime.now().millisecondsSinceEpoch}';

      // Envoyer les données de transaction au serveur (simulé)
      await _saveTransaction(transactionId);

      setState(() {
        _isSuccess = true;
      });

      // Afficher la confirmation de paiement
      _showPaymentSuccess(transactionId);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });

      // Afficher l'erreur à l'utilisateur
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage ?? 'Une erreur est survenue'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _saveTransaction(String transactionId) async {
    // Ici, vous enverriez normalement les détails de la transaction à votre backend
    await Future.delayed(const Duration(seconds: 1));

    // Simuler l'enregistrement de la transaction
    debugPrint('Transaction enregistrée: $transactionId');
  }

  void _showPaymentSuccess(String transactionId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.mediumPadding),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icône de succès
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 50,
              ),
            ),

            const SizedBox(height: AppConstants.mediumPadding),

            // Titre
            Text(
              'Paiement réussi !',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: AppConstants.smallPadding),

            // Message
            Text(
              'Votre paiement a été traité avec succès.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppConstants.mediumPadding),

            // Référence de transaction
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.mediumPadding),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Référence',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transactionId,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.largePadding),

            // Bouton de retour
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Retour à l'écran précédent
                  Navigator.of(context).pop(true); // Retour avec succès
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppConstants.mediumRadius,
                    ),
                  ),
                ),
                child: const Text('Retour à l\'accueil'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Affiche l'écran de succès après un paiement réussi
  Widget _buildSuccessScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paiement réussi'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icône de succès
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 60,
                ),
              ),

              const SizedBox(height: AppConstants.largePadding),

              // Titre
              Text(
                'Paiement effectué avec succès !',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppConstants.mediumPadding),

              // Message de confirmation
              Text(
                'Merci pour votre confiance. Votre paiement a été traité avec succès.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppConstants.largePadding * 2),

              // Bouton de retour à l'accueil
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Retour à l'écran d'accueil
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.mediumRadius,
                      ),
                    ),
                  ),
                  child: const Text('Retour à l\'accueil'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isSuccess) {
      return _buildSuccessScreen(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paiement'),
        leading: _isProcessing
            ? const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : null,
      ),
      body: _isLoading
          ? const Center(child: LoadingWidget())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.mediumPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Formulaire de paiement
                  PaymentForm(
                    formKey: _formKey,
                    phoneController: _phoneController,
                    nameController: _nameController,
                    secretCodeController: _secretCodeController,
                    selectedServices: widget.selectedServices,
                    totalAmount: widget.totalAmount,
                    isEnabled: !_isProcessing,
                    isProcessing: _isProcessing,
                    onPaymentMethodSelected: (method) {
                      setState(() => _selectedPaymentMethod = method);
                    },
                    selectedPaymentMethod: _selectedPaymentMethod,
                    onPaymentSubmitted: _processPayment,
                  ),

                  if (_errorMessage != null) ...{
                    const SizedBox(height: AppConstants.mediumPadding),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppConstants.mediumPadding),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(
                          AppConstants.mediumRadius,
                        ),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  },

                  const SizedBox(height: AppConstants.largePadding),

                  // Bouton de paiement
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : _processPayment,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppConstants.mediumRadius,
                          ),
                        ),
                      ),
                      child: _isProcessing
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Payer maintenant',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),

                  const SizedBox(height: AppConstants.mediumPadding),

                  // Sécurité des paiements
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 16,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Paiement sécurisé',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
