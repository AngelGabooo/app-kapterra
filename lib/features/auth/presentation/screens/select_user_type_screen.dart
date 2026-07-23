// lib/features/auth/presentation/screens/select_user_type_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/providers/user_provider.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/glass_widgets.dart';
import 'package:kaabcafe/features/auth/data/models/user_type_model.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/user_type_card.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/login_button.dart';

class SelectUserTypeScreen extends StatefulWidget {
  const SelectUserTypeScreen({super.key});

  @override
  State<SelectUserTypeScreen> createState() => _SelectUserTypeScreenState();
}

class _SelectUserTypeScreenState extends State<SelectUserTypeScreen>
    with SingleTickerProviderStateMixin {
  late List<UserTypeModel> _userTypes;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _userTypes = [
      UserTypeModel(type: UserType.producer),
      UserTypeModel(type: UserType.technician),
      UserTypeModel(type: UserType.cooperative),
      UserTypeModel(type: UserType.buyer),
    ];

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _selectUserType(int index) {
    setState(() {
      for (int i = 0; i < _userTypes.length; i++) {
        _userTypes[i].isSelected = i == index;
      }
    });
  }

  Future<void> _continue() async {
    final selectedType = _userTypes.firstWhere((type) => type.isSelected);
    debugPrint('Tipo de usuario seleccionado: ${selectedType.type.title}');

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // ✅ Verificar que el teléfono se mantiene
    final currentPhone = userProvider.userPhone;
    debugPrint('📞 Teléfono antes de setUserType: $currentPhone');

    String? email = userProvider.userEmail;

    if (email == null || email.isEmpty) {
      final result = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Ingresa tu correo'),
          content: TextField(
            decoration: const InputDecoration(
              hintText: 'correo@ejemplo.com',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {},
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, 'usuario@ejemplo.com');
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      );

      if (result != null && result.isNotEmpty) {
        email = result;
      } else {
        email = 'usuario_${DateTime.now().millisecondsSinceEpoch}@ejemplo.com';
      }
    }

    // ✅ Guardar tipo de usuario (el teléfono se mantiene automáticamente)
    await userProvider.setUserType(selectedType.type, email: email);

    // ✅ Verificar que el teléfono sigue guardado
    debugPrint('📞 Teléfono después de setUserType: ${userProvider.userPhone}');

    if (selectedType.type == UserType.producer) {
      context.go(RouteNames.setupProfile);
    } else if (selectedType.type == UserType.cooperative) {
      context.go(RouteNames.cooperativeDashboard);
    } else if (selectedType.type == UserType.buyer) {
      context.go(RouteNames.marketplace);
    } else if (selectedType.type == UserType.technician) {
      context.go(RouteNames.technicianDashboard);
    } else {
      final theme = Theme.of(context);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppTheme.goldCoffee,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Próximamente',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'El perfil de ${selectedType.type.title} estará disponible próximamente.\n\nPor ahora, puedes continuar como productor.',
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.9),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.go(RouteNames.setupProfile);
              },
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryGreen,
              ),
              child: const Text('Continuar como productor'),
            ),
          ],
        ),
      );
    }
  }

  void _goBack() {
    context.go(RouteNames.register);
  }

  bool get _isSelected => _userTypes.any((type) => type.isSelected);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final creamColor = isDark
        ? AppTheme.coffeeDeep
        : const Color(0xFFF0E8D8);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: creamColor,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Barra superior ──────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    GlowIconButton(
                      icon: Icons.arrow_back,
                      isDark: isDark,
                      onPressed: _goBack,
                      size: 46,
                    ),
                    const Spacer(),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppTheme.primaryGreen.withOpacity(0.12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/img/logo_kaab_terra.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.agriculture,
                              size: 24,
                              color: AppTheme.primaryGreen,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Contenido principal ──────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  physics: const BouncingScrollPhysics(),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 36),
                        Text(
                          'Selecciona tu perfil',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppTheme.darkCoffee,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Personalizaremos tu experiencia según tu rol dentro de la cadena productiva del café.',
                          style: TextStyle(
                            fontSize: 15,
                            color: (isDark ? Colors.white : AppTheme.darkCoffee).withOpacity(0.7),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 32),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _userTypes.length,
                          itemBuilder: (context, index) {
                            return UserTypeCard(
                              userType: _userTypes[index],
                              onTap: () => _selectUserType(index),
                            );
                          },
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Botón continuar ──────────────────────────────────
              Container(
                padding: const EdgeInsets.all(24.0),
                color: Colors.transparent,
                child: LoginButton(
                  text: 'Continuar',
                  onPressed: _isSelected ? _continue : () {},
                  isLoading: false,
                  isEnabled: _isSelected,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}