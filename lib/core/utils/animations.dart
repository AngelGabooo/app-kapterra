import 'package:flutter/material.dart';

class Animations {
  static AnimationController createFadeController(TickerProvider vsync) {
    return AnimationController(
      duration: const Duration(seconds: 2),
      vsync: vsync,
    );
  }

  static AnimationController createTextController(TickerProvider vsync) {
    return AnimationController(
      duration: const Duration(seconds: 1),
      vsync: vsync,
    );
  }

  static Animation<double> createFadeAnimation(AnimationController controller) {
    return CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
    );
  }

  static Future<void> delayAndForward(
      AnimationController controller, {
        Duration delay = const Duration(milliseconds: 800),
      }) async {
    await Future.delayed(delay);
    controller.forward();
  }
}