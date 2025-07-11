import 'package:flutter/material.dart';
import 'package:structure_front/l10n/app_localizations.dart';
import 'package:structure_front/models/payment.dart';
import 'package:structure_front/screens/auth/login_screen.dart';
import 'package:structure_front/screens/admin/payment_detail_screen.dart';

import 'package:structure_front/main.dart'; // Import MyApp to access setLocale

class AdminDashboardScreen extends StatefulWidget {
  final String adminEmail;

  const AdminDashboardScreen({super.key, required this.adminEmail});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String _structureName = "Ma Structure";
  List<Payment> _payments = [];

  @override
  void initState() {
    super.initState();
    _loadAdminData();
  }

  void _loadAdminData() {
    if (widget.adminEmail == 'admin1@structureA.com') {
      _structureName = 'Pharmacie Centrale';
      _payments = [
        Payment(
          id: 'P001',
          clientName: 'Diallo A.',
          serviceName: 'Achat Médicaments',
          amount: 15000.0,
          date: DateTime.now().subtract(const Duration(days: 1)),
          paymentMethod: 'MTN Money',
          receiptUrl: 'http://example.com/receipts/P001.pdf',
        ),
        Payment(
          id: 'P002',
          clientName: 'Nda A.',
          serviceName: 'Consultation',
          amount: 5000.0,
          date: DateTime.now().subtract(const Duration(hours: 5)),
          paymentMethod: 'Orange Money',
          receiptUrl: 'http://example.com/receipts/P002.pdf',
        ),
      ];
    } else if (widget.adminEmail == 'admin2@structureB.com') {
      _structureName = 'École Primaire Les Génies';
      _payments = [
        Payment(
          id: 'P003',
          clientName: 'Kouamo J.',
          serviceName: 'Frais de scolarité',
          amount: 75000.0,
          date: DateTime.now().subtract(const Duration(days: 3)),
          paymentMethod: 'CAM-POST',
          receiptUrl: 'http://example.com/receipts/P003.pdf',
        ),
        Payment(
          id: 'P004',
          clientName: 'Ngono M.',
          serviceName: 'Cantine du mois',
          amount: 10000.0,
          date: DateTime.now().subtract(const Duration(days: 2)),
          paymentMethod: 'MTN Money',
          receiptUrl: 'http://example.com/receipts/P004.pdf',
        ),
      ];
    } else {
      _structureName = 'Structure Inconnue';
      _payments = [];
    }

    setState(() {});
  }

  void _logout(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
    print('Admin déconnecté.');
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!; // Access translations

    double totalAmount = _payments.fold(0.0, (sum, item) => sum + item.amount);
    int totalTransactions = _payments.length;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          appLocalizations.adminDashboardTitle( _structureName), // Translated title
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Colors.blueGrey[700],
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Language Selection Button
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language, color: Colors.white),
            onSelected: (Locale locale) {
              MyApp.of(context)?.setLocale(locale); // Set the new locale
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
              const PopupMenuItem<Locale>(
                value: Locale('en'),
                child: Text('English'),
              ),
              const PopupMenuItem<Locale>(
                value: Locale('fr'),
                child: Text('Français'),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _logout(context),
            tooltip: appLocalizations.logout, // Translated tooltip
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              appLocalizations.helloAdmin(widget.adminEmail.split('@').first),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // --- Section Statistiques de Paiement ---
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: <Widget>[
                _buildInfoCard(context, appLocalizations.totalPayments, 'XAF ${totalAmount.toStringAsFixed(0)}', Icons.payments),
                _buildInfoCard(context, appLocalizations.transactions, '$totalTransactions', Icons.receipt_long),
              ],
            ),
            const SizedBox(height: 40),

            // --- Historique des Paiements ---
            Text(
              appLocalizations.paymentHistory,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            _payments.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: Text(
                        appLocalizations.noPaymentsRecorded,
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _payments.length,
                    itemBuilder: (context, index) {
                      final payment = _payments[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blueGrey[100],
                            child: Icon(Icons.money, color: Colors.blueGrey[700]),
                          ),
                          title: Text(
                            '${payment.serviceName} - ${payment.clientName}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${appLocalizations.amount}: XAF ${payment.amount.toStringAsFixed(0)}\n${appLocalizations.paymentMethod}: ${payment.paymentMethod}\n${appLocalizations.date}: ${payment.date.day}/${payment.date.month}/${payment.date.year}',
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PaymentDetailScreen(payment: payment),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, String value, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blueGrey[700]),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}