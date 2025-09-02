import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:structure_mobile/features/user/models/models.dart';
import 'package:structure_mobile/features/user/models/structure_model.dart' as user_models;
import 'package:structure_mobile/features/user/screens/home_screen.dart';
import 'package:structure_mobile/features/user/screens/payment_screen.dart';
import 'package:structure_mobile/features/user/screens/payment_success_screen.dart';
import 'package:structure_mobile/features/user/screens/services_selection_screen.dart';
import 'package:structure_mobile/features/user/screens/structure_detail_screen.dart';

/// Centralized routing configuration for the user module

class UserRouter {
  // Route paths
  static const String home = '/home';
  static const String structureDetail = '/structure/:id';
  static const String servicesSelection = '/services-selection';
  static const String payment = '/payment';
  static const String paymentSuccess = '/payment/success';

  // Get all user routes for the main router
  static List<RouteBase> get routes => [
        // Home route
        GoRoute(
          path: home,
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        
        // Structure detail route
        GoRoute(
          path: structureDetail,
          name: 'structure-detail',
          builder: (context, state) {
            final structureId = state.pathParameters['id']!;
            return StructureDetailScreen(structureId: structureId);
          },
        ),
        
        // Services selection route
        GoRoute(
          path: servicesSelection,
          name: 'services-selection',
          builder: (context, state) {
            final args = state.extra as Map<String, dynamic>?;
            if (args == null || args['structure'] == null || args['services'] == null) {
              return Scaffold(
                appBar: AppBar(title: const Text('Erreur')),
                body: const Center(child: Text('Données manquantes')),
              );
            }
            return ServicesSelectionScreen(
              structure: args['structure'] as user_models.StructureModel,
              services: (args['services'] as List<dynamic>).cast<ServiceModel>(),
            );
          },
        ),
        
        // Payment route
        GoRoute(
          path: payment,
          name: 'payment',
          builder: (context, state) {
            final args = state.extra as Map<String, dynamic>?;
            if (args == null || args['structure'] == null || args['selectedServices'] == null) {
              return Scaffold(
                appBar: AppBar(title: const Text('Erreur')),
                body: const Center(child: Text('Données de paiement manquantes')),
              );
            }
            return PaymentScreen(
              structure: args['structure'] as StructureModel,
              selectedServices: (args['selectedServices'] as List<dynamic>).cast<Map<String, dynamic>>(),
              totalAmount: (args['totalAmount'] as num).toDouble(),
            );
          },
        ),
        
        // Payment success route
        GoRoute(
          path: paymentSuccess,
          name: 'payment-success',
          builder: (context, state) {
            final args = state.extra as Map<String, dynamic>?;
            if (args == null || args['transactionId'] == null || args['structure'] == null || 
                args['selectedServices'] == null || args['customerName'] == null || 
                args['customerPhone'] == null || args['paymentDate'] == null) {
              return Scaffold(
                appBar: AppBar(title: const Text('Erreur')),
                body: const Center(child: Text('Données de confirmation de paiement manquantes')),
              );
            }
            
            // Pour la compatibilité avec l'écran de succès existant, on prend le premier service
            // Note: Il faudrait aussi adapter PaymentSuccessScreen pour gérer plusieurs services
            final firstService = (args['selectedServices'] as List<dynamic>).first['service'] as ServiceModel;
            
            return PaymentSuccessScreen(
              transactionId: args['transactionId'] as String,
              structure: args['structure'] as StructureModel,
              service: firstService, // À adapter pour gérer plusieurs services
              customerName: args['customerName'] as String,
              customerPhone: args['customerPhone'] as String,
              paymentDate: args['paymentDate'] as DateTime,
            );
          },
        ),
      ];
      
  // Error page for user module
  static Widget errorBuilder(BuildContext context, GoRouterState state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '404',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Page non trouvée',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go(home),
            child: const Text('Retour à l\'accueil'),
          ),
        ],
      ),
    ),
  );

  /// Navigate to the home screen
  static void goToHome(BuildContext context) => context.go(home);
  
  /// Navigate to structure detail screen
  static void goToStructureDetail(BuildContext context, String structureId) => 
      context.go('$structureDetail'.replaceAll(':id', structureId));
  
  /// Navigate to payment screen
  static Future<T?> goToPayment<T>({
    required BuildContext context,
    required StructureModel structure,
    required ServiceModel service,
  }) async {
    return context.push<T>(
      payment,
      extra: {
        'structure': structure,
        'service': service,
      },
    );
  }
  
  /// Navigate to payment success screen
  static void goToPaymentSuccess({
    required BuildContext context,
    required String transactionId,
    required StructureModel structure,
    required ServiceModel service,
    required String customerName,
    required String customerPhone,
    required DateTime paymentDate,
  }) {
    context.go(
      paymentSuccess,
      extra: {
        'transactionId': transactionId,
        'structure': structure,
        'service': service,
        'customerName': customerName,
        'customerPhone': customerPhone,
        'paymentDate': paymentDate,
      },
    );
  }
  
}
