import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '/config/app_theme.dart';
import '/domain/entities/structure_entity.dart';
import '/domain/usecases/get_structure_by_id_use_case.dart';

final structureDetailProvider = FutureProvider.family<StructureEntity?, String>((ref, structureId) async {
  final getStructureById = ref.watch(getStructureByIdUseCaseProvider);
  return getStructureById.call(structureId);
});

class StructureDetailScreen extends ConsumerWidget {
  final String structureId;

  const StructureDetailScreen({super.key, required this.structureId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final structureAsyncValue = ref.watch(structureDetailProvider(structureId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la Structure'),
        leading: IconButton( // Ajout de la flèche de retour
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop(); // Revient à la page précédente dans la pile de navigation
          },
        ),
      ),
      body: structureAsyncValue.when(
        data: (structure) {
          if (structure == null) {
            return Center(
              child: Text(
                'Structure non trouvée.',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.darkGrey),
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    structure.imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 250,
                        width: double.infinity,
                        color: AppColors.lightGrey,
                        child: Center(
                          child: Icon(Icons.broken_image, color: AppColors.darkGrey.withOpacity(0.6), size: 70),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24.0),
                Text(
                  structure.name,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                      ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  structure.type,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.darkGrey.withOpacity(0.8),
                      ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 20, color: AppColors.accentBlue),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        structure.location,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.darkGrey,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Description:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGrey,
                      ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  structure.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.darkGrey.withOpacity(0.7),
                        height: 1.5,
                      ),
                ),
                const SizedBox(height: 32.0),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // MODIFIÉ : Utilise context.push() pour ajouter la page à la pile
                      context.push('/structures/${structure.id}/services');
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Sélectionner Services/Produits'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryBlue)),
        error: (error, stack) => Center(
          child: Text(
            'Erreur de chargement des détails: $error',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
