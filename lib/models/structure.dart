class Structure {
  final String id;
  final String name;
  final String type; // Ex: "Santé", "Éducation", "Commerce", "Service", etc.
  final String location; // Ex: "Douala", "Yaoundé", "Garoua", etc.
  final String? contactEmail; // Optionnel
  final String? contactPhone; // Optionnel

  Structure({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    this.contactEmail,
    this.contactPhone,
  });
}