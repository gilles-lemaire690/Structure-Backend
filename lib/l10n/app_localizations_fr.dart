// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Structure Front';

  @override
  String get loginScreenTitle => 'Connexion Administrateur';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get signIn => 'Se connecter';

  @override
  String helloAdmin(Object name) {
    return 'Bienvenue, $name!';
  }

  @override
  String get quickActions => 'Actions Rapides';

  @override
  String get paymentHistory => 'Historique des Paiements';

  @override
  String get noPaymentsRecorded => 'Aucun paiement enregistré';

  @override
  String get amount => 'Montant';

  @override
  String get paymentMethod => 'Méthode de paiement';

  @override
  String get date => 'Date';

  @override
  String get logout => 'Déconnexion';

  @override
  String get viewAllPayments => 'Voir tous les paiements';

  @override
  String get language => 'Langue';

  @override
  String get english => 'English';

  @override
  String get french => 'Français';

  @override
  String get structureManagement => 'Gestion des Structures';

  @override
  String get totalPayments => 'Paiements Totaux';

  @override
  String get transactions => 'Transactions';

  @override
  String get manageServicesProducts => 'Gérer les Services & Produits';

  @override
  String get adminDeletedSuccessfully => 'Administrateur supprimé avec succès';

  @override
  String get manageAdmins => 'Gérer les Administrateurs';

  @override
  String get noAdminsRecorded => 'Aucun administrateur enregistré';

  @override
  String get attachedStructure => 'Structure Attachée';

  @override
  String get selectStructure => 'Sélectionner une Structure';

  @override
  String get addAdministrator => 'Ajouter un Administrateur';

  @override
  String get editAdministrator => 'Modifier l\'Administrateur';

  @override
  String get fullName => 'Nom Complet';

  @override
  String get enterFullName => 'Veuillez entrer votre nom complet';

  @override
  String get enterEmail => 'Veuillez entrer votre email';

  @override
  String get validEmail => 'Veuillez entrer un email valide';

  @override
  String get password => 'Mot de passe';

  @override
  String get newPasswordHint =>
      'Nouveau mot de passe (laisser vide pour conserver le mot de passe actuel)';

  @override
  String get enterPassword => 'Veuillez entrer votre mot de passe';

  @override
  String get addAdministratorButton => 'Ajouter un Administrateur';

  @override
  String get updateButton => 'Mettre à jour';

  @override
  String get structureDeletedSuccessfully => 'Structure supprimée avec succès';

  @override
  String get manageStructuresTitle => 'Gérer les Structures';

  @override
  String get noStructuresRecorded => 'Aucune structure enregistrée';

  @override
  String get enterStructureName => 'Veuillez entrer le nom de la structure';

  @override
  String get enterStructureType => 'Veuillez sélectionner le type de structure';

  @override
  String get enterLocation => 'Veuillez entrer l\'emplacement';

  @override
  String get couldNotOpenReceipt => 'Impossible d\'ouvrir le reçu';

  @override
  String get paymentDetails => 'Détails du Paiement';

  @override
  String get transactionId => 'ID de Transaction';

  @override
  String get clientInfo => 'Informations du Client';

  @override
  String get clientName => 'Nom du Client';

  @override
  String get phoneNumber => 'Numéro de Téléphone';

  @override
  String get serviceProductInfo => 'Informations Service/Produit';

  @override
  String get serviceProduct => 'Service/Produit';

  @override
  String get downloadReceipt => 'Télécharger le Reçu';

  @override
  String get comingSoon => 'À venir';
}
