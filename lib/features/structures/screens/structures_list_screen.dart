import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:structure_mobile/core/routes/app_router.dart';
import 'package:structure_mobile/features/structures/models/structure_model.dart';
import 'package:structure_mobile/features/structures/providers/structures_provider.dart';
import 'package:structure_mobile/themes/app_theme.dart';

class StructuresListScreen extends StatefulWidget {
  const StructuresListScreen({super.key});

  @override
  State<StructuresListScreen> createState() => _StructuresListScreenState();
}

class _StructuresListScreenState extends State<StructuresListScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String? _selectedCategory;
  String? _selectedSortOption;
  final _scrollController = ScrollController();
  bool _isFilterOptionsVisible = false;

  @override
  void initState() {
    super.initState();
    // Charger les structures au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadStructures();
    });

    // Écouter le défilement pour masquer/afficher le bouton de filtre
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Peut être utilisé pour ajouter du chargement infini plus tard
  }

  Future<void> _loadStructures() async {
    await context.read<StructuresProvider>().loadStructures();
  }

  void _applyFilters() {
    final provider = context.read<StructuresProvider>();
    
    provider.filterStructures(
      searchQuery: _searchController.text.isEmpty
          ? null
          : _searchController.text,
      category: _selectedCategory,
      sortBy: _selectedSortOption,
    );
  }

  void _showSortDialog() {
    final provider = context.read<StructuresProvider>();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Trier par',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...provider.sortOptions.entries.map((entry) {
                return RadioListTile<String>(
                  title: Text(entry.value),
                  value: entry.key,
                  groupValue: _selectedSortOption ?? 'name_asc',
                  onChanged: (value) {
                    setState(() {
                      _selectedSortOption = value;
                    });
                    _applyFilters();
                    Navigator.pop(context);
                  },
                  activeColor: AppTheme.primaryColor,
                );
              }).toList(),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedSortOption = null;
                  });
                  _applyFilters();
                  Navigator.pop(context);
                },
                child: const Text('Réinitialiser le tri'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCategoryFilter() {
    final provider = context.read<StructuresProvider>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final categories = provider.allStructures
        .where((structure) => provider.hasAccessToStructure(structure.id))
        .expand((structure) => structure.categories)
        .toSet()
        .toList()
      ..insert(0, 'Toutes');

        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Catégories',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return RadioListTile<String>(
                      title: Text(category),
                      value: category,
                      groupValue: _selectedCategory ?? 'Toutes',
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value == 'Toutes' ? null : value;
                        });
                        _applyFilters();
                        Navigator.pop(context);
                      },
                      activeColor: AppTheme.primaryColor,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching ? _buildSearchField() : const Text('Structures'),
        actions: [
          if (!_isSearching) ...[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: _showCategoryFilter,
            ),
            IconButton(
              icon: const Icon(Icons.sort),
              onPressed: _showSortDialog,
            ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                  _applyFilters();
                });
              },
            ),
          ],
        ],
      ),
      body: Consumer<StructuresProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.allStructures.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(provider.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadStructures,
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          if (provider.allStructures.isEmpty) {
            return const Center(child: Text('Aucune structure disponible'));
          }

          return RefreshIndicator(
            onRefresh: _loadStructures,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
itemCount: provider.allStructures.length,
              itemBuilder: (context, index) {
                final structure = provider.allStructures[index];
                return _buildStructureCard(structure);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFilterOptions(),
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.filter_alt, color: Colors.white),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Rechercher une structure...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey[400]),
      ),
      style: const TextStyle(color: Colors.white),
      onSubmitted: (_) => _applyFilters(),
    );
  }

  Widget _buildStructureCard(Structure structure) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRouter.structureDetail,
            arguments: structure,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image de la structure
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Stack(
                children: [
                  // Image de la structure
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      structure.imageUrl ??
                          'https://via.placeholder.com/300x200?text=${structure.name}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.business,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  // Badge de catégorie
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        structure.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Bouton favori
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          structure.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: structure.isFavorite
                              ? Colors.red
                              : Colors.grey,
                        ),
                        onPressed: () {
                          context.read<StructuresProvider>().toggleFavorite(
                            structure.id,
                          );
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        iconSize: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Détails de la structure
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom et note
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          structure.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            structure.rating.toStringAsFixed(1),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' (${structure.reviewCount})',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Adresse
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          structure.address,
                          style: TextStyle(color: Colors.grey[700]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Bouton d'action
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRouter.structureDetail,
                              arguments: structure,
                            );
                          },
                          icon: const Icon(Icons.info_outline, size: 18),
                          label: const Text('Détails'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primaryColor,
                            side: BorderSide(color: AppTheme.primaryColor),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Gérer l'action de contact
                          },
                          icon: const Icon(Icons.phone, size: 18),
                          label: const Text('Contacter'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filtres',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 16),

                // Filtre par catégorie
                const Text(
                  'Catégorie',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Consumer<StructuresProvider>(
                  builder: (context, provider, _) {
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: provider.categories.map((category) {
                        final isSelected =
                            _selectedCategory == category ||
                            (_selectedCategory == null && category == 'Toutes');
                        return FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (context.mounted) {
                              setState(() {
                                _selectedCategory = selected
                                    ? (category == 'Toutes' ? null : category)
                                    : null;
                              });
                            }
                          },
                          backgroundColor: Colors.grey[200],
                          selectedColor: AppTheme.primaryColor.withOpacity(0.2),
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
                        );
                      }).toList(),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Boutons d'action
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setModalState(() {
                            _selectedCategory = null;
                            _selectedSortOption = null;
                            _searchController.clear();
                          });
                          _applyFilters();
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                        child: const Text('Réinitialiser'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _applyFilters();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Appliquer'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
