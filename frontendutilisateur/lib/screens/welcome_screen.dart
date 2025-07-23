import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/config/app_theme.dart';
import 'dart:async'; // Pour le Timer

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, String>> _welcomePages = [
    {
      'title': 'Bienvenue sur Mon Projet Cameroun',
      'description': 'Découvrez et réservez des services dans les meilleures structures du Cameroun, facilement et rapidement.',
      'image': 'assets/welcome_1.jfif', 
    },
    {
      'title': 'Explorez une multitude de structures',
      'description': 'Hôpitaux, universités, agences de voyage, centres sportifs... Trouvez ce dont vous avez besoin.',
      'image': 'assets/welcome_2.jfif', // Image pour la page 2
    },
    {
      'title': 'Réservez et payez en toute simplicité',
      'description': 'Sélectionnez vos services, remplissez vos informations et payez en toute sécurité via MTN/Orange Money ou CAM-POST.',
      'image': 'assets/welcome_3.jfif', // Image pour la page 3
    },
    {
      'title': 'Obtenez votre reçu instantanément',
      'description': 'Après chaque transaction réussie, téléchargez un reçu détaillé directement sur votre téléphone.',
      'image': 'assets/welcome_4.jfif', // Image pour la page 4
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_pageController.hasClients) {
        if (_currentPage < _welcomePages.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0; // Revenir au début
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _welcomePages.length,
              itemBuilder: (context, index) {
                final page = _welcomePages[index];
                return WelcomeCard(
                  title: page['title']!,
                  description: page['description']!,
                  imagePath: page['image']!,
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          // Indicateurs de pagination (dots)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_welcomePages.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                height: 10.0,
                width: _currentPage == index ? 28.0 : 10.0,
                decoration: BoxDecoration(
                  color: _currentPage == index ? AppColors.primaryBlue : AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(5.0),
                ),
              );
            }),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
            child: ElevatedButton(
              onPressed: () {
                context.go('/structures'); // Navigue vers la liste des structures
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55), // Bouton pleine largeur
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 5,
              ),
              child: Text(
                'Explorer l\'application',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WelcomeCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const WelcomeCard({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.asset(
              imagePath,
              height: 250,
              width: MediaQuery.of(context).size.width * 0.8,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 250,
                  width: MediaQuery.of(context).size.width * 0.8,
                  color: AppColors.lightGrey,
                  child: Center(
                    child: Icon(Icons.image_not_supported, color: AppColors.darkGrey.withOpacity(0.6), size: 80),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
          ),
          const SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.darkGrey.withOpacity(0.8),
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}
