import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendutilisateur/data/repositories_impl.dart';
import 'package:frontendutilisateur/domain/entities/structure_entity.dart';
import 'package:frontendutilisateur/domain/repositories/structure_repository.dart';

final getStructureByIdUseCaseProvider = Provider<GetStructureByIdUseCase>((ref) {
  final repository = ref.watch(structureRepositoryProvider);
  return GetStructureByIdUseCase(repository);
});

class GetStructureByIdUseCase {
  final StructureRepository _repository;

  GetStructureByIdUseCase(this._repository);

  Future<StructureEntity?> call(String id) async {
    return _repository.getStructureById(id);
  }
}