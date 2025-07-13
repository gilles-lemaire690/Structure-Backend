// lib/models/service_product.dart
class ServiceProduct {
  final String id;
  final String name;
  final String description;
  final double price;
  final String structureId; // L'ID de la structure qui offre ce service/produit

  ServiceProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.structureId,
  });
}
