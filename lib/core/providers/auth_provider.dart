import 'package:flutter/material.dart';
import 'package:structure_mobile/core/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  String? _token;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _user != null && _token != null;
  bool get isAdmin => _user?.role == UserRole.admin || isSuperAdmin;
  bool get isSuperAdmin => _user?.role == UserRole.superAdmin;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Méthodes d'authentification
  Future<void> login(
    String email, 
    String password, 
    [bool isAdmin = false,
    bool isSuperAdmin = false]
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulation de délai pour la connexion
      await Future.delayed(const Duration(seconds: 1));
      
      // Vérification des identifiants
      UserRole role = UserRole.client;
      String? structureId;
      String firstName = '';
      String lastName = '';
      
      // Vérification des identifiants du super admin
      if (email == 'superadmin@example.com' && password == 'password') {
        role = UserRole.superAdmin;
        firstName = 'Super';
        lastName = 'Administrateur';
        structureId = null; // Le super admin n'a pas de structure assignée
      } 
      // Vérification des identifiants admin ANTIC
      else if (email == 'admin@antic.cm' && password == 'Antic@2023') {
        role = UserRole.admin;
        firstName = 'Admin';
        lastName = 'ANTIC';
        structureId = 'struct_antic_001';
      }
      // Vérification des identifiants admin MINADER
      else if (email == 'admin@minader.cm' && password == 'Minader@2023') {
        role = UserRole.admin;
        firstName = 'Admin';
        lastName = 'MINADER';
        structureId = 'struct_minader_001';
      }
      // Vérification des identifiants admin MINEPIA
      else if (email == 'admin@minepia.cm' && password == 'Minepia@2023') {
        role = UserRole.admin;
        firstName = 'Admin';
        lastName = 'MINEPIA';
        structureId = 'struct_minepia_001';
      }
      // Vérification des identifiants admin OBC
      else if (email == 'admin@obc.cm' && password == 'Obc@2023') {
        role = UserRole.admin;
        firstName = 'Admin';
        lastName = 'OBC';
        structureId = 'struct_obc_001';
      }
      // Vérification des identifiants admin DOUANE
      else if (email == 'admin@douane.cm' && password == 'Douane@2023') {
        role = UserRole.admin;
        firstName = 'Admin';
        lastName = 'DOUANE';
        structureId = 'struct_douane_001';
      }
      // Si on attend un admin/superadmin mais que les identifiants ne correspondent pas
      else if (isAdmin || isSuperAdmin) {
        throw Exception('''Identifiants administrateur invalides. Utilisez :
- superadmin@example.com / password (super admin)
- admin@antic.cm / Antic@2023 (admin ANTIC)
- admin@minader.cm / Minader@2023 (admin MINADER)
- admin@minepia.cm / Minepia@2023 (admin MINEPIA)
- admin@obc.cm / Obc@2023 (admin OBC)
- admin@douane.cm / Douane@2023 (admin DOUANE)''');
      }
      // Si c'est une connexion utilisateur standard (non utilisé pour l'instant)
      else {
        role = UserRole.client;
        firstName = 'Utilisateur';
        lastName = 'Standard';
      }
      
      // Création de l'utilisateur
      _user = User(
        id: 'user_${email.replaceAll('@', '_').replaceAll('.', '_')}',
        email: email,
        firstName: firstName,
        lastName: lastName,
        role: role,
        structureId: structureId,
      );
      
      _token = 'token_${_user!.id}_${DateTime.now().millisecondsSinceEpoch}';
      
      debugPrint('Connexion réussie: ${_user?.email} (${_user?.role})');
      if (structureId != null) {
        debugPrint('Structure associée: $structureId');
      }
      
    } catch (e) {
      _error = e.toString().contains('Exception: ') 
          ? e.toString().replaceAll('Exception: ', '') 
          : 'Échec de la connexion. Veuillez réessayer.';
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String email, String password, String firstName, String lastName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implémenter l'appel API d'inscription
      await Future.delayed(const Duration(seconds: 2)); // Simulation de délai
      
      // Simulation d'une inscription réussie
      _user = User(
        id: '1',
        email: email,
        firstName: firstName,
        lastName: lastName,
        role: UserRole.client,
      );
      _token = 'simulated_token';
      
      // TODO: Sauvegarder le token et les infos utilisateur localement
      
    } catch (e) {
      _error = 'Échec de l\'inscription. Veuillez réessayer.';
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      // TODO: Implémenter la déconnexion côté serveur
      await Future.delayed(const Duration(milliseconds: 300)); // Simulation de délai
      debugPrint('Utilisateur déconnecté');
    } finally {
      _user = null;
      _token = null;
      _error = null;
      notifyListeners();
    }
  }

  Future<bool> tryAutoLogin() async {
    // TODO: Vérifier si un token existe en local et le valider
    await Future.delayed(const Duration(seconds: 1)); // Simulation de délai
    return false; // Pour l'instant, on retourne toujours faux
  }
}
