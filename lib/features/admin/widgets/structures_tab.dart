import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:structure_mobile/core/routes/app_router.dart';
import 'package:structure_mobile/features/admin/providers/dashboard_provider.dart';
import 'package:structure_mobile/themes/app_theme.dart';

class StructuresTab extends StatefulWidget {
  const StructuresTab({super.key});

  @override
  State<StructuresTab> createState() => _StructuresTabState();
}

class _StructuresTabState extends State<StructuresTab> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all';
  String _selectedSort = 'newest';
  bool _isLoading = false;

  // Méthode pour charger les structures avec filtres et tri
  Future<void> _loadFilteredAndSortedStructures() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final provider = Provider.of<DashboardProvider>(context, listen: false);
      await provider.loadStructures(
        status: _selectedFilter == 'all' ? null : _selectedFilter,
        searchQuery: _searchController.text.isEmpty
            ? null
            : _searchController.text,
        sortBy: _selectedSort,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement des structures: $e'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  final List<Map<String, dynamic>> _filters = [
    {'id': 'all', 'label': 'Toutes'},
    {'id': 'active', 'label': 'Actives'},
    {'id': 'pending', 'label': 'En attente'},
    {'id': 'suspended', 'label': 'Suspendues'},
  ];

  final List<Map<String, dynamic>> _sortOptions = [
    {'id': 'newest', 'label': 'Plus récentes'},
    {'id': 'oldest', 'label': 'Plus anciennes'},
    {'id': 'name_asc', 'label': 'Nom (A-Z)'},
    {'id': 'name_desc', 'label': 'Nom (Z-A)'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context);

    return Column(
      children: [
        // Barre de recherche et filtres
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Barre de recherche
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Rechercher une structure...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            if (mounted) {
                              setState(() {
                                // La recherche sera effectuée lors de la soumission
                              });
                            }
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 20,
                  ),
                ),
                onSubmitted: (value) {
                  // TODO: Mettre à jour la recherche
                },
              ),

              const SizedBox(height: 16),

              // Filtres
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // Filtres de statut
                    ..._filters.map((filter) {
                      final isSelected = _selectedFilter == filter['id'];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(filter['label']),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = selected ? filter['id'] : 'all';
                              if (mounted) {
                                setState(() {
                                  // Le filtre sera appliqué lors du chargement des données
                                });
                                _loadFilteredAndSortedStructures();
                              }
                            });
                          },
                          backgroundColor: isSelected
                              ? AppTheme.primaryColor.withOpacity(0.1)
                              : Colors.grey[200],
                          labelStyle: TextStyle(
                            color: isSelected
                                ? AppTheme.primaryColor
                                : Colors.black87,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? AppTheme.primaryColor
                                : Colors.grey[300]!,
                          ),
                        ),
                      );
                    }).toList(),

                    // Menu de tri
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        setState(() {
                          _selectedSort = value;
                        });
                        // Recharger les structures avec le nouveau tri
                        _loadFilteredAndSortedStructures();
                      },
                      itemBuilder: (context) =>
                          _sortOptions.map<PopupMenuEntry<String>>((option) {
                            return PopupMenuItem<String>(
                              value: option['id'] as String,
                              child: Text(option['label'] as String),
                            );
                          }).toList(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.sort, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              _sortOptions.firstWhere(
                                (opt) => opt['id'] == _selectedSort,
                                orElse: () => _sortOptions.first,
                              )['label'],
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Liste des structures
        Expanded(
          child: Consumer<DashboardProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.error != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(provider.error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Recharger les données
                        },
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                );
              }

              // Utiliser les structures du tableau de bord pour l'instant
              // Dans une vraie application, vous auriez une liste complète des structures
              final structures = provider.stats.topStructures;

              if (structures.isEmpty) {
                return const Center(child: Text('Aucune structure trouvée'));
              }

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: structures.length,
                itemBuilder: (context, index) {
                  final structure = structures[index];
                  return _buildStructureCard(structure);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStructureCard(Map<String, dynamic> structure) {
    final status = structure['status'] ?? 'pending';
    Color statusColor;
    String statusText;

    switch (status) {
      case 'active':
        statusColor = Colors.green;
        statusText = 'Active';
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusText = 'En attente';
        break;
      case 'suspended':
        statusColor = Colors.red;
        statusText = 'Suspendue';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Inconnu';
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRouter.structureDetail,
            arguments: structure,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo de la structure
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      image: structure['imageUrl'] != null
                          ? DecorationImage(
                              image: NetworkImage(structure['imageUrl']),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: structure['imageUrl'] == null
                        ? const Icon(
                            Icons.business,
                            size: 30,
                            color: Colors.grey,
                          )
                        : null,
                  ),

                  const SizedBox(width: 16),

                  // Détails de la structure
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                structure['name'] ?? 'Sans nom',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                statusText,
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        Text(
                          structure['category'] ?? 'Non spécifié',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Statistiques
                        Row(
                          children: [
                            _buildStatItem(
                              Icons.star,
                              '${structure['rating']?.toStringAsFixed(1) ?? '0.0'} (${structure['reviewCount'] ?? 0})',
                            ),
                            const SizedBox(width: 16),
                            _buildStatItem(
                              Icons.attach_money,
                              '${(structure['revenue'] / 1000).toStringAsFixed(0)}K FCFA',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (status == 'pending') ...[
                    TextButton(
                      onPressed: () {
                        _showRejectDialog(structure['id']);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: const Text('Refuser'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        _approveStructure(structure['id']);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: const Text('Approuver'),
                    ),
                  ] else ...[
                    TextButton(
                      onPressed: () {
                        // TODO: Voir les détails
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: const Text('Voir détails'),
                    ),
                    if (status == 'active') ...[
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () {
                          _suspendStructure(structure['id']);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.orange,
                          side: const BorderSide(color: Colors.orange),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: const Text('Suspendre'),
                      ),
                    ] else if (status == 'suspended') ...[
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () {
                          _activateStructure(structure['id']);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green,
                          side: const BorderSide(color: Colors.green),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: const Text('Activer'),
                      ),
                    ],
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Approuve une structure en attente
  /// Affiche des retours visuels pendant et après l'opération
  Future<void> _approveStructure(String structureId) async {
    if (!mounted) return;
    try {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirmer l\'approbation'),
          content: const Text(
            'Voulez-vous vraiment approuver cette structure ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: Colors.green),
              child: const Text('Approuver'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        // Afficher un indicateur de chargement
        final scaffold = ScaffoldMessenger.of(context);
        scaffold.showSnackBar(
          const SnackBar(
            content: Text('Traitement en cours...'),
            duration: Duration(seconds: 2),
          ),
        );

        // Simuler un appel API
        await Future.delayed(const Duration(seconds: 1));

        // Mettre à jour l'interface
        scaffold.hideCurrentSnackBar();
        scaffold.showSnackBar(
          const SnackBar(
            content: Text('Structure approuvée avec succès'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // TODO: Mettre à jour la liste des structures
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  /// Affiche une boîte de dialogue pour spécifier la raison du rejet
  Future<void> _showRejectDialog(String structureId) async {
    if (!mounted) return;
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Refuser la structure'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Veuillez indiquer la raison du refus :'),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Raison du refus...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              final reason = reasonController.text.trim();
              if (reason.isNotEmpty) {
                Navigator.pop(context);
                _rejectStructure(structureId, reason);
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Confirmer le refus'),
          ),
        ],
      ),
    );
  }

  /// Rejette une structure avec une raison donnée
  /// Affiche des retours visuels pendant et après l'opération
  Future<void> _rejectStructure(String structureId, String reason) async {
    if (!mounted) return;
    try {
      // Afficher un indicateur de chargement
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        const SnackBar(
          content: Text('Traitement en cours...'),
          duration: Duration(seconds: 2),
        ),
      );

      // Simuler un appel API
      await Future.delayed(const Duration(seconds: 1));

      // Mettre à jour l'interface
      scaffold.hideCurrentSnackBar();
      scaffold.showSnackBar(
        const SnackBar(
          content: Text('Structure refusée avec succès'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // TODO: Mettre à jour la liste des structures
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  /// Suspend une structure active
  /// Demande une confirmation avant de procéder
  Future<void> _suspendStructure(String structureId) async {
    if (!mounted) return;
    try {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Suspendre la structure'),
          content: const Text(
            'Voulez-vous vraiment suspendre cette structure ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: Colors.orange),
              child: const Text('Suspendre'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        // Afficher un indicateur de chargement
        final scaffold = ScaffoldMessenger.of(context);
        scaffold.showSnackBar(
          const SnackBar(
            content: Text('Traitement en cours...'),
            duration: Duration(seconds: 2),
          ),
        );

        // Simuler un appel API
        await Future.delayed(const Duration(seconds: 1));

        // Mettre à jour l'interface
        scaffold.hideCurrentSnackBar();
        scaffold.showSnackBar(
          const SnackBar(
            content: Text('Structure suspendue avec succès'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // TODO: Mettre à jour la liste des structures
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  /// Active une structure suspendue
  /// Demande une confirmation avant de procéder
  Future<void> _activateStructure(String structureId) async {
    if (!mounted) return;
    try {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Activer la structure'),
          content: const Text('Voulez-vous vraiment activer cette structure ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: Colors.green),
              child: const Text('Activer'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        // Afficher un indicateur de chargement
        final scaffold = ScaffoldMessenger.of(context);
        scaffold.showSnackBar(
          const SnackBar(
            content: Text('Traitement en cours...'),
            duration: Duration(seconds: 2),
          ),
        );

        // Simuler un appel API
        await Future.delayed(const Duration(seconds: 1));

        // Mettre à jour l'interface
        scaffold.hideCurrentSnackBar();
        scaffold.showSnackBar(
          const SnackBar(
            content: Text('Structure activée avec succès'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // TODO: Mettre à jour la liste des structures
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}
