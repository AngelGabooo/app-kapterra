// lib/features/profile/presentation/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/providers/user_provider.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/profile/data/models/user_profile_model.dart';
import 'package:kaabcafe/features/profile/presentation/widgets/quick_access_button.dart';

import '../../../auth/data/models/user_type_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfileModel? _user;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    _user = UserProfileModel(
      fullName: 'Usuario',
      userType: 'Técnico',
      location: 'Sin ubicación',
      memberSince: '2026',
      farmsCount: 0,
      activeLots: 0,
      activitiesCount: 0,
      totalCosts: 0,
      totalProduction: 0,
      avgProductivity: 0,
      digitalizationLevel: 0,
      level: 'Sin nivel',
      email: 'Sin correo',
      phone: 'Sin teléfono',
      municipality: 'Sin municipio',
      state: 'Sin estado',
      yearsExperience: '0 años',
      cooperative: 'Sin cooperativa',
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateUserData();
  }

  void _updateUserData() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userName = userProvider.userName ?? 'Usuario';
    final userEmail = userProvider.userEmail ?? 'Sin correo';
    final userType = userProvider.selectedUserType;

    String roleName = 'Técnico';
    if (userType != null && userType == UserType.technician) {
      roleName = 'Técnico';
    }

    setState(() {
      _user = UserProfileModel(
        fullName: userName,
        userType: roleName,
        location: 'Sin ubicación',
        memberSince: '2026',
        farmsCount: 0,
        activeLots: 0,
        activitiesCount: 0,
        totalCosts: 0,
        totalProduction: 0,
        avgProductivity: 0,
        digitalizationLevel: 0,
        level: 'Sin nivel',
        email: userEmail,
        phone: 'Sin teléfono',
        municipality: 'Sin municipio',
        state: 'Sin estado',
        yearsExperience: '0 años',
        cooperative: 'Sin cooperativa',
      );
    });
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userName = userProvider.userName ?? 'Usuario';
    final userEmail = userProvider.userEmail ?? 'Sin correo';

    if (_user != null && _user!.fullName != userName) {
      _updateUserData();
    }

    final user = _user!;

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
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // ── Barra superior ──────────────────────────────────
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          context.go(RouteNames.technicianDashboard);
                        }
                      },
                      icon: Icon(Icons.arrow_back, color: AppTheme.darkCoffee),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Mi Perfil',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkCoffee,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.edit, color: AppTheme.primaryGreen, size: 20),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.settings, color: AppTheme.darkCoffee, size: 20),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ── Avatar y nombre ──────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white, AppTheme.lightBeige],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppTheme.darkCoffee.withOpacity(0.06)),
                  ),
                  child: Column(
                    children: [
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
                            user.fullName.split(' ').map((e) => e[0]).take(2).join().toUpperCase(),
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
                        user.fullName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkCoffee,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.goldCoffee.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '👨‍🔧 ${user.userType}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.goldCoffee,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.email, size: 14, color: AppTheme.darkCoffee.withOpacity(0.5)),
                          const SizedBox(width: 4),
                          Text(
                            user.email,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.darkCoffee.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Información del Técnico ──────────────────────────
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppTheme.darkCoffee.withOpacity(0.06)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Información del Técnico',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkCoffee,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(Icons.person, 'Nombre completo', user.fullName),
                      _buildInfoRow(Icons.email, 'Correo electrónico', user.email),
                      _buildInfoRow(Icons.phone, 'Teléfono', user.phone),
                      _buildInfoRow(Icons.location_city, 'Municipio', user.municipality),
                      _buildInfoRow(Icons.map, 'Estado', user.state),
                      _buildInfoRow(Icons.timer, 'Años de experiencia', user.yearsExperience),
                      _buildInfoRow(Icons.people, 'Cooperativa', user.cooperative),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Accesos rápidos ──────────────────────────────────
                const Text(
                  'Accesos rápidos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkCoffee,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    final items = [
                      {'title': 'Agenda', 'icon': Icons.calendar_today, 'route': RouteNames.technicianAgenda},
                      {'title': 'Notificaciones', 'icon': Icons.notifications, 'route': RouteNames.notifications},
                      {'title': 'Seguridad', 'icon': Icons.security, 'route': RouteNames.pinSecurity},
                    ];
                    final item = items[index];
                    return QuickAccessButton(
                      title: item['title'] as String,
                      icon: item['icon'] as IconData,
                      onPressed: () {
                        if (item['route'] != null) {
                          context.push(item['route'] as String);
                        }
                      },
                    );
                  },
                ),

                const SizedBox(height: 24),

                // ── Botones de acción ──────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white, AppTheme.lightBeige],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppTheme.darkCoffee.withOpacity(0.06)),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.download, size: 22),
                          label: const Text(
                            'Exportar datos',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primaryGreen,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: AppTheme.primaryGreen.withOpacity(0.3)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _logout(context),
                          icon: const Icon(Icons.logout, size: 22),
                          label: const Text(
                            'Cerrar sesión',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD32F2F),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ],
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

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: AppTheme.primaryGreen),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.darkCoffee.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.darkCoffee,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}