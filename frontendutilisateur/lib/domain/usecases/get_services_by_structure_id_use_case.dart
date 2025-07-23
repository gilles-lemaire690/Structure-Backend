import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendutilisateur/data/repositories_impl.dart';
import 'package:frontendutilisateur/domain/entities/service_entity.dart';
import 'package:frontendutilisateur/domain/repositories/structure_repository.dart';

final getServicesByStructureIdUseCaseProvider = Provider<GetServicesByStructureIdUseCase>((ref) {
  final repository = ref.watch(structureRepositoryProvider);
  return GetServicesByStructureIdUseCase(repository);
});

class GetServicesByStructureIdUseCase {
  final StructureRepository _repository;

  GetServicesByStructureIdUseCase(this._repository);

  Future<List<ServiceEntity>> call(String structureId) async {
    return _repository.getServicesByStructureId(structureId);
  }
}