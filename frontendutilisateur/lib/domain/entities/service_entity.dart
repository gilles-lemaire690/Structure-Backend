class ServiceEntity {
  final String id;
  final String structureId;
  final String name;
  final String description;
  final double price;
  final String currency;

  ServiceEntity({
    required this.id,
    required this.structureId,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceEntity &&
          runtimeType == other.runtimeType &&
          id == other.id);

  @override
  int get hashCode => id.hashCode;
}