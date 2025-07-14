// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Admin Dashboard';

  @override
  String helloAdmin(String name) {
    return 'Hello, $name!';
  }

  @override
  String get totalStructures => 'Total Structures';

  @override
  String get totalAdmins => 'Total Admins';

  @override
  String get paymentsToday => 'Payments Today';

  @override
  String get activeServices => 'Active Services';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get manageAdmins => 'Manage Admins';

  @override
  String get manageStructures => 'Manage Structures';

  @override
  String get viewAllPayments => 'View All Payments';

  @override
  String get logout => 'Logout';

  @override
  String get loginScreenTitle => 'Administrator Login';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get incorrectEmailPassword => 'Incorrect email or password.';

  @override
  String adminDashboardTitle(String structureName) {
    return 'Dashboard of $structureName';
  }

  @override
  String get totalPayments => 'Total Payments';

  @override
  String get transactions => 'Transactions';

  @override
  String get paymentHistory => 'Payment History';

  @override
  String get noPaymentsRecorded => 'No payments recorded for this structure.';

  @override
  String get paymentDetails => 'Payment Details';

  @override
  String get transactionId => 'Transaction ID:';

  @override
  String get amount => 'Amount:';

  @override
  String get date => 'Date:';

  @override
  String get paymentMethod => 'Payment Method:';

  @override
  String get clientInfo => 'Client Information';

  @override
  String get clientName => 'Client Name:';

  @override
  String get phoneNumber => 'Phone Number:';

  @override
  String get serviceProductInfo => 'Service/Product Information';

  @override
  String get serviceProduct => 'Service/Product:';

  @override
  String get downloadReceipt => 'Download Receipt';

  @override
  String get couldNotOpenReceipt => 'Could not open receipt. Check URL.';

  @override
  String get manageStructuresTitle => 'Manage Structures';

  @override
  String get noStructuresRecorded => 'No structures recorded yet.';

  @override
  String get addStructure => 'Add Structure';

  @override
  String get editStructure => 'Edit Structure';

  @override
  String get structureDeletedSuccessfully => 'Structure deleted successfully.';

  @override
  String get addAdministrator => 'Add Administrator';

  @override
  String get editAdministrator => 'Edit Administrator';

  @override
  String get fullName => 'Full Name';

  @override
  String get enterFullName => 'Please enter full name';

  @override
  String get enterEmail => 'Please enter email';

  @override
  String get validEmail => 'Please enter a valid email address';

  @override
  String get password => 'Password';

  @override
  String get newPasswordHint => 'New Password (leave empty if unchanged)';

  @override
  String get enterPassword => 'Please enter a password';

  @override
  String get attachedStructure => 'Attached Structure';

  @override
  String get selectStructure => 'Please select a structure';

  @override
  String get addAdministratorButton => 'Add Administrator';

  @override
  String get adminDeletedSuccessfully => 'Administrator deleted successfully.';

  @override
  String get noAdminsRecorded => 'No administrator recorded for now.';

  @override
  String get nameOfStructure => 'Name of Structure';

  @override
  String get enterStructureName => 'Please enter the name of the structure';

  @override
  String get typeOfStructure => 'Type of Structure';

  @override
  String get enterStructureType => 'Please enter the type of structure';

  @override
  String get location => 'Location';

  @override
  String get enterLocation => 'Please enter the location';

  @override
  String get contactEmailOptional => 'Contact E-mail (Optional)';

  @override
  String get contactPhoneOptional => 'Contact Phone (Optional)';

  @override
  String get addStructureButton => 'Add Structure';

  @override
  String get updateButton => 'Update';
}
