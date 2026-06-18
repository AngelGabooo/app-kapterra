import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/auth/data/models/setup_profile_model.dart';

class SetupProfileForm extends StatefulWidget {
  final Function(SetupProfileModel) onComplete;

  const SetupProfileForm({super.key, required this.onComplete});

  @override
  State<SetupProfileForm> createState() => _SetupProfileFormState();
}

class _SetupProfileFormState extends State<SetupProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late SetupProfileModel _profile;

  final _yearsExperienceOptions = [
    'Menos de 1 año',
    '1 a 5 años',
    '5 a 10 años',
    'Más de 10 años',
  ];

  final _coffeeVarietyOptions = [
    'Arábica',
    'Robusta',
    'Bourbon',
    'Typica',
    'Catuaí',
    'Geisha',
    'Otra',
  ];

  @override
  void initState() {
    super.initState();
    _profile = SetupProfileModel();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onComplete(_profile);
      // ✅ Después de completar el perfil, navegar al registro de finca
      context.go(RouteNames.registerFarm);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ========== INFORMACIÓN PERSONAL ==========
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Información personal',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkCoffee,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Foto de perfil
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.lightBeige,
                          border: Border.all(
                            color: AppTheme.primaryGreen.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: _profile.profileImagePath != null
                              ? Image.asset(
                            _profile.profileImagePath!,
                            fit: BoxFit.cover,
                          )
                              : Icon(
                            Icons.person,
                            size: 50,
                            color: AppTheme.primaryGreen.withOpacity(0.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton.icon(
                        onPressed: () {
                          // TODO: Implementar selección de imagen
                        },
                        icon: Icon(Icons.add_a_photo, size: 18, color: AppTheme.goldCoffee),
                        label: Text(
                          'Agregar fotografía',
                          style: TextStyle(color: AppTheme.goldCoffee),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Nombre completo
                const Text(
                  'Nombre completo',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkCoffee,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  onChanged: (value) => _profile.fullName = value,
                  decoration: _buildInputDecoration(
                    icon: Icons.person_outline,
                    hintText: 'Juan Pérez',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu nombre completo';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Teléfono
                const Text(
                  'Teléfono',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkCoffee,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  onChanged: (value) => _profile.phoneNumber = value,
                  keyboardType: TextInputType.phone,
                  decoration: _buildInputDecoration(
                    icon: Icons.phone_outlined,
                    hintText: '+52 123 456 7890',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu número telefónico';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Correo electrónico
                const Text(
                  'Correo electrónico',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkCoffee,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  onChanged: (value) => _profile.email = value,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _buildInputDecoration(
                    icon: Icons.email_outlined,
                    hintText: 'juan@ejemplo.com',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu correo';
                    }
                    if (!value.contains('@')) {
                      return 'Ingresa un correo válido';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Municipio
                const Text(
                  'Municipio',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkCoffee,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  onChanged: (value) => _profile.municipality = value,
                  decoration: _buildInputDecoration(
                    icon: Icons.location_city,
                    hintText: 'Tu municipio',
                  ),
                ),

                const SizedBox(height: 20),

                // Estado o región
                const Text(
                  'Estado o región',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkCoffee,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  onChanged: (value) => _profile.region = value,
                  decoration: _buildInputDecoration(
                    icon: Icons.map_outlined,
                    hintText: 'Tu estado o región',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ========== INFORMACIÓN PRODUCTIVA ==========
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Información productiva',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkCoffee,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Años de experiencia
                const Text(
                  'Años de experiencia cultivando café',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkCoffee,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _profile.yearsExperience.isEmpty ? null : _profile.yearsExperience,
                  hint: const Text('Selecciona una opción'),
                  decoration: _buildInputDecoration(
                    icon: Icons.timer_outlined,
                    hintText: 'Selecciona una opción',
                  ),
                  items: _yearsExperienceOptions.map((option) {
                    return DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _profile.yearsExperience = value ?? '';
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor selecciona tu experiencia';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Hectáreas cultivadas
                const Text(
                  'Hectáreas cultivadas',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkCoffee,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  onChanged: (value) => _profile.hectares = value,
                  keyboardType: TextInputType.number,
                  decoration: _buildInputDecoration(
                    icon: Icons.landscape,
                    hintText: 'Ej: 5.5',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa las hectáreas';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Variedad principal de café
                const Text(
                  'Variedad principal de café',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkCoffee,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _profile.coffeeVariety.isEmpty ? null : _profile.coffeeVariety,
                  hint: const Text('Selecciona una variedad'),
                  decoration: _buildInputDecoration(
                    icon: Icons.emoji_nature,
                    hintText: 'Selecciona una variedad',
                  ),
                  items: _coffeeVarietyOptions.map((option) {
                    return DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _profile.coffeeVariety = value ?? '';
                    });
                    // ✅ Después de seleccionar la variedad, navegar automáticamente
                    if (value != null && value.isNotEmpty) {
                      // Validar que los campos requeridos estén llenos
                      if (_formKey.currentState!.validate()) {
                        // Guardar el perfil y navegar
                        widget.onComplete(_profile);
                        context.go(RouteNames.registerFarm);
                      }
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor selecciona una variedad';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ¿Pertenece a una cooperativa?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '¿Pertenece a una cooperativa?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.darkCoffee,
                      ),
                    ),
                    Switch(
                      value: _profile.belongsToCooperative,
                      onChanged: (value) {
                        setState(() {
                          _profile.belongsToCooperative = value;
                        });
                      },
                      activeColor: AppTheme.primaryGreen,
                      activeTrackColor: AppTheme.primaryGreen.withOpacity(0.3),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required IconData icon,
    required String hintText,
  }) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: AppTheme.primaryGreen),
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: AppTheme.primaryGreen, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }
}