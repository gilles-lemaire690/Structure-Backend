import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:structure_mobile/features/admin/models/dashboard_stats.dart';
import 'package:structure_mobile/features/structures/models/structure_model.dart';
import 'package:structure_mobile/features/structures/data/structure_data.dart';
import 'package:structure_mobile/features/auth/models/user_model.dart';

class DashboardProvider extends ChangeNotifier {
  DashboardStats _stats = DashboardStats.demo();
  bool _isLoading = false;
  String? _error;
  DateTimeRange _selectedDateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );
  String _activeTab = 'overview';
  
  // Getters
  DashboardStats get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTimeRange get selectedDateRange => _selectedDateRange;
  String get activeTab => _activeTab;
  
  // Changer l'onglet actif
  void setActiveTab(String tabId) {
    _activeTab = tabId;
    notifyListeners();
  }
  
  // Mettre à jour la plage de dates sélectionnée
  Future<void> updateDateRange(DateTimeRange newRange) async {
    _selectedDateRange = newRange;
    // Ici, vous pourriez recharger les données avec la nouvelle plage de dates
    // Pour l'instant, nous utilisons des données de démo
    await loadDashboardData();
  }
  
  // Liste des structures et utilisateurs pour le tableau de bord
  List<Structure> _structures = [];
  List<User> _users = [];
  
  // Getters pour les listes
  List<Structure> get structures => _structures;
  List<User> get users => _users;
  
  // Charger les structures avec filtres
  Future<void> loadStructures({
    String? status,
    String? searchQuery,
    String? sortBy,
    String? structureId, // Nouveau paramètre pour filtrer par structure
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      // Simulation de chargement depuis une API
      await Future.delayed(const Duration(seconds: 1));
      
      // Utiliser les structures réelles depuis structure_data.dart
      _structures = List<Structure>.from(StructureData.structures);
      
      // Filtrer par structure si un ID est fourni
      if (structureId != null && structureId.isNotEmpty) {
        _structures = _structures.where((s) => s.id == structureId).toList();
        debugPrint('Filtrage des structures - Seule la structure $structureId est affichée');
      }
      
      // Appliquer les autres filtres
      if (status != null && status != 'all') {
        _structures = _structures.where((s) => s.status == status).toList();
      }
      
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        _structures = _structures.where((s) {
          final nameMatch = s.name.toLowerCase().contains(query);
          final description = s.description ?? '';
          final descMatch = description.toLowerCase().contains(query);
          return nameMatch || descMatch;
        }).toList();
      }
      
      // Appliquer le tri
      _sortStructures(sortBy);
      
      debugPrint('${_structures.length} structures chargées avec succès');
      
    } catch (e) {
      _error = 'Erreur lors du chargement des structures';
      log('Erreur loadStructures: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Trier les structures
  void _sortStructures(String? sortBy) {
    switch (sortBy) {
      case 'newest':
        _structures.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'oldest':
        _structures.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'name_asc':
        _structures.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'name_desc':
        _structures.sort((a, b) => b.name.compareTo(a.name));
        break;
      default:
        _structures.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
  }
  
  // Charger les utilisateurs avec filtres
  Future<void> loadUsers({
    String? status,
    String? role,
    String? searchQuery,
    String? sortBy,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      // Simulation de chargement depuis une API
      await Future.delayed(const Duration(seconds: 1));
      
      // En production, vous feriez quelque chose comme :
      // final response = await api.getUsers(
      //   status: status,
      //   role: role,
      //   search: searchQuery,
      //   sort: sortBy,
      // );
      // _users = response.map((json) => User.fromJson(json)).toList();
      
      // Données de démo
      _users = List.generate(10, (index) => User.demo());
      
      // Appliquer les filtres localement (pour la démo)
      if (status != null && status != 'all') {
        _users = _users.where((u) => u.status == status).toList();
      }
      
      if (role != null && role != 'all') {
        _users = _users.where((u) => u.role == role).toList();
      }
      
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        _users = _users.where((u) => 
          u.name.toLowerCase().contains(query) ||
          u.email.toLowerCase().contains(query)
        ).toList();
      }
      
      // Appliquer le tri
      _sortUsers(sortBy);
      
    } catch (e) {
      _error = 'Erreur lors du chargement des utilisateurs';
      log('Erreur loadUsers: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Trier les utilisateurs
  void _sortUsers(String? sortBy) {
    switch (sortBy) {
      case 'newest':
        _users.sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
        break;
      case 'oldest':
        _users.sort((a, b) => (a.createdAt ?? DateTime(0)).compareTo(b.createdAt ?? DateTime(0)));
        break;
      case 'name_asc':
        _users.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
        break;
      case 'name_desc':
        _users.sort((a, b) => (b.name ?? '').compareTo(a.name ?? ''));
        break;
      default:
        _users.sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
    }
  }
  
  // Charger les données du tableau de bord
  Future<void> loadDashboardData() async {
    if (_isLoading) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      // Simulation de chargement depuis une API
      await Future.delayed(const Duration(seconds: 1));
      
      // En production, vous feriez quelque chose comme :
      // final response = await api.getDashboardData(selectedDateRange);
      // _stats = DashboardStats.fromJson(response.data);
      
      // Pour l'instant, nous utilisons des données de démo
      _stats = DashboardStats.demo();
      
    } catch (e) {
      _error = 'Impossible de charger les données du tableau de bord. Veuillez réessayer.';
      debugPrint('Erreur lors du chargement du tableau de bord: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Rafraîchir les données
  Future<void> refreshData() async {
    await loadDashboardData();
  }
  
  // Méthode privée pour le chargement des données - supprimée car redondante avec loadDashboardData()
  
  // Autres méthodes pour gérer les actions du tableau de bord
  Future<void> approveStructure(String structureId) async {
    // Implémenter la logique d'approbation d'une structure
    await Future.delayed(const Duration(seconds: 1));
    // Mettre à jour les données locales si nécessaire
    notifyListeners();
  }
  
  Future<void> rejectStructure(String structureId, String reason) async {
    // Implémenter la logique de rejet d'une structure
    await Future.delayed(const Duration(seconds: 1));
    // Mettre à jour les données locales si nécessaire
    notifyListeners();
  }
  
  // Méthodes pour la gestion des utilisateurs
  Future<void> suspendUser(String userId) async {
    // Implémenter la logique de suspension d'un utilisateur
    await Future.delayed(const Duration(seconds: 1));
    // Mettre à jour les données locales si nécessaire
    notifyListeners();
  }
  
  // Méthodes pour les rapports
  Future<Map<String, dynamic>> generateReport(DateTimeRange dateRange) async {
    // Générer un rapport pour la plage de dates spécifiée
    await Future.delayed(const Duration(seconds: 2));
    
    // Retourner des données de démo
    return {
      'totalRevenue': 2500000,
      'newStructures': 24,
      'newUsers': 56,
      'topPerformingCategory': 'Restauration',
      'revenueByCategory': {
        'Restauration': 1200000,
        'Hébergement': 800000,
        'Santé': 300000,
        'Autres': 200000,
      },
    };
  }
}
