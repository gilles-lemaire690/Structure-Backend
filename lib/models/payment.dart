class Payment {
  final String id;
  final String clientName;
  final String serviceName;
  final double amount;
  final DateTime date;
  final String paymentMethod;
  final String receiptUrl; // URL pour le téléchargement du reçu

  Payment({
    required this.id,
    required this.clientName,
    required this.serviceName,
    required this.amount,
    required this.date,
    required this.paymentMethod,
    required this.receiptUrl,
  });
}