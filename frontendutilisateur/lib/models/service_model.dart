import '/domain/entities/service_entity.dart';

class ServiceModel extends ServiceEntity {
  ServiceModel({
    required super.id,
    required super.structureId,
    required super.name,
    required super.description,
    required super.price,
    required super.currency,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String,
      structureId: json['structureId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(), // Gère int ou double
      currency: json['currency'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'structureId': structureId,
      'name': name,
      'description': description,
      'price': price,
      'currency': currency,
    };
  }
}
