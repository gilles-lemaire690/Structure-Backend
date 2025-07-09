import 'package:flutter/material.dart';
import 'package:structure_front/models/payment.dart';
import 'package:url_launcher/url_launcher.dart'; // Importez le package

class PaymentDetailScreen extends StatelessWidget {
  final Payment payment;

  const PaymentDetailScreen({super.key, required this.payment});

  // Fonction pour lancer le téléchargement/ouverture du reçu
  // Le BuildContext est maintenant passé en paramètre
  void _downloadReceipt(BuildContext context) async {
    final Uri url = Uri.parse(payment.receiptUrl);
    // Utilisez `launchUrl` directement comme une fonction statique
    if (await launchUrl(url)) { // canLaunchUrl est déprécié, launchUrl retourne directement un booléen
      print('Tentative d\'ouverture du reçu: ${payment.receiptUrl}');
    } else {
      print('Impossible de lancer l\'URL: ${payment.receiptUrl}');
      // Afficher un message d'erreur à l'utilisateur
      ScaffoldMessenger.of(context).showSnackBar( // Utilisez le context passé en paramètre
        const SnackBar(content: Text('Impossible d\'ouvrir le reçu. Vérifiez l\'URL.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) { // Le build method a déjà le context
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Détails du Paiement',
          style: TextStyle(color: Colors.white),
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
            _buildSectionTitle('Informations du Paiement'),
            const SizedBox(height: 10),
            _buildDetailRow('ID de Transaction:', payment.id),
            _buildDetailRow('Montant:', 'XAF ${payment.amount.toStringAsFixed(0)}'),
            _buildDetailRow('Date:', '${payment.date.day}/${payment.date.month}/${payment.date.year} ${payment.date.hour}:${payment.date.minute.toString().padLeft(2, '0')}'),
            _buildDetailRow('Méthode de Paiement:', payment.paymentMethod),
            const SizedBox(height: 30),

            // --- Section Informations sur le Client ---
            _buildSectionTitle('Informations du Client'),
            const SizedBox(height: 10),
            _buildDetailRow('Nom du Client:', payment.clientName),
            _buildDetailRow('Numéro de Téléphone:', '+237 6XXXXXXXX'), // Placeholder
            const SizedBox(height: 30),

            // --- Section Informations sur le Service/Produit ---
            _buildSectionTitle('Informations Service/Produit'),
            const SizedBox(height: 10),
            _buildDetailRow('Service/Produit:', payment.serviceName),
            const SizedBox(height: 40),

            // --- Bouton Télécharger le Reçu ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _downloadReceipt(context), // Passe le context au onPressed
                icon: const Icon(Icons.download, color: Colors.white),
                label: const Text(
                  'Télécharger le Reçu',
                  style: TextStyle(fontSize: 18, color: Colors.white),
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