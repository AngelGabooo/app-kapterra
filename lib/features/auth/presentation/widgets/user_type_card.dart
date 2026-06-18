import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/auth/data/models/user_type_model.dart';

class UserTypeCard extends StatelessWidget {
  final UserTypeModel userType;
  final VoidCallback onTap;

  const UserTypeCard({
    super.key,
    required this.userType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: userType.isSelected
            ? Colors.white
            : Colors.white.withOpacity(0.9),
        border: Border.all(
          color: userType.isSelected
              ? AppTheme.primaryGreen
              : Colors.grey.withOpacity(0.2),
          width: userType.isSelected ? 2.5 : 1,
        ),
        boxShadow: userType.isSelected
            ? [
          BoxShadow(
            color: AppTheme.primaryGreen.withOpacity(0.25),
            blurRadius: 16,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ]
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // ✅ Imagen selec.png con efecto de selección
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: userType.isSelected
                        ? Border.all(
                      color: AppTheme.primaryGreen,
                      width: 2,
                    )
                        : null,
                    boxShadow: userType.isSelected
                        ? [
                      BoxShadow(
                        color: AppTheme.primaryGreen.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      'assets/img/selec.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback si no encuentra la imagen
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: userType.isSelected
                                  ? [
                                AppTheme.primaryGreen.withOpacity(0.2),
                                AppTheme.goldCoffee.withOpacity(0.15),
                              ]
                                  : [
                                AppTheme.primaryGreen.withOpacity(0.1),
                                AppTheme.goldCoffee.withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Icon(
                            userType.type.icon,
                            size: 35,
                            color: userType.isSelected
                                ? AppTheme.primaryGreen
                                : AppTheme.darkCoffee.withOpacity(0.6),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 20),

                // Textos
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userType.type.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: userType.isSelected
                              ? AppTheme.primaryGreen
                              : AppTheme.darkCoffee,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        userType.type.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.darkCoffee.withOpacity(0.7),
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Check de selección con animación
                if (userType.isSelected)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryGreen,
                          AppTheme.secondaryGreen,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}