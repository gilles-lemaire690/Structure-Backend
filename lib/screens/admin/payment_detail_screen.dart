import 'package:flutter/material.dart';
import 'package:structure_front/l10n/app_localizations.dart';
import 'package:structure_front/models/payment.dart';
import 'package:url_launcher/url_launcher.dart';


class PaymentDetailScreen extends StatelessWidget {
  final Payment payment;

  const PaymentDetailScreen({super.key, required this.payment});

  void _downloadReceipt(BuildContext context) async {
    final Uri url = Uri.parse(payment.receiptUrl);
    if (await launchUrl(url)) {
      print('Tentative d\'ouverture du reçu: ${payment.receiptUrl}');
    } else {
      print('Impossible de lancer l\'URL: ${payment.receiptUrl}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.couldNotOpenReceipt)), // Translated text
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!; // Access translations

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          appLocalizations.paymentDetails, // Translated title
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey[700],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- Section Informations sur le Paiement ---
            _buildSectionTitle(appLocalizations.paymentDetails), // Translated title
            const SizedBox(height: 10),
            _buildDetailRow(appLocalizations.transactionId, payment.id), // Translated label
            _buildDetailRow(appLocalizations.amount, 'XAF ${payment.amount.toStringAsFixed(0)}'), // Translated label
            _buildDetailRow(appLocalizations.date, '${payment.date.day}/${payment.date.month}/${payment.date.year} ${payment.date.hour}:${payment.date.minute.toString().padLeft(2, '0')}'), // Translated label
            _buildDetailRow(appLocalizations.paymentMethod, payment.paymentMethod), // Translated label
            const SizedBox(height: 30),

            // --- Section Informations sur le Client ---
            _buildSectionTitle(appLocalizations.clientInfo), // Translated title
            const SizedBox(height: 10),
            _buildDetailRow(appLocalizations.clientName, payment.clientName), // Translated label
            _buildDetailRow(appLocalizations.phoneNumber, '+237 6XXXXXXXX'), // Placeholder // Translated label
            const SizedBox(height: 30),

            // --- Section Informations sur le Service/Produit ---
            _buildSectionTitle(appLocalizations.serviceProductInfo), // Translated title
            const SizedBox(height: 10),
            _buildDetailRow(appLocalizations.serviceProduct, payment.serviceName), // Translated label
            const SizedBox(height: 40),

            // --- Bouton Télécharger le Reçu ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _downloadReceipt(context),
                icon: const Icon(Icons.download, color: Colors.white),
                label: Text(
                  appLocalizations.downloadReceipt, // Translated text
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[700],
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget utilitaire pour les titres de section
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  // Widget utilitaire pour afficher une ligne de détail
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[700]),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}