// lib/screens/structures/structures_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '/config/app_theme.dart';
import '/domain/entities/structure_entity.dart';
import '/domain/usecases/get_structures_use_case.dart';

final structuresListProvider = FutureProvider<List<StructureEntity>>((ref) async {
  final getStructures = ref.watch(getStructuresUseCaseProvider);
  return getStructures.call();
});

class StructuresListScreen extends ConsumerStatefulWidget {
  const StructuresListScreen({super.key});

  @override
  ConsumerState<StructuresListScreen> createState() => _StructuresListScreenState();
}

class _StructuresListScreenState extends ConsumerState<StructuresListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Surveille l'état du provider de la liste des structures
    final structuresAsyncValue = ref.watch(structuresListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Structures au Cameroun'),
       
      ),
      body: Column( // Utilise une colonne pour le champ de recherche et la liste
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Rechercher une structure',
                hintText: 'Nom, type ou localisation',
                prefixIcon: const Icon(Icons.search, color: AppColors.primaryBlue),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.darkGrey),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
            child: Text(
              'Découvrez nos structures partenaires',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.darkGrey,
              ),
            ),
          ),
          Expanded( // Permet au ListView.builder de prendre l'espace restant
            child: structuresAsyncValue.when(
              data: (structures) {
                // Filtrer les structures en fonction de la requête de recherche
                final filteredStructures = structures.where((structure) {
                  final nameLower = structure.name.toLowerCase();
                  final typeLower = structure.type.toLowerCase();
                  final locationLower = structure.location.toLowerCase();
                  final searchQueryLower = _searchQuery.toLowerCase();

                  return nameLower.contains(searchQueryLower) ||
                         typeLower.contains(searchQueryLower) ||
                         locationLower.contains(searchQueryLower);
                }).toList();

                if (filteredStructures.isEmpty && _searchQuery.isNotEmpty) {
                  return Center(
                    child: Text(
                      'Aucune structure trouvée pour "${_searchQuery}".',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.darkGrey),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else if (filteredStructures.isEmpty && _searchQuery.isEmpty) {
                   return Center(
                    child: Text(
                      'Aucune structure disponible pour le moment.',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.darkGrey),
                    ),
                  );
                }

                return ListView.builder( // Revenir à ListView.builder
                  padding: const EdgeInsets.all(16.0),
                  itemCount: filteredStructures.length,
                  itemBuilder: (context, index) {
                    final structure = filteredStructures[index];
                    return StructureCard(structure: structure); // Utilise la liste filtrée
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryBlue)),
              error: (error, stack) => Center(
                child: Text(
                  'Erreur de chargement: $error',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StructureCard extends StatelessWidget {
  final StructureEntity structure;

  const StructureCard({super.key, required this.structure});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0), // Marge pour les cartes verticales
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        onTap: () {
          // MODIFIÉ : Utilise context.push() pour ajouter la page à la pile
          context.push('/structures/${structure.id}');
        },
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  structure.imageUrl,
                  height: 180, // Hauteur ajustée pour la carte verticale
                  width: double.infinity,
                  fit: BoxFit.cover,
                  // AJOUTÉ : Optimisation du chargement d'image
                  cacheWidth: 720, // Cache l'image à une largeur de 720 pixels
                  cacheHeight: 360, // Cache l'image à une hauteur de 360 pixels
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 180,
                      width: double.infinity,
                      color: AppColors.lightGrey,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      width: double.infinity,
                      color: AppColors.lightGrey,
                      child: Center(
                        child: Icon(Icons.broken_image, color: AppColors.darkGrey.withOpacity(0.6), size: 50),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12.0),
              Text(
                structure.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4.0),
              Text(
                structure.type,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.darkGrey.withOpacity(0.8),
                    ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(Icons.location_on, size: 18, color: AppColors.accentBlue),
                  const SizedBox(width: 4.0),
                  Expanded(
                    child: Text(
                      structure.location,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.darkGrey,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text( // Retiré l'Expanded ici pour le ListView vertical
                structure.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.darkGrey.withOpacity(0.7),
                    ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12.0),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // MODIFIÉ : Utilise context.push() pour ajouter la page à la pile
                    context.push('/structures/${structure.id}');
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Voir Détails'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
