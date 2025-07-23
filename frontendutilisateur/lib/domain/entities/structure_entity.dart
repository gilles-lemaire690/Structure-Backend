// lib/domain/entities/structure_entity.dart
// Cette entité représente l'objet métier pur, indépendant de la source de données.
class StructureEntity {
  final String id;
  final String name;
  final String type;
  final String location;
  final String description;
  final String imageUrl;

  StructureEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.description,
    required this.imageUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StructureEntity &&
          runtimeType == other.runtimeType &&
          id == other.id);

  @override
  int get hashCode => id.hashCode;
}