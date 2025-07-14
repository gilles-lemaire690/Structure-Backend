import 'package:flutter/material.dart';
import 'package:structure_front/screens/auth/login_screen.dart';
import 'package:structure_front/screens/admin/admin_dashboard_screen.dart';
import 'package:structure_front/screens/admin/admin_management_screen.dart';
import 'package:structure_front/screens/admin/structure_management_screen.dart';
import 'package:structure_front/screens/admin/service_product_management_screen.dart';
import 'package:structure_front/screens/admin/payment_detail_screen.dart';
import 'package:structure_front/l10n/app_localizations.dart';

class SuperAdminDashboardScreen extends StatelessWidget {
  const SuperAdminDashboardScreen({super.key});

  void _logout(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
    print('Super Admin déconnecté.');
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          appLocalizations.appTitle, // Nom de l'application
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey[700],
        actions: [
          // Language Selection Button
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language, color: Colors.white),
            onSelected: (Locale locale) {
              // MyApp.of(context)?.setLocale(locale); // Commented out as MyApp is not available
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
            tooltip: appLocalizations.logout, // Tooltip pour le bouton de déconnexion
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              appLocalizations.helloAdmin('Super Admin'), // Example: "Hello, Admin!"
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),

            // --- Section Statistiques (Exemple) ---
            GridView.count(
              crossAxisCount: 2, // 2 cartes par ligne
              shrinkWrap: true, // Pour que le GridView s'adapte à son contenu
              physics: const NeverScrollableScrollPhysics(), // Désactive le défilement du GridView
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: <Widget>[
                _buildInfoCard(context, 'Total Structures', '15', Icons.apartment),
                _buildInfoCard(context, 'Total Admins', '5', Icons.people),
                _buildInfoCard(context, 'Paiements Aujourd\'hui', 'XAF 1.2M', Icons.payments),
                _buildInfoCard(context, 'Services Actifs', '50+', Icons.miscellaneous_services),
              ],
            ),
            const SizedBox(height: 40),

            // --- Section Navigation Rapide ---
            Text(
              appLocalizations.quickActions,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
           _buildActionButton(
  context,
  'Gérer les Admins',
  Icons.admin_panel_settings,
  () {
    // Naviguer vers l'écran de gestion des Admins
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AdminManagementScreen()),
    );
  },
),
            const SizedBox(height: 15),
           _buildActionButton(
  context,
  'Gérer les Structures',
  Icons.corporate_fare,
  () {
    // Naviguer vers l'écran de gestion des Structures
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const StructureManagementScreen()),
    );
  },
),
            const SizedBox(height: 15),
            _buildActionButton(
              context,
              appLocalizations.viewAllPayments,
              Icons.receipt_long,
                  () {
                print('Naviguer vers Voir tous les Paiements');
                // TODO: Implémenter la navigation vers GlobalPaymentsScreen
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget utilitaire pour les cartes d'information
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
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget utilitaire pour les boutons d'action
  Widget _buildActionButton(BuildContext context, String title, IconData icon, VoidCallback onPressed) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Row(
            children: [
              Icon(icon, size: 30, color: Colors.blueGrey[700]),
              const SizedBox(width: 15),
              Text(
                title,
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
