import 'package:flutter/material.dart';
import 'package:kaabcafe/features/auth/data/models/setup_profile_model.dart';
import 'neumorphic_box.dart';

/// Crema/beige cálido para las tarjetas en modo claro. En modo oscuro las
/// tarjetas usan directamente theme.colorScheme.surface, que tu AppTheme ya
/// resuelve a los tonos café.
const Color _kCardCreamLight = Color(0xFFFBF3E6);
const Color _kCardCreamLightAlt = Color(0xFFF6ECDA);

class SetupProfileForm extends StatefulWidget {
  final Function(SetupProfileModel) onComplete;

  const SetupProfileForm({super.key, required this.onComplete});

  @override
  State<SetupProfileForm> createState() => SetupProfileFormState();
}

class SetupProfileFormState extends State<SetupProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late SetupProfileModel _profile;

  final _yearsExperienceOptions = ['Menos de 1 año', '1 a 5 años', '5 a 10 años', 'Más de 10 años'];
  final _coffeeVarietyOptions = ['Arábica', 'Robusta', 'Bourbon', 'Typica', 'Catuaí', 'Geisha', 'Otra'];

  @override
  void initState() {
    super.initState();
    _profile = SetupProfileModel();
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.onComplete(_profile);
    }
  }

  /// Decoración flat pensada para vivir dentro de un NeumorphicBox.inset.
  InputDecoration _buildInputDecoration({required IconData icon, required String hintText, required ThemeData theme}) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: theme.colorScheme.secondary),
      hintText: hintText,
      hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.4)),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: theme.colorScheme.error, width: 1.4),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: theme.colorScheme.error, width: 1.4),
      ),
      filled: false,
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
    );
  }

  Widget _sectionHeader(ThemeData theme, String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [theme.colorScheme.primary, theme.colorScheme.tertiary]),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final labelStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface.withOpacity(0.9));

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ========== INFORMACIÓN PERSONAL ==========
          NeumorphicBox(
            borderRadius: 24,
            intensity: 6,
            color: isDark ? null : _kCardCreamLight,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeader(theme, 'Información personal'),
                const SizedBox(height: 24),
                Center(
                  child: Column(
                    children: [
                      NeumorphicBox(
                        borderRadius: 50,
                        intensity: 5,
                        color: isDark ? null : _kCardCreamLightAlt,
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: ClipOval(
                            child: _profile.profileImagePath != null
                                ? Image.asset(_profile.profileImagePath!, fit: BoxFit.cover)
                                : Icon(Icons.person, size: 50, color: theme.colorScheme.onSurface.withOpacity(0.3)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.add_a_photo, size: 18, color: theme.colorScheme.tertiary),
                        label: Text('Agregar fotografía', style: TextStyle(color: theme.colorScheme.tertiary, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text('Nombre completo', style: labelStyle),
                const SizedBox(height: 8),
                NeumorphicBox.inset(
                  borderRadius: 18,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextFormField(
                    onChanged: (value) => _profile.fullName = value,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: _buildInputDecoration(icon: Icons.person_outline, hintText: 'Juan Pérez', theme: theme),
                    validator: (value) => (value == null || value.isEmpty) ? 'Por favor ingresa tu nombre completo' : null,
                  ),
                ),
                const SizedBox(height: 20),
                Text('Teléfono', style: labelStyle),
                const SizedBox(height: 8),
                NeumorphicBox.inset(
                  borderRadius: 18,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextFormField(
                    onChanged: (value) => _profile.phoneNumber = value,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: _buildInputDecoration(icon: Icons.phone_outlined, hintText: '+52 123 456 7890', theme: theme),
                    validator: (value) => (value == null || value.isEmpty) ? 'Por favor ingresa tu número telefónico' : null,
                  ),
                ),
                const SizedBox(height: 20),
                Text('Correo electrónico', style: labelStyle),
                const SizedBox(height: 8),
                NeumorphicBox.inset(
                  borderRadius: 18,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextFormField(
                    onChanged: (value) => _profile.email = value,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: _buildInputDecoration(icon: Icons.email_outlined, hintText: 'juan@ejemplo.com', theme: theme),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Por favor ingresa tu correo';
                      if (!value.contains('@')) return 'Ingresa un correo válido';
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Text('Municipio', style: labelStyle),
                const SizedBox(height: 8),
                NeumorphicBox.inset(
                  borderRadius: 18,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextFormField(
                    onChanged: (value) => _profile.municipality = value,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: _buildInputDecoration(icon: Icons.location_city, hintText: 'Tu municipio', theme: theme),
                  ),
                ),
                const SizedBox(height: 20),
                Text('Estado o región', style: labelStyle),
                const SizedBox(height: 8),
                NeumorphicBox.inset(
                  borderRadius: 18,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextFormField(
                    onChanged: (value) => _profile.region = value,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: _buildInputDecoration(icon: Icons.map_outlined, hintText: 'Tu estado o región', theme: theme),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ========== INFORMACIÓN PRODUCTIVA ==========
          NeumorphicBox(
            borderRadius: 24,
            intensity: 6,
            color: isDark ? null : _kCardCreamLight,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeader(theme, 'Información productiva'),
                const SizedBox(height: 24),
                Text('Años de experiencia cultivando café', style: labelStyle),
                const SizedBox(height: 8),
                NeumorphicBox.inset(
                  borderRadius: 18,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonFormField<String>(
                    value: _profile.yearsExperience.isEmpty ? null : _profile.yearsExperience,
                    dropdownColor: isDark ? theme.colorScheme.surface : _kCardCreamLight,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: _buildInputDecoration(icon: Icons.timer_outlined, hintText: 'Selecciona una opción', theme: theme),
                    items: _yearsExperienceOptions.map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
                    onChanged: (value) => setState(() => _profile.yearsExperience = value ?? ''),
                    validator: (value) => (value == null || value.isEmpty) ? 'Por favor selecciona tu experiencia' : null,
                  ),
                ),
                const SizedBox(height: 20),
                Text('Hectáreas cultivadas', style: labelStyle),
                const SizedBox(height: 8),
                NeumorphicBox.inset(
                  borderRadius: 18,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextFormField(
                    onChanged: (value) => _profile.hectares = value,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: _buildInputDecoration(icon: Icons.landscape, hintText: 'Ej: 5.5', theme: theme),
                    validator: (value) => (value == null || value.isEmpty) ? 'Por favor ingresa las hectáreas' : null,
                  ),
                ),
                const SizedBox(height: 20),
                Text('Variedad principal de café', style: labelStyle),
                const SizedBox(height: 8),
                NeumorphicBox.inset(
                  borderRadius: 18,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonFormField<String>(
                    value: _profile.coffeeVariety.isEmpty ? null : _profile.coffeeVariety,
                    dropdownColor: isDark ? theme.colorScheme.surface : _kCardCreamLight,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: _buildInputDecoration(icon: Icons.emoji_nature, hintText: 'Selecciona una variedad', theme: theme),
                    items: _coffeeVarietyOptions.map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
                    onChanged: (value) {
                      setState(() => _profile.coffeeVariety = value ?? '');
                      if (value != null && value.isNotEmpty) {
                        submitForm(); // Ejecuta la validación nativa automática al seleccionar
                      }
                    },
                    validator: (value) => (value == null || value.isEmpty) ? 'Por favor selecciona una variedad' : null,
                  ),
                ),
                const SizedBox(height: 20),
                NeumorphicBox(
                  borderRadius: 16,
                  intensity: 3,
                  color: isDark ? null : _kCardCreamLightAlt,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text('¿Pertenece a una cooperativa?', style: labelStyle)),
                      Switch(
                        value: _profile.belongsToCooperative,
                        onChanged: (value) => setState(() => _profile.belongsToCooperative = value),
                        activeColor: theme.colorScheme.secondary,
                        activeTrackColor: theme.colorScheme.secondary.withOpacity(0.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}