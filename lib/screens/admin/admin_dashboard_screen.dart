import 'package:flutter/material.dart';
import 'package:structure_front/models/payment.dart'; // Importez le modèle de paiement
import 'package:structure_front/screens/auth/login_screen.dart'; // Pour la déconnexion
import 'package:structure_front/screens/admin/payment_detail_screen.dart'; // Importez l'écran de détails du paiement
import 'package:structure_front/screens/admin/service_product_management_screen.dart'; // NOUVEL IMPORT pour la gestion des services/produits
import 'package:structure_front/themes/app_theme.dart'; // NOUVEL IMPORT pour la gestion des thèmes

class AdminDashboardScreen extends StatefulWidget {
  final String
  adminEmail; // Pour identifier l'admin (pour simuler la structure)

  const AdminDashboardScreen({super.key, required this.adminEmail});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  // Simulez les données de la structure et les paiements en fonction de l'admin
  String _structureName =
      "Ma Structure"; // Sera mis à jour en fonction de l'admin
  String _currentStructureId =
      ''; // NOUVEAU: Variable pour stocker l'ID de la structure de l'Admin
  List<Payment> _payments = [];

  @override
  void initState() {
    super.initState();
    _loadAdminData();
  }

  void _loadAdminData() {
    // Dans une vraie application, vous feriez un appel API ici
    // pour récupérer les infos de la structure et ses paiements
    // basées sur l'ID de l'admin ou son email.

    if (widget.adminEmail == 'admin1@structureA.com') {
      _structureName = 'Pharmacie Centrale';
      _currentStructureId = 'S001'; // ID de structure simulé
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
      _currentStructureId = 'S002'; // ID de structure simulé
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
      _currentStructureId = ''; // Pas de structure associée
      _payments = [];
    }

    setState(() {}); // Rafraîchit l'interface avec les données chargées
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
    // Calcul des totaux simulés
    double totalAmount = _payments.fold(0.0, (sum, item) => sum + item.amount);
    int totalTransactions = _payments.length;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Tableau de Bord de $_structureName',
          style: const TextStyle(color: Colors.black87, fontSize: 18),
        ),
        backgroundColor: AppTheme.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
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
            Text(
              'Bonjour, ${widget.adminEmail.split('@').first} !', // Juste un exemple
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
                _buildInfoCard(
                  context,
                  'Paiements Totaux',
                  'XAF ${totalAmount.toStringAsFixed(0)}',
                  Icons.payments,
                ),
                _buildInfoCard(
                  context,
                  'Transactions',
                  '$totalTransactions',
                  Icons.receipt_long,
                ),
                // Ajoutez d'autres stats si besoin
              ],
            ),
            const SizedBox(height: 40),

            // --- Nouvelle Section: Gestion de la Structure (AJOUTÉE) ---
            const Text(
              'Gestion de ma Structure',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            _buildActionButton(
              context,
              'Gérer Services & Produits',
              Icons.assignment, // Icône pour les services/produits
              () {
                // Naviguer vers l'écran de gestion des services/produits
                if (_currentStructureId.isNotEmpty) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ServiceProductManagementScreen(
                        structureId: _currentStructureId,
                        structureName: _structureName,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Aucune structure associée pour gérer les services.',
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(
              height: 40,
            ), // Espace avant l'historique des paiements
            // --- Historique des Paiements ---
            const Text(
              'Historique des Paiements',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            _payments.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: Text(
                        'Aucun paiement enregistré pour cette structure.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blueGrey[100],
                            child: Icon(
                              Icons.money,
                              color: Colors.blueGrey[700],
                            ),
                          ),
                          title: Text(
                            '${payment.serviceName} - ${payment.clientName}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Montant: XAF ${payment.amount.toStringAsFixed(0)}\nMéthode: ${payment.paymentMethod}\nDate: ${payment.date.day}/${payment.date.month}/${payment.date.year}',
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            // NAVIGUER VERS L'ÉCRAN DE DÉTAILS DU PAIEMENT
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    PaymentDetailScreen(payment: payment),
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

  // Widget utilitaire pour les cartes d'information (copié de SuperAdminDashboard)
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

  // Widget utilitaire pour les boutons d'action (copié de SuperAdminDashboard)
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
