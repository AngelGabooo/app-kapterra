// lib/features/dashboard/presentation/screens/profile_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/providers/user_provider.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/aurora_background.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';

import '../../../auth/data/models/user_type_model.dart';

class ProfileDashboardScreen extends StatefulWidget {
  const ProfileDashboardScreen({super.key});

  @override
  State<ProfileDashboardScreen> createState() => _ProfileDashboardScreenState();
}

class _ProfileDashboardScreenState extends State<ProfileDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    final userProvider = Provider.of<UserProvider>(context);
    final userName = userProvider.userName ?? 'Usuario';
    final userEmail = userProvider.userEmail ?? 'Sin correo registrado';
    final userPhone = userProvider.userPhone ?? 'No registrado';
    final userType = userProvider.selectedUserType;

    // Obtener iniciales para el avatar
    String initials = 'U';
    if (userName.isNotEmpty) {
      final parts = userName.split(' ');
      if (parts.length >= 2) {
        initials = parts[0][0].toUpperCase() + parts[1][0].toUpperCase();
      } else {
        initials = userName[0].toUpperCase();
      }
    }

    String roleName = 'Productor';
    if (userType != null) {
      switch (userType) {
        case UserType.producer:
          roleName = 'Productor';
          break;
        case UserType.cooperative:
          roleName = 'Cooperativa';
          break;
        case UserType.buyer:
          roleName = 'Comprador';
          break;
        case UserType.technician:
          roleName = 'Técnico';
          break;
        default:
          roleName = 'Productor';
          break;
      }
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AuroraBackground(
        isDark: isDark,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // ── Header con botón de regreso ──────────────────
                Row(
                  children: [
                    NeumorphicIconButton(
                      icon: Icons.arrow_back,
                      isDark: isDark,
                      onPressed: () {
                        // ✅ Volver al Dashboard correctamente
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          context.go(RouteNames.dashboard);
                        }
                      },
                      size: 44,
                      iconSize: 20,
                      color: textColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Mi Perfil',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                    NeumorphicIconButton(
                      icon: Icons.edit_outlined,
                      isDark: isDark,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Próximamente: Editar perfil'),
                            backgroundColor: AppTheme.primaryGreen,
                          ),
                        );
                      },
                      size: 44,
                      iconSize: 20,
                      color: AppTheme.primaryGreen,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ── Tarjeta de perfil ────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [AppTheme.coffeeDeep, AppTheme.coffeeDark]
                          : [Colors.white, AppTheme.lightBeige],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: textColor.withOpacity(0.06),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Avatar
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppTheme.primaryGreen, AppTheme.secondaryGreen],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryGreen.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userEmail,
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '📱 $userPhone',
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          roleName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Opciones del perfil ──────────────────────────
                _buildMenuItem(
                  icon: Icons.person_outline,
                  title: 'Información personal',
                  subtitle: 'Datos de tu cuenta',
                  isDark: isDark,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Próximamente: Editar información personal'),
                        backgroundColor: AppTheme.primaryGreen,
                      ),
                    );
                  },
                ),

                _buildMenuItem(
                  icon: Icons.security_outlined,
                  title: 'Seguridad',
                  subtitle: 'Cambiar contraseña, PIN de seguridad',
                  isDark: isDark,
                  onTap: () {
                    context.push(RouteNames.pinSecurity);
                  },
                ),

                _buildMenuItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notificaciones',
                  subtitle: 'Preferencias de notificaciones',
                  isDark: isDark,
                  onTap: () {
                    context.push(RouteNames.notifications);
                  },
                ),

                _buildMenuItem(
                  icon: Icons.language_outlined,
                  title: 'Idioma',
                  subtitle: 'Español (México)',
                  isDark: isDark,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Próximamente: Cambiar idioma'),
                        backgroundColor: AppTheme.primaryGreen,
                      ),
                    );
                  },
                ),

                _buildMenuItem(
                  icon: Icons.help_outline,
                  title: 'Ayuda y soporte',
                  subtitle: 'Centro de ayuda, preguntas frecuentes',
                  isDark: isDark,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Próximamente: Centro de ayuda'),
                        backgroundColor: AppTheme.primaryGreen,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // ── Botón de cerrar sesión ──────────────────────
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: OutlinedButton.icon(
                    onPressed: () => _showLogoutDialog(context),
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text(
                      'Cerrar sesión',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final cardColor = isDark
        ? AppTheme.coffeeDeep.withOpacity(0.7)
        : Colors.white.withOpacity(0.9);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: textColor.withOpacity(0.06),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppTheme.primaryGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.primaryGreen, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: textColor.withOpacity(0.5),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: textColor.withOpacity(0.3),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              final userProvider = Provider.of<UserProvider>(context, listen: false);
              userProvider.logout();
              context.go(RouteNames.login);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }
}