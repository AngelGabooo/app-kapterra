import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/onboarding/data/models/onboarding_model.dart';
import 'package:kaabcafe/features/onboarding/presentation/widgets/onboarding_item.dart';
import 'package:kaabcafe/features/onboarding/presentation/widgets/onboarding_button.dart';
import 'package:kaabcafe/features/onboarding/presentation/widgets/page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<OnboardingItem> _onboardingItems = OnboardingData.getItems();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _onboardingItems.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _completeOnboarding() {
    debugPrint('✅ Onboarding completado - Navegando al Login...');
    // ✅ Navegar directamente al Login
    context.go(RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightBeige,
              AppTheme.primaryGreen.withOpacity(0.03),
              AppTheme.lightBeige,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Botón Omitir en la esquina superior derecha
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: OnboardingButton(
                    text: 'Omitir',
                    onPressed: _skipOnboarding,
                    isPrimary: false,
                  ),
                ),
              ),

              // PageView con las páginas de onboarding
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _onboardingItems.length,
                  itemBuilder: (context, index) {
                    return OnboardingItemWidget(
                      item: _onboardingItems[index],
                    );
                  },
                ),
              ),

              // Indicador de página y botones
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    PageIndicator(
                      currentPage: _currentPage,
                      totalPages: _onboardingItems.length,
                    ),
                    const SizedBox(height: 24),
                    OnboardingButton(
                      text: _currentPage == _onboardingItems.length - 1
                          ? 'Comenzar'
                          : 'Siguiente',
                      onPressed: _nextPage,
                      isPrimary: true,
                      isLastPage: _currentPage == _onboardingItems.length - 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}