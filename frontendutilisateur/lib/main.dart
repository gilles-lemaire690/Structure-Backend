    // lib/main.dart
    import 'package:flutter/material.dart';
    import 'package:flutter_riverpod/flutter_riverpod.dart';
    import 'package:go_router/go_router.dart';

    import '/screens/welcome_screen.dart';
    import '/screens/structures/structures_list_screen.dart';
    import '/screens/structures/structure_detail_screen.dart';
    import '/screens/services_products/service_selection_screen.dart';
    import '/screens/payment/payment_form_screen.dart'; // Importez le nouvel écran de paiement
    
    import '/config/app_theme.dart'; // Importez votre thème
    import '/domain/entities/service_entity.dart'; // Importez ServiceEntity pour le passage d'extra

    void main() async {
      WidgetsFlutterBinding.ensureInitialized();
      runApp(
        const ProviderScope(
          child: MyApp(),
        ),
      );
    }

   // GoRouter configuration for navigation
final _router = GoRouter(
  initialLocation: '/', // Démarrage sur l'écran d'accueil
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomeScreen(), // Route pour l'écran d'accueil
    ),
   
    GoRoute(
      path: '/structures',
      builder: (context, state) => const StructuresListScreen(),
    ),
    GoRoute(
      path: '/structures/:structureId',
      builder: (context, state) {
        final structureId = state.pathParameters['structureId'];
        return StructureDetailScreen(structureId: structureId!);
      },
    ),
    GoRoute(
      path: '/structures/:structureId/services',
      builder: (context, state) {
        final structureId = state.pathParameters['structureId'];
        return ServiceSelectionScreen(structureId: structureId!);
      },
    ),
    GoRoute(
      path: '/payment-form',
      builder: (context, state) {
        final selectedService = state.extra as ServiceEntity?;
        if (selectedService == null) {
          // Gérer le cas où le service n'est pas passé (ex: rediriger ou afficher une erreur)
          return Scaffold(
            appBar: AppBar(title: const Text('Erreur de Paiement')),
            body: const Center(child: Text('Service non sélectionné.')),
          );
        }
        return PaymentFormScreen(selectedService: selectedService);
      },
    ),
    // Ajoutez d'autres routes ici au fur et à mesure
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mon Projet Cameroun',
      debugShowCheckedModeBanner: false, // Gardé cette ligne comme dans votre code fourni
      theme: appTheme, // Appliquez votre thème personnalisé ici
      routerConfig: _router,
    );
  }
}
