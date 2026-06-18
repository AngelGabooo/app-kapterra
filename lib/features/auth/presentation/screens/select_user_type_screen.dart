import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
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

  void _continue() {
    final selectedType = _userTypes.firstWhere((type) => type.isSelected);
    debugPrint('Tipo de usuario seleccionado: ${selectedType.type.title}');

    // ✅ Navegar a configuración de perfil
    if (selectedType.type == UserType.producer) {
      // Para productores, ir a configuración de perfil
      context.go(RouteNames.setupProfile);
    } else {
      // Para otros perfiles, mostrar mensaje (próximamente)
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
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
              const Text('Próximamente'),
            ],
          ),
          content: Text(
            'El perfil de ${selectedType.type.title} estará disponible próximamente.\n\nPor ahora, puedes continuar con el flujo de productor.',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryGreen,
              ),
              child: const Text('Entendido'),
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
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _goBack,
                      icon: const Icon(Icons.arrow_back),
                      color: AppTheme.darkCoffee,
                    ),
                    const Spacer(),
                    // Logo pequeño
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppTheme.primaryGreen.withOpacity(0.1),
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

              // Contenido principal
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  physics: const BouncingScrollPhysics(),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        // Título
                        const Text(
                          'Selecciona tu perfil',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Subtítulo
                        Text(
                          'Personalizaremos tu experiencia según tu rol dentro de la cadena productiva del café.',
                          style: TextStyle(
                            fontSize: 15,
                            color: AppTheme.darkCoffee.withOpacity(0.7),
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Tarjetas de selección
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

                        const SizedBox(height: 48),
                      ],
                    ),
                  ),
                ),
              ),

              // Botón continuar
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
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