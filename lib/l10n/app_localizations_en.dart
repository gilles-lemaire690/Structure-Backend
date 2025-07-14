// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Structure Front';

  @override
  String get loginScreenTitle => 'Administrator Login';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get signIn => 'Sign In';

  @override
  String helloAdmin(Object name) {
    return 'Welcome, $name!';
  }

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get paymentHistory => 'Payment History';

  @override
  String get noPaymentsRecorded => 'No payments recorded';

  @override
  String get amount => 'Amount';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get date => 'Date';

  @override
  String get logout => 'Logout';

  @override
  String get viewAllPayments => 'View All Payments';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get french => 'French';

  @override
  String get structureManagement => 'Structure Management';

  @override
  String get totalPayments => 'Total Payments';

  @override
  String get transactions => 'Transactions';

  @override
  String get manageServicesProducts => 'Manage Services & Products';

  @override
  String get adminDeletedSuccessfully => 'Administrator deleted successfully';

  @override
  String get manageAdmins => 'Manage Administrators';

  @override
  String get noAdminsRecorded => 'No administrators recorded';

  @override
  String get attachedStructure => 'Attached Structure';

  @override
  String get selectStructure => 'Select Structure';

  @override
  String get addAdministrator => 'Add Administrator';

  @override
  String get editAdministrator => 'Edit Administrator';

  @override
  String get fullName => 'Full Name';

  @override
  String get enterFullName => 'Please enter your full name';

  @override
  String get enterEmail => 'Please enter your email';

  @override
  String get validEmail => 'Please enter a valid email';

  @override
  String get password => 'Password';

  @override
  String get newPasswordHint =>
      'New Password (leave empty to keep current password)';

  @override
  String get enterPassword => 'Please enter your password';

  @override
  String get addAdministratorButton => 'Add Administrator';

  @override
  String get updateButton => 'Update';

  @override
  String get structureDeletedSuccessfully => 'Structure deleted successfully';

  @override
  String get manageStructuresTitle => 'Manage Structures';

  @override
  String get noStructuresRecorded => 'No structures recorded';

  @override
  String get enterStructureName => 'Please enter the structure name';

  @override
  String get enterStructureType => 'Please select the structure type';

  @override
  String get enterLocation => 'Please enter the location';

  @override
  String get couldNotOpenReceipt => 'Could not open receipt';

  @override
  String get paymentDetails => 'Payment Details';

  @override
  String get transactionId => 'Transaction ID';

  @override
  String get clientInfo => 'Client Information';

  @override
  String get clientName => 'Client Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get serviceProductInfo => 'Service/Product Information';

  @override
  String get serviceProduct => 'Service/Product';

  @override
  String get downloadReceipt => 'Download Receipt';

  @override
  String get comingSoon => 'Coming Soon';
}
