import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '/models/structure_model.dart';
import '/models/service_model.dart';

class LocalJsonDataSource {
  // Charge toutes les structures depuis le fichier JSON
  Future<List<StructureModel>> getStructures() async {
    try {
      final String response = await rootBundle.loadString('assets/structures.json');
      final List<dynamic> data = json.decode(response);
      return data.map((json) => StructureModel.fromJson(json)).toList();
    } catch (e) {
      // En cas d'erreur de lecture ou de parsing
      print('Erreur lors du chargement des structures: $e');
      return [];
    }
  }

  // Charge tous les services depuis le fichier JSON
  Future<List<ServiceModel>> getServices() async {
    try {
      final String response = await rootBundle.loadString('assets/services.json');
      final List<dynamic> data = json.decode(response);
      return data.map((json) => ServiceModel.fromJson(json)).toList();
    } catch (e) {
      // En cas d'erreur de lecture ou de parsing
      print('Erreur lors du chargement des services: $e');
      return [];
    }
  }

  // Charge les services pour une structure spécifique
  Future<List<ServiceModel>> getServicesByStructureId(String structureId) async {
    final allServices = await getServices();
    return allServices.where((service) => service.structureId == structureId).toList();
  }
}
