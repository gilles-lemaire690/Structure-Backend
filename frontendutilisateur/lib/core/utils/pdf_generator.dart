import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_saver/file_saver.dart'; // Importez file_saver

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Générateur de Reçu PDF',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _message = '';

  // Fonction pour simuler les détails de la transaction
  Map<String, dynamic> _getTransactionDetails() {
    return {
      'serviceName': 'Consultation Médicale',
      'serviceDescription': 'Consultation générale avec le Dr. Dupont',
      'price': '50.00 EUR',
      'firstName': 'Jean',
      'lastName': 'Durand',
      'phoneNumber': '+33 6 12 34 56 78',
      'paymentMethod': 'Carte Bancaire',
      'transactionDate': DateTime.now().toLocal().toString().split(' ')[0], // Juste la date
      'transactionId': 'TXN${DateTime.now().millisecondsSinceEpoch}',
    };
  }

  Future<void> _generateAndSaveReceipt() async {
    setState(() {
      _message = 'Génération et sauvegarde du reçu en cours...';
    });

    // 1. Demander la permission de stockage
    var status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        final details = _getTransactionDetails();
        final String? filePath = await PdfGenerator.generateAndSaveReceiptPdf(details);

        if (filePath != null) {
          setState(() {
            _message = 'Reçu sauvegardé avec succès dans le dossier Téléchargements: $filePath';
          });
          // Optionnel: Ouvrir le fichier après la sauvegarde
          // await OpenFilex.open(filePath); // Nécessite le package open_filex
        } else {
          setState(() {
            _message = 'Échec de la sauvegarde du reçu.';
          });
        }
      } catch (e) {
        setState(() {
          _message = 'Une erreur est survenue: $e';
        });
        print('Erreur inattendue: $e');
      }
    } else {
      setState(() {
        _message = 'Permission de stockage refusée. Impossible de sauvegarder le reçu.';
      });
      print('Permission de stockage refusée.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reçu de Paiement'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton.icon(
                onPressed: _generateAndSaveReceipt,
                icon: const Icon(Icons.receipt_long),
                label: const Text(
                  'Payer et Obtenir le Reçu',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                _message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _message.contains('succès') ? Colors.green : Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PdfGenerator {
  static Future<String?> generateAndSaveReceiptPdf(Map<String, dynamic> details) async {
    final pdf = pw.Document();

    // Vous pouvez charger une police à partir de vos assets si vous le souhaitez
    // final font = await PdfGoogleFonts.interRegular(); // Nécessite le package pdf_google_fonts

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Reçu de Paiement',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800),
              ),
              pw.SizedBox(height: 20),
              pw.Divider(color: PdfColors.blueGrey),
              pw.SizedBox(height: 20),
              _buildDetailRow('Service:', details['serviceName'].toString()),
              _buildDetailRow('Description:', details['serviceDescription'].toString()),
              _buildDetailRow('Prix:', details['price'].toString()),
              _buildDetailRow('Nom:', '${details['firstName']} ${details['lastName']}'),
              _buildDetailRow('Téléphone:', details['phoneNumber'].toString()),
              _buildDetailRow('Méthode de paiement:', details['paymentMethod'].toString()),
              _buildDetailRow('Date de transaction:', details['transactionDate'].toString()),
              _buildDetailRow('ID de transaction:', details['transactionId'].toString()),
              pw.SizedBox(height: 40),
              pw.Center(
                child: pw.Text(
                  'Merci pour votre transaction !',
                  style: pw.TextStyle(fontSize: 16, fontStyle: pw.FontStyle.italic, color: PdfColors.grey700),
                ),
              ),
            ],
          );
        },
      ),
    );

    try {
      // Obtenir le répertoire de téléchargements
      final directory = await getDownloadsDirectory();
      if (directory == null) {
        print('Impossible de trouver le répertoire de téléchargements.');
        return null;
      }

      final String fileName = 'receipt_${details['transactionId']}.pdf';
      final String filePath = '${directory.path}/$fileName';

      // Enregistrer le fichier en utilisant file_saver
      // MimeType.pdf est important pour qu'Android reconnaisse le type de fichier
      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: await pdf.save(),
        mimeType: MimeType.pdf,
        // filePath: filePath, // filePath n'est pas utilisé directement par saveFile pour le chemin complet
      );

      print('PDF sauvegardé à: $filePath'); // Afficher le chemin pour le débogage
      return filePath; // Retourner le chemin complet pour confirmation
    } catch (e) {
      print('Erreur lors de la sauvegarde du PDF: $e');
      return null;
    }
  }

  static pw.Widget _buildDetailRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 150,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: const pw.TextStyle(color: PdfColors.black),
            ),
          ),
        ],
      ),
    );
  }
}
