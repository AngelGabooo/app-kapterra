import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/marketplace/presentation/widgets/profile/profile_stat_card.dart';
import 'package:kaabcafe/features/marketplace/presentation/widgets/profile/profile_info_row.dart';
import 'package:kaabcafe/features/marketplace/presentation/widgets/profile/profile_edit_dialog.dart';
import 'package:kaabcafe/features/marketplace/presentation/widgets/profile/profile_preference_chip.dart';
import 'package:kaabcafe/features/marketplace/presentation/widgets/profile/profile_document_item.dart';
import 'package:kaabcafe/features/marketplace/presentation/widgets/profile/profile_settings_item.dart';

class BuyerProfileScreen extends StatefulWidget {
  const BuyerProfileScreen({super.key});

  @override
  State<BuyerProfileScreen> createState() => _BuyerProfileScreenState();
}

class _BuyerProfileScreenState extends State<BuyerProfileScreen> {
  int _currentIndex = 4;

  // ✅ Datos editables
  String _companyName = 'Café Export México';
  String _representative = 'Ángel Espinoza';
  String _buyerType = 'Cafetería Especializada';
  String _location = 'Ciudad de México, México';
  String _email = 'angel@cafeexport.com';
  String _phone = '+52 55 1234 5678';

  bool _notificationsEnabled = true;
  bool _marketingEmails = true;

  final List<String> _buyerTypes = [
    'Cafetería Especializada',
    'Tostador',
    'Exportador',
    'Comercializador',
    'Importador',
  ];

  final List<Map<String, dynamic>> _preferences = [
    {'emoji': '🌱', 'label': 'Especialidad'},
    {'emoji': '🌿', 'label': 'Orgánico'},
    {'emoji': '🌎', 'label': 'Comercio Justo'},
    {'emoji': '⛰️', 'label': 'Alta montaña'},
    {'emoji': '🍫', 'label': 'Perfil chocolate'},
    {'emoji': '🌸', 'label': 'Notas florales'},
  ];

  final List<Map<String, dynamic>> _documents = [
    {'emoji': '📄', 'label': 'Licencia comercial', 'status': 'Válida hasta 2026'},
    {'emoji': '📑', 'label': 'Certificado de calidad', 'status': 'ISO 9001'},
    {'emoji': '📊', 'label': 'Registro de exportador', 'status': 'Renovar en 3 meses'},
  ];

  void _showEditDialog(String title, String initialValue, Function(String) onSave) {
    showDialog(
      context: context,
      builder: (context) => ProfileEditDialog(
        title: title,
        initialValue: initialValue,
        onSave: onSave,
      ),
    );
  }

  void _showBuyerTypeSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selecciona tu tipo de comprador',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ..._buyerTypes.map((type) => ListTile(
              leading: Icon(
                type == _buyerType
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: type == _buyerType
                    ? AppTheme.primaryGreen
                    : Colors.grey,
              ),
              title: Text(type),
              onTap: () {
                setState(() {
                  _buyerType = type;
                });
                Navigator.pop(context);
              },
            )),
            const SizedBox(height: 16),
          ],
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
                        _representative.split(' ').map((e) => e[0]).take(2).join().toUpperCase(),
                        style: TextStyle(
                          fontSize: 16,
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
                          'Comprador • $_buyerType',
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
                    // Estadísticas
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
                          ProfileStatCard(
                            emoji: '🛒',
                            value: '0',
                            label: 'Compras',
                            isDark: isDark,
                          ),
                          ProfileStatCard(
                            emoji: '❤️',
                            value: '0',
                            label: 'Guardados',
                            isDark: isDark,
                          ),
                          ProfileStatCard(
                            emoji: '📤',
                            value: '0',
                            label: 'Ofertas',
                            isDark: isDark,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ProfileStatCard(
                          emoji: '💬',
                          value: '0',
                          label: 'Negociaciones',
                          isDark: isDark,
                        ),
                        ProfileStatCard(
                          emoji: '👥',
                          value: '0',
                          label: 'Contactados',
                          isDark: isDark,
                        ),
                        ProfileStatCard(
                          emoji: '⭐',
                          value: '0',
                          label: 'Valoración',
                          isDark: isDark,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Información de la empresa
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
                                  Icons.business_center,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Información de la empresa',
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
                                ProfileInfoRow(
                                  icon: Icons.business,
                                  label: 'Empresa',
                                  value: _companyName,
                                  isDark: isDark,
                                  isEditable: true,
                                  onEdit: () => _showEditDialog(
                                    'Empresa',
                                    _companyName,
                                        (value) => setState(() => _companyName = value),
                                  ),
                                ),
                                ProfileInfoRow(
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
                                ProfileInfoRow(
                                  icon: Icons.category,
                                  label: 'Tipo de comprador',
                                  value: _buyerType,
                                  isDark: isDark,
                                  isEditable: true,
                                  onEdit: _showBuyerTypeSelector,
                                ),
                                ProfileInfoRow(
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
                                ProfileInfoRow(
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
                                ProfileInfoRow(
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

                    const SizedBox(height: 20),

                    // Preferencias de café
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
                                Icons.coffee,
                                color: AppTheme.goldCoffee,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Preferencias de café',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _preferences.map((pref) => ProfilePreferenceChip(
                              emoji: pref['emoji'],
                              label: pref['label'],
                              isDark: isDark,
                              onTap: () {
                                // TODO: Editar preferencia
                              },
                            )).toList(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Certificaciones
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
                                Icons.verified,
                                color: AppTheme.primaryGreen,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Certificaciones y documentos',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ..._documents.map((doc) => ProfileDocumentItem(
                            emoji: doc['emoji'],
                            label: doc['label'],
                            status: doc['status'],
                            isDark: isDark,
                            onTap: () {},
                          )),
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

                    // Seguridad y configuración
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
                                  'Seguridad y configuración',
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
                                ProfileSettingsItem(
                                  icon: Icons.notifications,
                                  title: 'Notificaciones',
                                  subtitle: 'Recibir alertas de ofertas y mensajes',
                                  value: _notificationsEnabled,
                                  isDark: isDark,
                                  onChanged: (value) {
                                    setState(() => _notificationsEnabled = value);
                                  },
                                ),
                                ProfileSettingsItem(
                                  icon: Icons.email,
                                  title: 'Correos promocionales',
                                  subtitle: 'Recibir recomendaciones y novedades',
                                  value: _marketingEmails,
                                  isDark: isDark,
                                  onChanged: (value) {
                                    setState(() => _marketingEmails = value);
                                  },
                                ),
                                ProfileSettingsItem(
                                  icon: Icons.security,
                                  title: 'Seguridad',
                                  subtitle: 'Cambiar contraseña, autenticación 2FA',
                                  isDark: isDark,
                                  onTap: () {},
                                ),
                                ProfileSettingsItem(
                                  icon: Icons.language,
                                  title: 'Idioma',
                                  subtitle: 'Español (México)',
                                  isDark: isDark,
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
              context.go(RouteNames.marketplace);
            } else if (index == 1) {
              context.go(RouteNames.explore);
            } else if (index == 4) {
              context.go(RouteNames.buyerProfile);
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? AppTheme.coffeeDeep : Colors.white,
          selectedItemColor: isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen,
          unselectedItemColor: textColor.withOpacity(0.35),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Marketplace'),
            BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explorar'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Compras'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ),
    );
  }
}