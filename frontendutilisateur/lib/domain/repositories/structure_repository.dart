import '/domain/entities/structure_entity.dart';
import '/domain/entities/service_entity.dart';

abstract class StructureRepository {
  Future<List<StructureEntity>> getStructures();
  Future<StructureEntity?> getStructureById(String id);
  Future<List<ServiceEntity>> getServicesByStructureId(String structureId);
}
