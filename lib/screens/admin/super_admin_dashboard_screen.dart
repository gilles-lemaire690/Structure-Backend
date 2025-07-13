import 'package:flutter/material.dart';
import 'package:structure_front/screens/auth/login_screen.dart'; // Pour la déconnexion
import 'package:structure_front/screens/admin/admin_management_screen.dart'; // <-- Ajoutez cette ligne
import 'package:structure_front/screens/admin/structure_management_screen.dart'; // Ajoutez cette ligne

class SuperAdminDashboardScreen extends StatelessWidget {
  const SuperAdminDashboardScreen({super.key});

  void _logout(BuildContext context) {
    // Logique de déconnexion (par exemple, effacer le token d'authentification)
    // Pour l'instant, on redirige simplement vers l'écran de connexion
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false, // Supprime toutes les routes précédentes
    );
    print('Super Admin déconnecté.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Fond gris très clair
      appBar: AppBar(
        title: const Text(
          'Tableau de Bord Super Admin',
          style: TextStyle(color: Colors.white), // Texte blanc pour le titre
        ),
        backgroundColor: Colors.blueGrey[700], // Couleur foncée et sobre
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _logout(context),
            tooltip: 'Déconnexion',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Bienvenue, Super Admin!',
              style: TextStyle(
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
              physics:
                  const NeverScrollableScrollPhysics(), // Désactive le défilement du GridView
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: <Widget>[
                _buildInfoCard(
                  context,
                  'Total Structures',
                  '15',
                  Icons.apartment,
                ),
                _buildInfoCard(context, 'Total Admins', '5', Icons.people),
                _buildInfoCard(
                  context,
                  'Paiements Aujourd\'hui',
                  'XAF 1.2M',
                  Icons.payments,
                ),
                _buildInfoCard(
                  context,
                  'Services Actifs',
                  '50+',
                  Icons.miscellaneous_services,
                ),
              ],
            ),
            const SizedBox(height: 40),

            // --- Section Navigation Rapide ---
            const Text(
              'Actions Rapides',
              style: TextStyle(
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
                  MaterialPageRoute(
                    builder: (context) => const AdminManagementScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
            _buildActionButton(
              context,
              'Gérer les Structures',
              Icons.corporate_fare, // Icône pour les structures
              () {
                // Naviguer vers l'écran de gestion des Structures
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const StructureManagementScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 15),
            _buildActionButton(
              context,
              'Voir tous les Paiements',
              Icons.receipt_long,
              () {
                // Naviguer vers l'écran de vue globale des Paiements
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
  Widget _buildInfoCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
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
  Widget _buildActionButton(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onPressed,
  ) {
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
