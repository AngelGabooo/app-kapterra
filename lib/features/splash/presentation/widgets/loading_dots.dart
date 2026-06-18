import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class LoadingDots extends StatefulWidget {
  const LoadingDots({super.key});

  @override
  State<LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double value = _controller.value;
            double delay = index * 0.25;
            double opacity = ((value + delay) % 1.0);
            opacity = opacity < 0.5 ? opacity * 2 : (1 - opacity) * 2;

            return Transform.scale(
              scale: 0.5 + (opacity * 0.7),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppTheme.goldCoffee,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.goldCoffee.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}