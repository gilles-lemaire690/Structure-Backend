import '/domain/entities/structure_entity.dart';

class StructureModel extends StructureEntity {
  StructureModel({
    required super.id,
    required super.name,
    required super.type,
    required super.location,
    required super.description,
    required super.imageUrl,
  });

  factory StructureModel.fromJson(Map<String, dynamic> json) {
    return StructureModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      location: json['location'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'location': location,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}