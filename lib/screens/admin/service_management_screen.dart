import 'package:flutter/material.dart';
import 'package:structure_front/l10n/app_localizations.dart';

class ServiceManagementScreen extends StatelessWidget {
  final String structureId;
  final String structureName;

  const ServiceManagementScreen({
    super.key,
    required this.structureId,
    required this.structureName,
  });

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text('${appLocalizations.manageServicesProducts} - $structureName'),
        backgroundColor: Colors.blue[900],
      ),
      body: Center(
        child: Text(appLocalizations.comingSoon),
      ),
    );
  }
}
