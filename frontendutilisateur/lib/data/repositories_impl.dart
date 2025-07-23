import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/data/local_json_data_source.dart';
import '/domain/entities/structure_entity.dart';
import '/domain/entities/service_entity.dart';
import '/domain/repositories/structure_repository.dart';

final localJsonDataSourceProvider = Provider<LocalJsonDataSource>((ref) {
  return LocalJsonDataSource();
});

// Provider pour le repository des structures
final structureRepositoryProvider = Provider<StructureRepository>((ref) {
  final dataSource = ref.watch(localJsonDataSourceProvider);
  return StructureRepositoryImpl(dataSource);
});

class StructureRepositoryImpl implements StructureRepository {
  final LocalJsonDataSource _dataSource;

  StructureRepositoryImpl(this._dataSource);

  @override
  Future<List<StructureEntity>> getStructures() async {
    final models = await _dataSource.getStructures();
    return models; // Les StructureModel sont aussi des StructureEntity
  }

  @override
  Future<StructureEntity?> getStructureById(String id) async {
    final models = await _dataSource.getStructures();
    try {
      return models.firstWhere((structure) => structure.id == id);
    } catch (e) {
      print('Structure with ID $id not found: $e');
      return null;
    }
  }

  @override
  Future<List<ServiceEntity>> getServicesByStructureId(String structureId) async {
    final models = await _dataSource.getServicesByStructureId(structureId);
    return models; // Les ServiceModel sont aussi des ServiceEntity
  }
}