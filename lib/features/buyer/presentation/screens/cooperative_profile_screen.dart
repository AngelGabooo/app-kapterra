// lib/features/buyer/presentation/screens/cooperative_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/buyer/presentation/widgets/profile/cooperative_profile_stat_card.dart';
import 'package:kaabcafe/features/buyer/presentation/widgets/profile/cooperative_profile_info_row.dart';
import 'package:kaabcafe/features/buyer/presentation/widgets/profile/cooperative_profile_edit_dialog.dart';

class CooperativeProfileScreen extends StatefulWidget {
  const CooperativeProfileScreen({super.key});

  @override
  State<CooperativeProfileScreen> createState() => _CooperativeProfileScreenState();
}

class _CooperativeProfileScreenState extends State<CooperativeProfileScreen> {
  int _currentIndex = 4;

  // ✅ TODOS LOS DATOS VACÍOS
  String _cooperativeName = '---';
  String _representative = '---';
  String _rfc = '---';
  String _location = '---';
  String _email = '---';
  String _phone = '---';
  String _certifications = 'Sin certificaciones registradas';

  bool _notificationsEnabled = false;
  bool _marketingEmails = false;

  // ✅ Listas vacías
  final List<Map<String, dynamic>> _documents = [];

  final List<Map<String, dynamic>> _bankAccounts = [];

