// lib/screens/admin/structure_management_screen.dart
import 'package:flutter/material.dart';
import 'package:structure_front/l10n/app_localizations.dart';
import 'package:structure_front/models/structure.dart';


class StructureManagementScreen extends StatefulWidget {
  const StructureManagementScreen({super.key});

  @override
  State<StructureManagementScreen> createState() =>
      _StructureManagementScreenState();
}

class _StructureManagementScreenState extends State<StructureManagementScreen> {
  // Liste simulée de structures
  // Dans une vraie application, cette liste viendrait d'une API backend.
  List<Structure> _structures = [
    Structure(
      id: 'S001',
      name: 'Hôpital Central',
      type: 'Santé',
      location: 'Yaoundé',
      contactEmail: 'contact@hopital-central.cm',
    ),
    Structure(
      id: 'S002',
      name: 'Université de Douala',
      type: 'Éducation',
      location: 'Douala',
      contactEmail: 'info@univ-douala.cm',
    ),
    Structure(
      id: 'S003',
      name: 'Supermarché Express',
      type: 'Commerce',
      location: 'Bafoussam',
    ),
  ];

  void _addStructure() {
    print('Ajouter une nouvelle Structure');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StructureFormScreen(
          onSave: (newStructure) {
            setState(() {
              _structures.add(newStructure);
            });
            Navigator.of(context).pop(); // Revenir à la liste après ajout
          },
        ),
      ),
    );
  }

  void _editStructure(Structure structure) {
    print('Modifier la Structure: ${structure.name}');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StructureFormScreen(
          structure: structure, // Passe la structure à modifier
          onSave: (updatedStructure) {
            setState(() {
              int index = _structures.indexWhere(
                (s) => s.id == updatedStructure.id,
              );
              if (index != -1) {
                _structures[index] = updatedStructure;
              }
            });
            Navigator.of(
              context,
            ).pop(); // Revenir à la liste après modification
          },
        ),
      ),
    );
  }

  void _deleteStructure(String id) {
    setState(() {
      _structures.removeWhere((structure) => structure.id == id);
      print('Structure avec ID $id supprimée.');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.structureDeletedSuccessfully)), // Translated text
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!; // Access translations

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          appLocalizations.manageStructuresTitle, // Translated title
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey[700],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _structures.isEmpty
          ? Center(
              child: Text(
                appLocalizations.noStructuresRecorded, // Translated text
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _structures.length,
              itemBuilder: (context, index) {
                final structure = _structures[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                structure.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Type: ${structure.type} | Localisation: ${structure.location}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              if (structure.contactEmail != null &&
                                  structure.contactEmail!.isNotEmpty)
                                Text(
                                  'Email: ${structure.contactEmail}',
                                  style: TextStyle(fontSize: 14, color: Colors.blueGrey[600]),
                                ),
                              if (structure.contactPhone != null &&
                                  structure.contactPhone!.isNotEmpty)
                                Text(
                                  'Tél: ${structure.contactPhone}',
                                  style: TextStyle(fontSize: 14, color: Colors.blueGrey[600]),
                                ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blueGrey),
                          onPressed: () => _editStructure(structure),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                          onPressed: () => _deleteStructure(structure.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addStructure,
        backgroundColor: Colors.blueGrey[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// --- Formulaire pour ajouter/modifier une structure ---
class StructureFormScreen extends StatefulWidget {
  final Structure? structure; // Structure existante pour la modification
  final Function(Structure) onSave; // Callback pour sauvegarder

  const StructureFormScreen({super.key, this.structure, required this.onSave});

  @override
  State<StructureFormScreen> createState() => _StructureFormScreenState();
}

class _StructureFormScreenState extends State<StructureFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _typeController;
  late TextEditingController _locationController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.structure?.name ?? '');
    _typeController = TextEditingController(text: widget.structure?.type ?? '');
    _locationController = TextEditingController(
      text: widget.structure?.location ?? '',
    );
    _emailController = TextEditingController(
      text: widget.structure?.contactEmail ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.structure?.contactPhone ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _locationController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newStructure = Structure(
        id:
            widget.structure?.id ??
            DateTime.now().millisecondsSinceEpoch
                .toString(), // Génère un ID si c'est une nouvelle structure
        name: _nameController.text,
        type: _typeController.text,
        location: _locationController.text,
        contactEmail: _emailController.text.isNotEmpty
            ? _emailController.text
            : null,
        contactPhone: _phoneController.text.isNotEmpty
            ? _phoneController.text
            : null,
      );
      widget.onSave(newStructure);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!; // Access translations

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.structure == null ? 'Ajouter une Structure' : 'Modifier la Structure',
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
                  labelText: 'Nom de la Structure',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return appLocalizations.enterStructureName; // Translated message
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _typeController,
                decoration: InputDecoration(
                  labelText: 'Type de Structure (Ex: Santé, Éducation)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return appLocalizations.enterStructureType; // Translated message
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Localisation (Ex: Yaoundé, Douala)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return appLocalizations.enterLocation; // Translated message
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'E-mail de Contact (Optionnel)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Téléphone de Contact (Optionnel)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
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
                    widget.structure == null ? 'Ajouter la Structure' : 'Mettre à jour',
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
