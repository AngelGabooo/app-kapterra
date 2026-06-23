import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:kaabcafe/features/splash/presentation/cubit/splash_state.dart';
import 'package:kaabcafe/features/splash/presentation/widgets/loading_dots.dart';
import 'package:kaabcafe/features/splash/presentation/widgets/golden_particles.dart';
import 'package:kaabcafe/features/splash/presentation/widgets/coffee_scene_illustration.dart';
import 'package:kaabcafe/features/splash/presentation/widgets/square_logo.dart';
import 'package:kaabcafe/features/splash/presentation/widgets/title_section.dart';

import '../widgets/neon_particles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _dotsController;

  late Animation<double> _bgFade;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<Offset> _textSlide;
  late Animation<double> _textFade;
  late Animation<double> _dotsFade;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    _initAnimations();
  }

  void _initAnimations() {
    _bgController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _bgFade = CurvedAnimation(parent: _bgController, curve: Curves.easeIn);

    _logoController = AnimationController(duration: const Duration(milliseconds: 900), vsync: this);
    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack));
    _logoFade = CurvedAnimation(parent: _logoController, curve: Curves.easeOut);

    _textController = AnimationController(duration: const Duration(milliseconds: 700), vsync: this);
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));
    _textFade = CurvedAnimation(parent: _textController, curve: Curves.easeOut);

    _dotsController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _dotsFade = CurvedAnimation(parent: _dotsController, curve: Curves.easeIn);

    _bgController.forward().then((_) {
      _logoController.forward().then((_) {
        _textController.forward();
      });
    });

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) {
        _dotsController.forward().then((_) {
          context.read<SplashCubit>().checkAppStatus();
        });
      }
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    _logoController.dispose();
    _textController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.coffeeDark,
      body: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is NavigateToOnboarding) {
            context.go(RouteNames.onboarding);
          } else if (state is NavigateToHome) {
            context.go(RouteNames.home);
          } else if (state is NavigateToLogin) {
            context.go(RouteNames.login);
          }
        },
        child: FadeTransition(
          opacity: _bgFade,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.45, 1.0],
                    colors: [AppTheme.coffeeDark, AppTheme.coffeeMedium, AppTheme.coffeeDeep],
                  ),
                ),
              ),
              GoldenParticles(),
              const Positioned(bottom: 0, left: 0, right: 0, child: CoffeeSceneIllustration()),
              SafeArea(
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    ScaleTransition(
                      scale: _logoScale,
                      child: FadeTransition(opacity: _logoFade, child: const SquareLogo()),
                    ),
                    const SizedBox(height: 40),
                    FadeTransition(
                      opacity: _textFade,
                      child: SlideTransition(position: _textSlide, child: const TitleSection()),
                    ),
                    const Spacer(flex: 3),
                    FadeTransition(
                      opacity: _dotsFade,
                      child: const Padding(
                        padding: EdgeInsets.only(bottom: 52),
                        child: Column(
                          children: [
                            LoadingDots(),
                            SizedBox(height: 20),
                            Text(
                              'v 1.0.0',
                              style: TextStyle(color: Colors.white24, fontSize: 11, letterSpacing: 1.5),
                            ),
                          ],
                        ),
                      ),
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