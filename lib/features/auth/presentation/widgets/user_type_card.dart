import 'package:flutter/material.dart';
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Configuraciones de color dinámicas según el estado y el modo del sistema
    final Color cardBackground;
    final Color borderColors;
    if (userType.isSelected) {
      cardBackground = isDark ? theme.colorScheme.surface : Colors.white;
      borderColors = theme.colorScheme.secondary;
    } else {
      cardBackground = isDark ? theme.colorScheme.surface.withOpacity(0.5) : Colors.white.withOpacity(0.9);
      borderColors = theme.colorScheme.onSurface.withOpacity(0.12);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: cardBackground,
        border: Border.all(
          color: borderColors,
          width: userType.isSelected ? 2.5 : 1,
        ),
        boxShadow: userType.isSelected
            ? [
          BoxShadow(
            color: theme.colorScheme.secondary.withOpacity(isDark ? 0.15 : 0.25),
            blurRadius: 16,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ]
            : [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
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
                // Ilustración/Contenedor 'selec.png' con efectos adaptivos
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: userType.isSelected
                        ? Border.all(
                      color: theme.colorScheme.secondary,
                      width: 2,
                    )
                        : null,
                    boxShadow: userType.isSelected
                        ? [
                      BoxShadow(
                        color: theme.colorScheme.secondary.withOpacity(0.3),
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
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: userType.isSelected
                                  ? [
                                theme.colorScheme.primary.withOpacity(0.2),
                                theme.colorScheme.tertiary.withOpacity(0.15),
                              ]
                                  : [
                                theme.colorScheme.primary.withOpacity(0.1),
                                theme.colorScheme.tertiary.withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Icon(
                            userType.type.icon,
                            size: 35,
                            color: userType.isSelected
                                ? theme.colorScheme.secondary
                                : theme.colorScheme.onSurface.withOpacity(0.6),
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
                              ? theme.colorScheme.secondary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        userType.type.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Check dinámico con gradiente del tema
                if (userType.isSelected)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.secondary,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      size: 18,
                      color: isDark ? Colors.black : Colors.white,
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