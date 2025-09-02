import 'package:flutter/material.dart';
import 'package:structure_mobile/core/constants/app_constants.dart';
import 'package:structure_mobile/features/user/models/models.dart';
import 'package:structure_mobile/features/user/widgets/receipt_widget.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String transactionId;
  final StructureModel structure;
  final ServiceModel service;
  final String customerName;
  final String customerPhone;
  final DateTime paymentDate;

  const PaymentSuccessScreen({
    Key? key,
    required this.transactionId,
    required this.structure,
    required this.service,
    required this.customerName,
    required this.customerPhone,
    required this.paymentDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.mediumPadding),
          child: Column(
            children: [
              // En-tête avec icône de succès
              const SizedBox(height: AppConstants.largePadding),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  size: 60,
                  color: Colors.green,
                ),
              ),
              
              const SizedBox(height: AppConstants.largePadding),
              
              // Titre de succès
              Text(
                'Paiement effectué avec succès !',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppConstants.mediumPadding),
              
              // Référence de transaction
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.mediumPadding,
                  vertical: AppConstants.smallPadding,
                ),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
                  border: Border.all(color: Colors.green[100]!),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Référence de transaction',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      transactionId,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppConstants.largePadding),
              
              // Reçu de paiement
              ReceiptWidget(
                transactionId: transactionId,
                structure: structure,
                service: service,
                customerName: customerName,
                customerPhone: customerPhone,
                paymentDate: paymentDate,
              ),
              
              const SizedBox(height: AppConstants.largePadding),
              
              // Bouton de retour à l'accueil
              SizedBox(
                width: double.infinity,
                height: AppConstants.buttonHeight,
                child: ElevatedButton(
                  onPressed: () {
                    // Retour à l'écran d'accueil
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
                    ),
                  ),
                  child: const Text('Retour à l\'accueil'),
                ),
              ),
              
              const SizedBox(height: AppConstants.mediumPadding),
              
              // Bouton de partage
              OutlinedButton(
                onPressed: () {
                  // TODO: Implémenter le partage du reçu
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fonctionnalité de partage à implémenter'),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
                  ),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.share_outlined),
                    SizedBox(width: 8),
                    Text('Partager le reçu'),
                  ],
                ),
              ),
              
              const SizedBox(height: AppConstants.mediumPadding),
              
              // Bouton de téléchargement
              TextButton(
                onPressed: () {
                  // TODO: Implémenter le téléchargement du reçu
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fonctionnalité de téléchargement à implémenter'),
                    ),
                  );
                },
                child: const Text('Télécharger le reçu en PDF'),
              ),
              
              const SizedBox(height: AppConstants.largePadding),
              
              // Message de remerciement
              const Text(
                'Merci pour votre confiance !',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
