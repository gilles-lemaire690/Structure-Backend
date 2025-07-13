// lib/screens/admin/service_product_management_screen.dart
import 'package:flutter/material.dart';
import 'package:structure_front/models/service_product.dart';
import 'package:structure_front/themes/app_theme.dart'; // Importez le modèle ServiceProduct

class ServiceProductManagementScreen extends StatefulWidget {
  final String structureId; // ID de la structure de l'admin
  final String structureName; // Nom de la structure pour l'affichage

  const ServiceProductManagementScreen({
    super.key,
    required this.structureId,
    required this.structureName,
  });

  @override
  State<ServiceProductManagementScreen> createState() =>
      _ServiceProductManagementScreenState();
}

class _ServiceProductManagementScreenState
    extends State<ServiceProductManagementScreen> {
  // Liste simulée des services/produits pour cette structure
  // Dans une vraie application, cette liste serait filtrée par structureId via une API.
  List<ServiceProduct> _serviceProducts = [];

  @override
  void initState() {
    super.initState();
    // Simuler le chargement des services/produits pour cette structure spécifique
    _loadServiceProducts();
  }

  void _loadServiceProducts() {
    // Ici, nous simulons des données en fonction de l'ID de la structure
    if (widget.structureId == 'S001') {
      // Hôpital Central
      _serviceProducts = [
        ServiceProduct(
          id: 'SP001',
          name: 'Consultation Générale',
          description: 'Consultation médicale avec un médecin généraliste.',
          price: 5000.0,
          structureId: 'S001',
        ),
        ServiceProduct(
          id: 'SP002',
          name: 'Analyse Sanguine Complète',
          description: 'Examen sanguin pour vérifier divers indicateurs.',
          price: 15000.0,
          structureId: 'S001',
        ),
      ];
    } else if (widget.structureId == 'S002') {
      // École Primaire Biyem-Assi
      _serviceProducts = [
        ServiceProduct(
          id: 'SP003',
          name: 'Frais de Scolarité Annuel',
          description:
              'Frais d\'inscription et de scolarité pour une année complète.',
          price: 75000.0,
          structureId: 'S002',
        ),
        ServiceProduct(
          id: 'SP004',
          name: 'Repas Cantine Mensuel',
          description:
              'Abonnement mensuel pour les repas à la cantine scolaire.',
          price: 10000.0,
          structureId: 'S002',
        ),
      ];
    } else {
      _serviceProducts = [];
    }
    setState(() {}); // Met à jour l'UI après le chargement des données simulées
  }

  void _addServiceProduct() {
    print('Ajouter un nouveau Service/Produit');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ServiceProductFormScreen(
          structureId: widget.structureId, // Passer l'ID de la structure
          onSave: (newServiceProduct) {
            setState(() {
              _serviceProducts.add(newServiceProduct);
            });
            Navigator.of(context).pop(); // Revenir à la liste après ajout
          },
        ),
      ),
    );
  }

  void _editServiceProduct(ServiceProduct serviceProduct) {
    print('Modifier le Service/Produit: ${serviceProduct.name}');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ServiceProductFormScreen(
          serviceProduct: serviceProduct, // Passe le service/produit à modifier
          structureId: widget.structureId, // Passer l'ID de la structure
          onSave: (updatedServiceProduct) {
            setState(() {
              int index = _serviceProducts.indexWhere(
                (sp) => sp.id == updatedServiceProduct.id,
              );
              if (index != -1) {
                _serviceProducts[index] = updatedServiceProduct;
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

  void _deleteServiceProduct(String id) {
    setState(() {
      _serviceProducts.removeWhere((sp) => sp.id == id);
      print('Service/Produit avec ID $id supprimé.');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Service/Produit supprimé avec succès.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Services et Produits de ${widget.structureName}',
          style: const TextStyle(color: Colors.black87, fontSize: 18),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _serviceProducts.isEmpty
          ? const Center(
              child: Text(
                'Aucun service/produit enregistré pour cette structure.',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _serviceProducts.length,
              itemBuilder: (context, index) {
                final serviceProduct = _serviceProducts[index];
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
                                serviceProduct.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                serviceProduct.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Prix: XAF ${serviceProduct.price.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blueGrey),
                          onPressed: () => _editServiceProduct(serviceProduct),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                          onPressed: () =>
                              _deleteServiceProduct(serviceProduct.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addServiceProduct,
        backgroundColor: Colors.blueGrey[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// --- Formulaire pour ajouter/modifier un Service/Produit ---
class ServiceProductFormScreen extends StatefulWidget {
  final ServiceProduct?
  serviceProduct; // Service/Produit existant pour la modification
  final Function(ServiceProduct) onSave; // Callback pour sauvegarder
  final String structureId; // ID de la structure parente

  const ServiceProductFormScreen({
    super.key,
    this.serviceProduct,
    required this.onSave,
    required this.structureId,
  });

  @override
  State<ServiceProductFormScreen> createState() =>
      _ServiceProductFormScreenState();
}

class _ServiceProductFormScreenState extends State<ServiceProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.serviceProduct?.name ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.serviceProduct?.description ?? '',
    );
    _priceController = TextEditingController(
      text: widget.serviceProduct?.price.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newServiceProduct = ServiceProduct(
        id:
            widget.serviceProduct?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(), // Génère un ID
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.parse(
          _priceController.text,
        ), // Convertit le texte en double
        structureId: widget.structureId, // Utilise l'ID de la structure passée
      );
      widget.onSave(newServiceProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.serviceProduct == null
              ? 'Ajouter un Service/Produit'
              : 'Modifier le Service/Produit',
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
                  labelText: 'Nom du Service/Produit',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Prix (XAF)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prix';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Le prix doit être supérieur à zéro';
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
                    widget.serviceProduct == null ? 'Ajouter' : 'Mettre à jour',
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
