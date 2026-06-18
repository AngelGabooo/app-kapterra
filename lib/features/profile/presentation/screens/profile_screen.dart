import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/profile/data/models/user_profile_model.dart';
import 'package:kaabcafe/features/profile/presentation/widgets/profile_header.dart';
import 'package:kaabcafe/features/profile/presentation/widgets/profile_kpi_card.dart';
import 'package:kaabcafe/features/profile/presentation/widgets/digitalization_level.dart';
import 'package:kaabcafe/features/profile/presentation/widgets/achievement_badge.dart';
import 'package:kaabcafe/features/profile/presentation/widgets/quick_access_button.dart';
import 'package:kaabcafe/features/profile/presentation/widgets/line_chart.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserProfileModel _user;
  late List<ChartData> _productionData;
  late List<Map<String, dynamic>> _achievements;
  late List<Map<String, dynamic>> _quickAccess;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    _user = UserProfileModel(
      fullName: 'Ángel García',
      userType: 'Productor de Café',
      location: 'Motozintla, Chiapas',
      memberSince: '2026',
      farmsCount: 4,
      activeLots: 12,
      activitiesCount: 85,
      totalCosts: 128000,
      totalProduction: 1250,
      avgProductivity: 820,
      digitalizationLevel: 85,
      level: 'Productor Avanzado',
      email: 'angel.garcia@kaabterra.com',
      phone: '+52 123 456 7890',
      municipality: 'Motozintla',
      state: 'Chiapas',
      yearsExperience: '8 años',
      cooperative: 'Cafetaleros Unidos',
    );

    _productionData = [
      ChartData(month: 'Ene', value: 850),
      ChartData(month: 'Feb', value: 920),
      ChartData(month: 'Mar', value: 1100),
      ChartData(month: 'Abr', value: 980),
      ChartData(month: 'May', value: 1250),
      ChartData(month: 'Jun', value: 1420),
    ];

    _achievements = [
      {'title': 'Primera finca', 'icon': Icons.agriculture, 'locked': false, 'date': '2026'},
      {'title': '100 actividades', 'icon': Icons.task_alt, 'locked': false, 'date': '2026'},
      {'title': 'Trazabilidad', 'icon': Icons.qr_code, 'locked': false, 'date': '2026'},
      {'title': 'IA Consultada', 'icon': Icons.psychology, 'locked': false, 'date': '2026'},
      {'title': 'Primer lote', 'icon': Icons.inventory, 'locked': true, 'date': null},
    ];

    _quickAccess = [
      {'title': 'Configuración', 'icon': Icons.settings, 'route': null},
      {'title': 'Seguridad', 'icon': Icons.security, 'route': null},
      {'title': 'Notificaciones', 'icon': Icons.notifications, 'route': RouteNames.notifications},
      {'title': 'Idioma', 'icon': Icons.language, 'route': null},
      {'title': 'Ayuda', 'icon': Icons.help, 'route': null},
      {'title': 'Términos', 'icon': Icons.description, 'route': null},
    ];
  }

  void _onQuickAccessTap(String title, BuildContext context) {
    if (title == 'Notificaciones') {
      context.push(RouteNames.notifications);
    } else {
      debugPrint('Navegar a: $title');
    }
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
              // Barra superior
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Text(
                      'Mi Perfil',
                      style: TextStyle(
                        fontSize: 28,
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
              ),

              // Contenido scroll
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Encabezado
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white,
                              AppTheme.lightBeige,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
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
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  _user.fullName.split(' ').map((e) => e[0]).take(2).join().toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _user.fullName,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.darkCoffee,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppTheme.goldCoffee.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.agriculture, size: 12, color: AppTheme.goldCoffee),
                                        const SizedBox(width: 4),
                                        Text(
                                          _user.userType,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: AppTheme.goldCoffee,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on, size: 12, color: AppTheme.darkCoffee.withOpacity(0.5)),
                                      const SizedBox(width: 4),
                                      Text(
                                        _user.location,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppTheme.darkCoffee.withOpacity(0.6),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Icon(Icons.calendar_today, size: 12, color: AppTheme.darkCoffee.withOpacity(0.5)),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Desde ${_user.memberSince}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppTheme.darkCoffee.withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // KPIs
                      Row(
                        children: [
                          Expanded(
                            child: _buildModernKPI(
                              title: 'Fincas',
                              value: '${_user.farmsCount}',
                              icon: Icons.landscape,
                              color: AppTheme.primaryGreen,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildModernKPI(
                              title: 'Lotes activos',
                              value: '${_user.activeLots}',
                              icon: Icons.view_module,
                              color: AppTheme.goldCoffee,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildModernKPI(
                              title: 'Actividades',
                              value: '${_user.activitiesCount}',
                              icon: Icons.task_alt,
                              color: AppTheme.secondaryGreen,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildModernKPI(
                              title: 'Costos',
                              value: '\$${(_user.totalCosts / 1000).toStringAsFixed(0)}K',
                              icon: Icons.attach_money,
                              color: AppTheme.darkCoffee,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Gráfica
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Evolución de producción',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.darkCoffee,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Últimos 6 meses',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.darkCoffee.withOpacity(0.5),
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 200,
                              child: LineChartWidget(data: _productionData),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Nivel de digitalización
                      DigitalizationLevel(
                        level: _user.digitalizationLevel,
                        levelName: _user.level,
                        description: 'Has registrado información de manera constante y mantienes tu trazabilidad actualizada.',
                      ),

                      const SizedBox(height: 20),

                      // Logros
                      const Text(
                        'Logros destacados',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkCoffee,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _achievements.length,
                          itemBuilder: (context, index) {
                            final achievement = _achievements[index];
                            return Padding(
                              padding: EdgeInsets.only(right: index == _achievements.length - 1 ? 0 : 12),
                              child: AchievementBadge(
                                title: achievement['title'],
                                icon: achievement['icon'],
                                isLocked: achievement['locked'],
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Información personal
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Información personal',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.darkCoffee,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildInfoRow(Icons.person, 'Nombre completo', _user.fullName),
                            _buildInfoRow(Icons.email, 'Correo electrónico', _user.email),
                            _buildInfoRow(Icons.phone, 'Teléfono', _user.phone),
                            _buildInfoRow(Icons.location_city, 'Municipio', _user.municipality),
                            _buildInfoRow(Icons.map, 'Estado', _user.state),
                            _buildInfoRow(Icons.timer, 'Años de experiencia', _user.yearsExperience),
                            _buildInfoRow(Icons.people, 'Cooperativa', _user.cooperative),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Accesos rápidos
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
                        itemCount: _quickAccess.length,
                        itemBuilder: (context, index) {
                          final item = _quickAccess[index];
                          return QuickAccessButton(
                            title: item['title'],
                            icon: item['icon'],
                            onPressed: () => _onQuickAccessTap(item['title'], context),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // ✅ BOTONES MEJORADOS - Nuevo diseño
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white,
                              AppTheme.lightBeige,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Botón Exportar datos
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.download, size: 22),
                                label: const Text(
                                  'Exportar mis datos',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppTheme.primaryGreen,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  elevation: 2,
                                  shadowColor: AppTheme.primaryGreen.withOpacity(0.2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(color: AppTheme.primaryGreen.withOpacity(0.3)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Botón Sincronización
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.sync, size: 22),
                                label: const Text(
                                  'Sincronizar datos',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppTheme.goldCoffee,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  elevation: 2,
                                  shadowColor: AppTheme.goldCoffee.withOpacity(0.2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(color: AppTheme.goldCoffee.withOpacity(0.3)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Botón Cerrar sesión
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () => _logout(context),
                                icon: const Icon(Icons.logout, size: 22),
                                label: const Text(
                                  'Cerrar sesión',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFD32F2F),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  elevation: 2,
                                  shadowColor: const Color(0xFFD32F2F).withOpacity(0.3),
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: 4,
          onTap: (index) {
            if (index == 0) {
              context.go(RouteNames.dashboard);
            } else if (index == 1) {
              context.go(RouteNames.myFarms);
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppTheme.primaryGreen,
          unselectedItemColor: AppTheme.darkCoffee.withOpacity(0.5),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
            BottomNavigationBarItem(icon: Icon(Icons.landscape), label: 'Fincas'),
            BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Indicadores'),
            BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Marketplace'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ),
    );
  }

  Widget _buildModernKPI({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkCoffee,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: AppTheme.darkCoffee.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
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