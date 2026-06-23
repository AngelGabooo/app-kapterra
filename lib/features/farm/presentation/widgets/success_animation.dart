import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Hero "sello de registro" (registration seal): a central checkmark badge
/// that lands with a bounce, a soft expanding ripple right after it settles,
/// and three feature icons (Lotes, Indicadores, Trazabilidad) that orbit in
/// around it, staggered, hinting at what just unlocked.
class SuccessAnimation extends StatefulWidget {
  const SuccessAnimation({super.key});

  @override
  State<SuccessAnimation> createState() => _SuccessAnimationState();
}

class _SuccessAnimationState extends State<SuccessAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _badgeScale;
  late final Animation<double> _badgeRotation;
  late final Animation<double> _badgeFade;
  late final Animation<double> _ringScale;
  late final Animation<double> _ringOpacity;
  late final List<Animation<double>> _chipScale;
  late final List<Animation<double>> _chipFade;

  static const double _size = 260;
  static const double _badgeDiameter = 120;
  static const double _orbitRadius = 88;
  static const double _chipDiameter = 46;

  // top, lower-right, lower-left — a simple, balanced triangle.
  static const List<double> _chipAngles = [-math.pi / 2, math.pi / 6, 5 * math.pi / 6];
  static const List<double> _chipStarts = [0.35, 0.45, 0.55];
  static const List<IconData> _chipIcons = [Icons.agriculture, Icons.analytics, Icons.qr_code];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _badgeScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.65, curve: Curves.elasticOut)),
    );
    _badgeRotation = Tween<double>(begin: -0.12, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.65, curve: Curves.easeOutCubic)),
    );
    _badgeFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.4, curve: Curves.easeIn)),
    );

    final ringInterval = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.55, 1.0, curve: Curves.easeOut),
    );
    _ringScale = Tween<double>(begin: 0.85, end: 1.65).animate(ringInterval);
    _ringOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.35), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.35, end: 0.0), weight: 70),
    ]).animate(ringInterval);

    _chipScale = _chipStarts.map((start) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Interval(start, start + 0.4, curve: Curves.elasticOut)),
      );
    }).toList();

    _chipFade = _chipStarts.map((start) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Interval(start, start + 0.25, curve: Curves.easeIn)),
      );
    }).toList();

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chipColors = [
      theme.colorScheme.primary,
      theme.colorScheme.tertiary,
      theme.colorScheme.secondary,
    ];

    return SizedBox(
      width: _size,
      height: _size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Ripple that pulses out once the badge has landed.
              Opacity(
                opacity: _ringOpacity.value,
                child: Transform.scale(
                  scale: _ringScale.value,
                  child: Container(
                    width: _badgeDiameter,
                    height: _badgeDiameter,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: theme.colorScheme.primary, width: 2),
                    ),
                  ),
                ),
              ),

              // Orbiting feature chips.
              for (int i = 0; i < _chipAngles.length; i++)
                Transform.translate(
                  offset: Offset(
                    math.cos(_chipAngles[i]) * _orbitRadius,
                    math.sin(_chipAngles[i]) * _orbitRadius,
                  ),
                  child: Opacity(
                    opacity: _chipFade[i].value,
                    child: Transform.scale(
                      scale: _chipScale[i].value,
                      child: Container(
                        width: _chipDiameter,
                        height: _chipDiameter,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                theme.brightness == Brightness.dark ? 0.25 : 0.08,
                              ),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(_chipIcons[i], size: 22, color: chipColors[i]),
                      ),
                    ),
                  ),
                ),

              // Central badge.
              Opacity(
                opacity: _badgeFade.value,
                child: Transform.rotate(
                  angle: _badgeRotation.value,
                  child: Transform.scale(
                    scale: _badgeScale.value,
                    child: Container(
                      width: _badgeDiameter,
                      height: _badgeDiameter,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.4),
                            blurRadius: 24,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        size: 60,
                        color: theme.brightness == Brightness.dark ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}