// lib/screens/services_products/service_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '/config/app_theme.dart';
import '/domain/entities/service_entity.dart';
import '/domain/usecases/get_services_by_structure_id_use_case.dart';

final servicesListProvider = FutureProvider.family<List<ServiceEntity>, String>((ref, structureId) async {
  final getServices = ref.watch(getServicesByStructureIdUseCaseProvider);
  return getServices.call(structureId);
});

class ServiceSelectionScreen extends ConsumerStatefulWidget {
  final String structureId;

  const ServiceSelectionScreen({super.key, required this.structureId});

  @override
  ConsumerState<ServiceSelectionScreen> createState() => _ServiceSelectionScreenState();
}

class _ServiceSelectionScreenState extends ConsumerState<ServiceSelectionScreen> {
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
    final servicesAsyncValue = ref.watch(servicesListProvider(widget.structureId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sélectionner un Service'),
        leading: IconButton( // Ajout de la flèche de retour
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop(); // Revient à la page précédente dans la pile de navigation
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Rechercher un service/produit',
                hintText: 'Nom ou description',
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
          Expanded(
            child: servicesAsyncValue.when(
              data: (services) {
                final filteredServices = services.where((service) {
                  final nameLower = service.name.toLowerCase();
                  final descriptionLower = service.description.toLowerCase();
                  final searchQueryLower = _searchQuery.toLowerCase();

                  return nameLower.contains(searchQueryLower) ||
                         descriptionLower.contains(searchQueryLower);
                }).toList();

                if (filteredServices.isEmpty && _searchQuery.isNotEmpty) {
                  return Center(
                    child: Text(
                      'Aucun service/produit trouvé pour "${_searchQuery}".',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.darkGrey),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else if (filteredServices.isEmpty && _searchQuery.isEmpty) {
                   return Center(
                    child: Text(
                      'Aucun service/produit disponible pour cette structure.',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.darkGrey),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: filteredServices.length,
                  itemBuilder: (context, index) {
                    final service = filteredServices[index];
                    return ServiceCard(service: service);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryBlue)),
              error: (error, stack) => Center(
                child: Text(
                  'Erreur de chargement des services: $error',
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

class ServiceCard extends StatelessWidget {
  final ServiceEntity service;

  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () {
          // MODIFIÉ : Utilise context.push() pour ajouter la page à la pile
          context.push('/payment-form', extra: service);
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                service.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8.0),
              Text(
                service.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.darkGrey.withOpacity(0.7),
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12.0),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  '${service.price.toStringAsFixed(0)} ${service.currency}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.accentBlue,
                      ),
                ),
              ),
              const SizedBox(height: 8.0),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // MODIFIÉ : Utilise context.push() pour ajouter la page à la pile
                    context.push('/payment-form', extra: service);
                  },
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Sélectionner'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}