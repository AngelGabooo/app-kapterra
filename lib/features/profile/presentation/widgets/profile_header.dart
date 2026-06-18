import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/profile/data/models/user_profile_model.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfileModel user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Foto de perfil (con iniciales)
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryGreen,
                  AppTheme.secondaryGreen,
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryGreen.withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                user.fullName.split('').take(2).map((e) => e[0]).join().toUpperCase(),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Nombre
          Text(
            user.fullName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkCoffee,
            ),
          ),
          const SizedBox(height: 4),
          // Tipo de usuario
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.goldCoffee.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.agriculture, size: 14, color: AppTheme.goldCoffee),
                const SizedBox(width: 4),
                Text(
                  user.userType,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.goldCoffee,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Ubicación
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, size: 14, color: AppTheme.darkCoffee.withOpacity(0.5)),
              const SizedBox(width: 4),
              Text(
                user.location,
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.darkCoffee.withOpacity(0.7),
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.calendar_today, size: 14, color: AppTheme.darkCoffee.withOpacity(0.5)),
              const SizedBox(width: 4),
              Text(
                'Miembro desde ${user.memberSince}',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.darkCoffee.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}