// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Tableau de Bord Admin';

  @override
  String helloAdmin(String name) {
    return 'Bonjour, $name !';
  }

  @override
  String get totalStructures => 'Total Structures';

  @override
  String get totalAdmins => 'Total Admins';

  @override
  String get paymentsToday => 'Paiements Aujourd\'hui';

  @override
  String get activeServices => 'Services Actifs';

  @override
  String get quickActions => 'Actions Rapides';

  @override
  String get manageAdmins => 'Gérer les Admins';

  @override
  String get manageStructures => 'Gérer les Structures';

  @override
  String get viewAllPayments => 'Voir tous les Paiements';

  @override
  String get logout => 'Déconnexion';

  @override
  String get loginScreenTitle => 'Connexion Administrateur';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get signIn => 'Se connecter';

  @override
  String get incorrectEmailPassword => 'E-mail ou mot de passe incorrect.';

  @override
  String adminDashboardTitle(String structureName) {
    return 'Tableau de Bord de $structureName';
  }

  @override
  String get totalPayments => 'Paiements Totaux';

  @override
  String get transactions => 'Transactions';

  @override
  String get paymentHistory => 'Historique des Paiements';

  @override
  String get noPaymentsRecorded =>
      'Aucun paiement enregistré pour cette structure.';

  @override
  String get paymentDetails => 'Détails du Paiement';

  @override
  String get transactionId => 'ID de Transaction:';

  @override
  String get amount => 'Montant:';

  @override
  String get date => 'Date:';

  @override
  String get paymentMethod => 'Méthode de Paiement:';

  @override
  String get clientInfo => 'Informations du Client';

  @override
  String get clientName => 'Nom du Client:';

  @override
  String get phoneNumber => 'Numéro de Téléphone:';

  @override
  String get serviceProductInfo => 'Informations Service/Produit';

  @override
  String get serviceProduct => 'Service/Produit:';

  @override
  String get downloadReceipt => 'Télécharger le Reçu';

  @override
  String get couldNotOpenReceipt =>
      'Impossible d\'ouvrir le reçu. Vérifiez l\'URL.';

  @override
  String get manageStructuresTitle => 'Gérer les Structures';

  @override
  String get noStructuresRecorded =>
      'Aucune structure enregistrée pour l\'instant.';

  @override
  String get addStructure => 'Ajouter une Structure';

  @override
  String get editStructure => 'Modifier la Structure';

  @override
  String get structureDeletedSuccessfully => 'Structure supprimée avec succès.';

  @override
  String get addAdministrator => 'Ajouter un Administrateur';

  @override
  String get editAdministrator => 'Modifier l\'Administrateur';

  @override
  String get fullName => 'Nom Complet';

  @override
  String get enterFullName => 'Veuillez entrer le nom complet';

  @override
  String get enterEmail => 'Veuillez entrer l\'e-mail';

  @override
  String get validEmail => 'Veuillez entrer une adresse e-mail valide';

  @override
  String get password => 'Mot de passe';

  @override
  String get newPasswordHint =>
      'Nouveau Mot de passe (laisser vide si inchangé)';

  @override
  String get enterPassword => 'Veuillez entrer un mot de passe';

  @override
  String get attachedStructure => 'Structure Rattachée';

  @override
  String get selectStructure => 'Veuillez sélectionner une structure';

  @override
  String get addAdministratorButton => 'Ajouter l\'Administrateur';

  @override
  String get adminDeletedSuccessfully => 'Administrateur supprimé avec succès.';

  @override
  String get noAdminsRecorded =>
      'Aucun administrateur enregistré pour l\'instant.';

  @override
  String get nameOfStructure => 'Nom de la Structure';

  @override
  String get enterStructureName => 'Veuillez entrer le nom de la structure';

  @override
  String get typeOfStructure => 'Type de Structure';

  @override
  String get enterStructureType => 'Veuillez entrer le type de structure';

  @override
  String get location => 'Localisation';

  @override
  String get enterLocation => 'Veuillez entrer la localisation';

  @override
  String get contactEmailOptional => 'E-mail de Contact (Optionnel)';

  @override
  String get contactPhoneOptional => 'Téléphone de Contact (Optionnel)';

  @override
  String get addStructureButton => 'Ajouter la Structure';

  @override
  String get updateButton => 'Mettre à jour';
}
