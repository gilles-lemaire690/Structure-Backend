import 'package:flutter/material.dart';
import 'package:structure_front/l10n/app_localizations.dart';
import 'package:structure_front/models/structure.dart';


// --- Modèle de données pour un administrateur (MIS À JOUR) ---
class Admin {
  final String id;
  final String name;
  final String email;
  final String structureId;
  final String structureName;

  Admin({
    required this.id,
    required this.name,
    required this.email,
    required this.structureId,
    required this.structureName,
  });
}

class AdminManagementScreen extends StatefulWidget {
  const AdminManagementScreen({super.key});

  @override
  State<AdminManagementScreen> createState() => _AdminManagementScreenState();
}

class _AdminManagementScreenState extends State<AdminManagementScreen> {
  // Liste simulée d'administrateurs (MIS À JOUR AVEC structureId)
  List<Admin> _admins = [
    Admin(id: '1', name: 'Jean Dupont', email: 'jean.dupont@example.com', structureId: 'S001', structureName: 'Hôpital Central'),
    Admin(id: '2', name: 'Marie Curie', email: 'marie.curie@example.com', structureId: 'S002', structureName: 'École Primaire Biyem-Assi'),
    Admin(id: '3', name: 'Paul Toko', email: 'paul.toko@example.com', structureId: 'S003', structureName: 'Supermarché CamGros'),
  ];

  // Liste simulée des structures disponibles (CETTE LISTE SERAIT GÉRÉE PAR LE SUPER ADMIN EN VRAI)
  // Pour l'instant, c'est une donnée statique pour le front-end.
  List<Structure> _availableStructures = [
    Structure(id: 'S001', name: 'Hôpital Central', type: 'Santé', location: 'Yaoundé'),
    Structure(id: 'S002', name: 'École Primaire Biyem-Assi', type: 'Éducation', location: 'Douala'),
    Structure(id: 'S003', name: 'Supermarché CamGros', type: 'Commerce', location: 'Bafoussam'),
    Structure(id: 'S004', name: 'Centre Sportif Elite', type: 'Sport', location: 'Yaoundé'),
    Structure(id: 'S005', name: 'Librairie Savoir', type: 'Commerce', location: 'Limbe'),
  ];

  void _addAdmin() {
    print('Ajouter un nouvel Admin');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AdminFormScreen(
          onSave: (newAdmin) {
            setState(() {
              _admins.add(newAdmin);
            });
            Navigator.of(context).pop(); // Revenir à la liste après ajout
          },
          availableStructures: _availableStructures, // PASSER LA LISTE DES STRUCTURES
        ),
      ),
    );
  }

  void _editAdmin(Admin admin) {
    print('Modifier l\'Admin: ${admin.name}');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AdminFormScreen(
          admin: admin, // Passe l'admin à modifier
          onSave: (updatedAdmin) {
            setState(() {
              int index = _admins.indexWhere((a) => a.id == updatedAdmin.id);
              if (index != -1) {
                _admins[index] = updatedAdmin;
              }
            });
            Navigator.of(context).pop(); // Revenir à la liste après modification
          },
          availableStructures: _availableStructures, // PASSER LA LISTE DES STRUCTURES
        ),
      ),
    );
  }

  void _deleteAdmin(String id) {
    setState(() {
      _admins.removeWhere((admin) => admin.id == id);
      print('Admin avec ID $id supprimé.');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.adminDeletedSuccessfully)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!; // Access translations

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          appLocalizations.manageAdmins,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey[700],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _admins.isEmpty
          ? Center(
              child: Text(
                appLocalizations.noAdminsRecorded, // Translated text
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _admins.length,
              itemBuilder: (context, index) {
                final admin = _admins[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                admin.name,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                admin.email,
                                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${appLocalizations.attachedStructure}: ${admin.structureName}', // Translated text
                                style: TextStyle(fontSize: 14, color: Colors.blueGrey[600]),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blueGrey),
                          onPressed: () => _editAdmin(admin),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => _deleteAdmin(admin.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAdmin,
        backgroundColor: Colors.blueGrey[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}


// --- Formulaire pour ajouter/modifier un administrateur (MIS À JOUR) ---
class AdminFormScreen extends StatefulWidget {
  final Admin? admin; // Admin existant pour la modification
  final Function(Admin) onSave; // Callback pour sauvegarder
  final List<Structure> availableStructures; // NOUVEAU: Liste des structures disponibles

  const AdminFormScreen({
    super.key,
    this.admin,
    required this.onSave,
    required this.availableStructures, // MIS À JOUR dans le constructeur
  });

  @override
  State<AdminFormScreen> createState() => _AdminFormScreenState();
}

class _AdminFormScreenState extends State<AdminFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  String? _selectedStructureId; // Pour stocker l'ID de la structure sélectionnée
  String? _selectedStructureName; // Pour stocker le nom de la structure sélectionnée

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.admin?.name ?? '');
    _emailController = TextEditingController(text: widget.admin?.email ?? '');
    _passwordController = TextEditingController(text: '');

    if (widget.admin != null) {
      _selectedStructureId = widget.admin!.structureId;
      _selectedStructureName = widget.admin!.structureName;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Assurez-vous qu'une structure est sélectionnée
      if (_selectedStructureId == null || _selectedStructureName == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.selectStructure)), // Translated text
        );
        return;
      }

      final newAdmin = Admin(
        id: widget.admin?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        email: _emailController.text,
        structureId: _selectedStructureId!, // Utilise l'ID sélectionné
        structureName: _selectedStructureName!, // Utilise le nom sélectionné
      );
      widget.onSave(newAdmin);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!; // Access translations

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.admin == null ? appLocalizations.addAdministrator : appLocalizations.editAdministrator, // Translated title
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey[700],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: appLocalizations.fullName, // Translated label
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return appLocalizations.enterFullName; // Translated message
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: appLocalizations.emailLabel, // Translated label
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return appLocalizations.enterEmail; // Translated message
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return appLocalizations.validEmail; // Translated message
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: widget.admin == null ? appLocalizations.password : appLocalizations.newPasswordHint, // Translated label
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) {
                  if (widget.admin == null && (value == null || value.isEmpty)) {
                    return appLocalizations.enterPassword; // Translated message
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // --- Dropdown pour la sélection de la structure ---
              DropdownButtonFormField<String>(
                value: _selectedStructureId,
                decoration: InputDecoration(
                  labelText: appLocalizations.attachedStructure, // Translated label
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                items: widget.availableStructures.map((structure) {
                  return DropdownMenuItem<String>(
                    value: structure.id,
                    child: Text(structure.name),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedStructureId = newValue;
                    _selectedStructureName = widget.availableStructures
                        .firstWhere((s) => s.id == newValue)
                        .name;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return appLocalizations.selectStructure; // Translated message
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[700],
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    widget.admin == null ? appLocalizations.addAdministratorButton : appLocalizations.updateButton, // Translated text
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}