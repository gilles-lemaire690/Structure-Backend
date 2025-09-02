import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:structure_mobile/features/admin/providers/dashboard_provider.dart';
import 'package:structure_mobile/features/admin/widgets/dashboard_header.dart';
import 'package:structure_mobile/features/admin/widgets/overview_tab.dart';
import 'package:structure_mobile/features/admin/widgets/structures_tab.dart';
import 'package:structure_mobile/features/admin/widgets/users_tab.dart';
import 'package:structure_mobile/features/admin/widgets/reports_tab.dart';
import 'package:structure_mobile/features/admin/widgets/services_products_tab.dart';
import 'package:structure_mobile/features/admin/widgets/payments_tab.dart';
import 'package:structure_mobile/features/admin/widgets/admins_tab.dart';
import 'package:structure_mobile/themes/app_theme.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Liste des onglets du tableau de bord
  final List<Map<String, dynamic>> _tabs = [
    {'id': 'overview', 'title': 'Aperçu', 'icon': Icons.dashboard},
    {'id': 'payments', 'title': 'Paiements', 'icon': Icons.payment},
    {'id': 'services', 'title': 'Services/Produits', 'icon': Icons.medical_services},
    {'id': 'admins', 'title': 'Administrateurs', 'icon': Icons.admin_panel_settings},
    {'id': 'structures', 'title': 'Structures', 'icon': Icons.business},
    {'id': 'users', 'title': 'Utilisateurs', 'icon': Icons.people},
    {'id': 'reports', 'title': 'Rapports', 'icon': Icons.analytics},
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Récupérer le paramètre structureId de l'URL s'il existe
    final uri = Uri.parse(ModalRoute.of(context)!.settings.name ?? '');
    final structureId = uri.queryParameters['structureId'];
    
    // Charger les données du tableau de bord avec le filtre de structure si nécessaire
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<DashboardProvider>();
      provider.loadDashboardData();
      
      // Charger les structures avec le filtre si un ID est fourni
      if (structureId != null && structureId.isNotEmpty) {
        provider.loadStructures(structureId: structureId);
        debugPrint('Chargement des données pour la structure: $structureId');
      } else {
        provider.loadStructures();
      }
    });
  }
  
  @override
  void initState() {
    super.initState();
  }

  // Obtenir l'écran correspondant à l'onglet actif
  Widget _getActiveTab(String tabId) {
    switch (tabId) {
      case 'overview':
        return const OverviewTab();
      case 'payments':
        return const PaymentsTab();
      case 'services':
        return const ServicesProductsTab();
      case 'admins':
        return const AdminsTab();
      case 'structures':
        return const StructuresTab();
      case 'users':
        return const UsersTab();
      case 'reports':
        return const ReportsTab();
      default:
        return const OverviewTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Tableau de bord Admin'),
        elevation: 0,
        actions: [
          // Bouton de notification
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_none),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: const Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              // TODO: Afficher les notifications
            },
          ),
          // Menu utilisateur
          PopupMenuButton<String>(
            onSelected: (value) {
              // Gérer les actions du menu utilisateur
              switch (value) {
                case 'profile':
                  // TODO: Naviguer vers le profil
                  break;
                case 'settings':
                  // TODO: Naviguer vers les paramètres
                  break;
                case 'logout':
                  // TODO: Déconnexion
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Text('Mon profil'),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Text('Paramètres'),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Text('Déconnexion'),
              ),
            ],
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: CircleAvatar(
                backgroundColor: AppTheme.primaryColor,
                child: Text(
                  'A',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Column(
        children: [
          // En-tête du tableau de bord
          const DashboardHeader(),
          
          // Barre d'onglets
          Consumer<DashboardProvider>(
            builder: (context, provider, _) {
              return Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _tabs.map((tab) {
                      final isActive = provider.activeTab == tab['id'];
                      return GestureDetector(
                        onTap: () {
                          provider.setActiveTab(tab['id']);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: isActive
                                    ? AppTheme.primaryColor
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                tab['icon'],
                                color: isActive
                                    ? AppTheme.primaryColor
                                    : Colors.grey,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                tab['title'],
                                style: TextStyle(
                                  color: isActive
                                      ? AppTheme.primaryColor
                                      : Colors.grey[700],
                                  fontWeight: isActive
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
          
          // Contenu de l'onglet actif
          Expanded(
            child: Consumer<DashboardProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading && provider.activeTab == 'overview') {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (provider.error != null && provider.activeTab == 'overview') {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(provider.error!),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: provider.loadDashboardData,
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  );
                }
                
                return _getActiveTab(provider.activeTab);
              },
            ),
          ),
        ],
      ),
      // Bouton flottant pour les actions rapides
      floatingActionButton: Consumer<DashboardProvider>(
        builder: (context, provider, _) {
          if (provider.activeTab == 'structures') {
            return FloatingActionButton(
              onPressed: () {
                // TODO: Naviguer vers l'ajout d'une nouvelle structure
              },
              backgroundColor: AppTheme.primaryColor,
              child: const Icon(Icons.add, color: Colors.white),
            );
          } else if (provider.activeTab == 'users') {
            return FloatingActionButton(
              onPressed: () {
                // TODO: Naviguer vers l'ajout d'un nouvel utilisateur
              },
              backgroundColor: AppTheme.primaryColor,
              child: const Icon(Icons.person_add, color: Colors.white),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  // Menu latéral
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // En-tête du menu
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Admin User',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'admin@example.com',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Éléments du menu
          ..._tabs.map((tab) {
            return Consumer<DashboardProvider>(
              builder: (context, provider, _) {
                final isActive = provider.activeTab == tab['id'];
                return ListTile(
                  leading: Icon(
                    tab['icon'],
                    color: isActive ? AppTheme.primaryColor : null,
                  ),
                  title: Text(
                    tab['title'],
                    style: TextStyle(
                      color: isActive ? AppTheme.primaryColor : null,
                      fontWeight: isActive ? FontWeight.bold : null,
                    ),
                  ),
                  selected: isActive,
                  selectedTileColor: AppTheme.primaryColor.withOpacity(0.1),
                  onTap: () {
                    provider.setActiveTab(tab['id']);
                    Navigator.pop(context);
                  },
                );
              },
            );
          }),
          
          const Divider(),
          
          // Autres options
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Paramètres'),
            onTap: () {
              // TODO: Naviguer vers les paramètres
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Aide & Support'),
            onTap: () {
              // TODO: Naviguer vers l'aide
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Déconnexion', style: TextStyle(color: Colors.red)),
            onTap: () {
              // TODO: Déconnexion
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
