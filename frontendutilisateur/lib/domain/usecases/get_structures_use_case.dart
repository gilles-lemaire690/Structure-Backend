import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/domain/entities/structure_entity.dart';
import '/domain/repositories/structure_repository.dart';
import '/data/repositories_impl.dart'; // Importez l'implémentation

final getStructuresUseCaseProvider = Provider<GetStructuresUseCase>((ref) {
  final repository = ref.watch(structureRepositoryProvider);
  return GetStructuresUseCase(repository);
});

class GetStructuresUseCase {
  final StructureRepository _repository;

  GetStructuresUseCase(this._repository);

  Future<List<StructureEntity>> call() async {
    return _repository.getStructures();
  }
}