  void _showEditDialog(String title, String initialValue, Function(String) onSave) {
    showDialog(
      context: context,
      builder: (context) => CooperativeProfileEditDialog(
        title: title,
        initialValue: initialValue,
        onSave: onSave,
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.coffeeDark : AppTheme.lightBeige,
      body: SafeArea(
        child: Column(
          children: [
            // Barra superior
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark
                    ? AppTheme.coffeeDeep.withOpacity(0.9)
                    : Colors.white.withOpacity(0.9),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(isDark ? 0.05 : 0.1),
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.primaryGreen, AppTheme.secondaryGreen],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryGreen.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _cooperativeName.isNotEmpty && _cooperativeName != '---'
                            ? _cooperativeName.split(' ').map((e) => e[0]).take(2).join().toUpperCase()
                            : 'C',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _representative,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          'Representante de la cooperativa',
                          style: TextStyle(
                            fontSize: 11,
                            color: textColor.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Contenido
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // ✅ Estadísticas - TODOS EN 0
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDark
                              ? [AppTheme.coffeeDeep, AppTheme.coffeeDark]
                              : [Colors.white, AppTheme.lightBeige],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withOpacity(0.2)
                                : Colors.black.withOpacity(0.04),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CooperativeProfileStatCard(
                            emoji: '👨‍🌾',
                            value: '0',
                            label: 'Productores',
                            isDark: isDark,
                          ),
                          CooperativeProfileStatCard(
                            emoji: '🌱',
                            value: '0',
                            label: 'Fincas',
                            isDark: isDark,
                          ),
                          CooperativeProfileStatCard(
                            emoji: '☕',
                            value: '0',
                            label: 'Lotes',
                            isDark: isDark,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CooperativeProfileStatCard(
                          emoji: '📦',
                          value: '0',
                          label: 'Acopio',
                          isDark: isDark,
                        ),
                        CooperativeProfileStatCard(
                          emoji: '💰',
                          value: '0',
                          label: 'Ventas',
                          isDark: isDark,
                        ),
                        CooperativeProfileStatCard(
                          emoji: '⭐',
                          value: '0',
                          label: 'Calificación',
                          isDark: isDark,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ✅ Información de la cooperativa - VACÍA
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppTheme.coffeeDeep.withOpacity(0.8)
                            : Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(isDark ? 0.05 : 0.1),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withOpacity(0.1)
                                : Colors.black.withOpacity(0.02),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: isDark
                                    ? [AppTheme.coffeeMedium, AppTheme.coffeeDeep]
                                    : [AppTheme.primaryGreen, AppTheme.secondaryGreen],
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.apartment,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Información de la cooperativa',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                CooperativeProfileInfoRow(
                                  icon: Icons.business,
                                  label: 'Cooperativa',
                                  value: _cooperativeName,
                                  isDark: isDark,
                                  isEditable: true,
                                  onEdit: () => _showEditDialog(
                                    'Cooperativa',
                                    _cooperativeName,
                                        (value) => setState(() => _cooperativeName = value),
                                  ),
                                ),
                                CooperativeProfileInfoRow(
                                  icon: Icons.person,
                                  label: 'Representante',
                                  value: _representative,
                                  isDark: isDark,
                                  isEditable: true,
                                  onEdit: () => _showEditDialog(
                                    'Representante',
                                    _representative,
                                        (value) => setState(() => _representative = value),
                                  ),
                                ),
                                CooperativeProfileInfoRow(
                                  icon: Icons.numbers,
                                  label: 'RFC / Registro',
                                  value: _rfc,
                                  isDark: isDark,
                                  isEditable: true,
                                  onEdit: () => _showEditDialog(
                                    'RFC',
                                    _rfc,
                                        (value) => setState(() => _rfc = value),
                                  ),
                                ),
                                CooperativeProfileInfoRow(
                                  icon: Icons.location_on,
                                  label: 'Ubicación',
                                  value: _location,
                                  isDark: isDark,
                                  isEditable: true,
                                  onEdit: () => _showEditDialog(
                                    'Ubicación',
                                    _location,
                                        (value) => setState(() => _location = value),
                                  ),
                                ),
                                CooperativeProfileInfoRow(
                                  icon: Icons.email,
                                  label: 'Correo',
                                  value: _email,
                                  isDark: isDark,
                                  isEditable: true,
                                  onEdit: () => _showEditDialog(
                                    'Correo',
                                    _email,
                                        (value) => setState(() => _email = value),
                                  ),
                                ),
                                CooperativeProfileInfoRow(
                                  icon: Icons.phone,
                                  label: 'Teléfono',
                                  value: _phone,
                                  isDark: isDark,
                                  isEditable: true,
                                  onEdit: () => _showEditDialog(
                                    'Teléfono',
                                    _phone,
                                        (value) => setState(() => _phone = value),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ✅ Certificaciones - VACÍAS
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDark
                              ? [AppTheme.coffeeDeep, AppTheme.coffeeDark]
                              : [AppTheme.goldCoffee.withOpacity(0.05), AppTheme.primaryGreen.withOpacity(0.02)],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: (isDark ? AppTheme.coffeeGoldLight : AppTheme.goldCoffee).withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.verified,
                                color: AppTheme.goldCoffee,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Certificaciones',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () => _showEditDialog(
                                  'Certificaciones',
                                  _certifications,
                                      (value) => setState(() => _certifications = value),
                                ),
                                icon: Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: AppTheme.goldCoffee,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _certifications,
                            style: TextStyle(
                              fontSize: 13,
                              color: textColor.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ✅ Documentos - VACÍO
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppTheme.coffeeDeep.withOpacity(0.8)
                            : Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(isDark ? 0.05 : 0.1),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.description,
                                color: AppTheme.primaryGreen,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Documentos',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // ✅ Mensaje de vacío
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: (isDark ? AppTheme.coffeeDark : AppTheme.lightBeige).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.description_outlined, color: textColor.withOpacity(0.3)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Sin documentos registrados',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: textColor.withOpacity(0.4),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Agregar documento'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.primaryGreen,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              side: BorderSide(
                                color: AppTheme.primaryGreen.withOpacity(0.3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ✅ Cuentas bancarias - VACÍO
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppTheme.coffeeDeep.withOpacity(0.8)
                            : Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(isDark ? 0.05 : 0.1),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.account_balance,
                                color: AppTheme.primaryGreen,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Cuentas bancarias',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // ✅ Mensaje de vacío
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: (isDark ? AppTheme.coffeeDark : AppTheme.lightBeige).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.account_balance_outlined, color: textColor.withOpacity(0.3)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Sin cuentas bancarias registradas',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: textColor.withOpacity(0.4),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Agregar cuenta'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.primaryGreen,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              side: BorderSide(
                                color: AppTheme.primaryGreen.withOpacity(0.3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ✅ Configuración - TODOS DESACTIVADOS
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppTheme.coffeeDeep.withOpacity(0.8)
                            : Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(isDark ? 0.05 : 0.1),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: isDark
                                    ? [AppTheme.coffeeMedium, AppTheme.coffeeDeep]
                                    : [AppTheme.primaryGreen, AppTheme.secondaryGreen],
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Configuración',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                _buildSettingsItem(
                                  Icons.notifications,
                                  'Notificaciones',
                                  'Recibir alertas de acopio y productores',
                                  _notificationsEnabled,
                                  isDark,
                                  onChanged: (value) {
                                    setState(() => _notificationsEnabled = value);
                                  },
                                ),
                                _buildSettingsItem(
                                  Icons.email,
                                  'Correos promocionales',
                                  'Recibir novedades y reportes',
                                  _marketingEmails,
                                  isDark,
                                  onChanged: (value) {
                                    setState(() => _marketingEmails = value);
                                  },
                                ),
                                _buildSettingsItem(
                                  Icons.security,
                                  'Seguridad',
                                  'Cambiar contraseña, autenticación 2FA',
                                  null,
                                  isDark,
                                  onTap: () {},
                                ),
                                _buildSettingsItem(
                                  Icons.language,
                                  'Idioma',
                                  'Español (México)',
                                  null,
                                  isDark,
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Cerrar sesión
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
                          side: const BorderSide(
                            color: Colors.red,
                          ),
                        ),
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.coffeeDeep : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            if (index == 0) {
              context.go(RouteNames.cooperativeDashboard);
            } else if (index == 1) {
              context.go(RouteNames.producers);
            } else if (index == 2) {
              context.go(RouteNames.acopio);
            } else if (index == 4) {
              context.go(RouteNames.cooperativeProfile);
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? AppTheme.coffeeDeep : Colors.white,
          selectedItemColor: isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen,
          unselectedItemColor: textColor.withOpacity(0.35),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Inicio'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Productores'),
            BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Acopio'),
            BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Reportes'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ),
    );
  }

  Widget _buildBankAccount(String bank, String account, String type, bool isDark) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.coffeeDark.withOpacity(0.5)
            : Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.account_balance,
              size: 16,
              color: AppTheme.primaryGreen,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bank,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                Text(
                  account,
                  style: TextStyle(
                    fontSize: 11,
                    color: textColor.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              type,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentItem(String emoji, String label, String status, bool isDark) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.coffeeDark.withOpacity(0.5)
            : Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    color: textColor.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: 18,
            color: textColor.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
      IconData icon,
      String title,
      String subtitle,
      bool? value,
      bool isDark, {
        ValueChanged<bool>? onChanged,
        VoidCallback? onTap,
      }) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isDark
                  ? AppTheme.coffeeMedium.withOpacity(0.3)
                  : AppTheme.primaryGreen.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 16,
              color: isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: textColor.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          if (value != null && onChanged != null)
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppTheme.primaryGreen,
            ),
          if (value == null && onTap != null)
            GestureDetector(
              onTap: onTap,
              child: Icon(
                Icons.chevron_right,
                size: 18,
                color: textColor.withOpacity(0.3),
              ),
            ),
        ],
      ),
    );
  }
}