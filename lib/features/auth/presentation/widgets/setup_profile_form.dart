import 'package:flutter/material.dart';
import 'package:kaabcafe/features/auth/data/models/setup_profile_model.dart';

class SetupProfileForm extends StatefulWidget {
  final Function(SetupProfileModel) onComplete;

  const SetupProfileForm({super.key, required this.onComplete});

  @override
  State<SetupProfileForm> createState() => SetupProfileFormState(); // 🚀 Cambiado a público (sin guion bajo)
}

// 🚀 Cambiado a público (sin guion bajo) para que la GlobalKey pueda leer sus métodos internos
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

  // 🚨 NUEVA FUNCIÓN PÚBLICA: Vincula la acción del botón de la pantalla con la validación del form
  void submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.onComplete(_profile);
    }
  }

  InputDecoration _buildInputDecoration({required IconData icon, required String hintText, required ThemeData theme}) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: theme.colorScheme.secondary),
      hintText: hintText,
      hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.4)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.15))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.15))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: theme.colorScheme.secondary, width: 2)),
      filled: true,
      fillColor: theme.colorScheme.surface,
    );
  }

  BoxDecoration _buildCardDecoration(ThemeData theme) {
    return BoxDecoration(
      color: theme.brightness == Brightness.dark ? theme.colorScheme.surface : Colors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.08)),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(theme.brightness == Brightness.dark ? 0.2 : 0.04), blurRadius: 10, offset: const Offset(0, 2)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface.withOpacity(0.9));

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ========== INFORMACIÓN PERSONAL ==========
          Container(
            padding: const EdgeInsets.all(20),
            decoration: _buildCardDecoration(theme),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(width: 4, height: 24, decoration: BoxDecoration(color: theme.colorScheme.secondary, borderRadius: BorderRadius.circular(2))),
                    const SizedBox(width: 12),
                    Text('Información personal', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: theme.scaffoldBackgroundColor, border: Border.all(color: theme.colorScheme.secondary.withOpacity(0.4), width: 2)),
                        child: ClipOval(
                          child: _profile.profileImagePath != null
                              ? Image.asset(_profile.profileImagePath!, fit: BoxFit.cover)
                              : Icon(Icons.person, size: 50, color: theme.colorScheme.onSurface.withOpacity(0.3)),
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
                const SizedBox(height: 24),
                Text('Nombre completo', style: labelStyle),
                const SizedBox(height: 8),
                TextFormField(
                  onChanged: (value) => _profile.fullName = value,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  decoration: _buildInputDecoration(icon: Icons.person_outline, hintText: 'Juan Pérez', theme: theme),
                  validator: (value) => (value == null || value.isEmpty) ? 'Por favor ingresa tu nombre completo' : null,
                ),
                const SizedBox(height: 20),
                Text('Teléfono', style: labelStyle),
                const SizedBox(height: 8),
                TextFormField(
                  onChanged: (value) => _profile.phoneNumber = value,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  decoration: _buildInputDecoration(icon: Icons.phone_outlined, hintText: '+52 123 456 7890', theme: theme),
                  validator: (value) => (value == null || value.isEmpty) ? 'Por favor ingresa tu número telefónico' : null,
                ),
                const SizedBox(height: 20),
                Text('Correo electrónico', style: labelStyle),
                const SizedBox(height: 8),
                TextFormField(
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
                const SizedBox(height: 20),
                Text('Municipio', style: labelStyle),
                const SizedBox(height: 8),
                TextFormField(
                  onChanged: (value) => _profile.municipality = value,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  decoration: _buildInputDecoration(icon: Icons.location_city, hintText: 'Tu municipio', theme: theme),
                ),
                const SizedBox(height: 20),
                Text('Estado o región', style: labelStyle),
                const SizedBox(height: 8),
                TextFormField(
                  onChanged: (value) => _profile.region = value,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  decoration: _buildInputDecoration(icon: Icons.map_outlined, hintText: 'Tu estado o región', theme: theme),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ========== INFORMACIÓN PRODUCTIVA ==========
          Container(
            padding: const EdgeInsets.all(20),
            decoration: _buildCardDecoration(theme),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(width: 4, height: 24, decoration: BoxDecoration(color: theme.colorScheme.secondary, borderRadius: BorderRadius.circular(2))),
                    const SizedBox(width: 12),
                    Text('Información productiva', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Años de experiencia cultivando café', style: labelStyle),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _profile.yearsExperience.isEmpty ? null : _profile.yearsExperience,
                  dropdownColor: theme.colorScheme.surface,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  decoration: _buildInputDecoration(icon: Icons.timer_outlined, hintText: 'Selecciona una opción', theme: theme),
                  items: _yearsExperienceOptions.map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
                  onChanged: (value) => setState(() => _profile.yearsExperience = value ?? ''),
                  validator: (value) => (value == null || value.isEmpty) ? 'Por favor selecciona tu experiencia' : null,
                ),
                const SizedBox(height: 20),
                Text('Hectáreas cultivadas', style: labelStyle),
                const SizedBox(height: 8),
                TextFormField(
                  onChanged: (value) => _profile.hectares = value,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  decoration: _buildInputDecoration(icon: Icons.landscape, hintText: 'Ej: 5.5', theme: theme),
                  validator: (value) => (value == null || value.isEmpty) ? 'Por favor ingresa las hectáreas' : null,
                ),
                const SizedBox(height: 20),
                Text('Variedad principal de café', style: labelStyle),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _profile.coffeeVariety.isEmpty ? null : _profile.coffeeVariety,
                  dropdownColor: theme.colorScheme.surface,
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
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('¿Pertenece a una cooperativa?', style: labelStyle),
                    Switch(
                      value: _profile.belongsToCooperative,
                      onChanged: (value) => setState(() => _profile.belongsToCooperative = value),
                      activeColor: theme.colorScheme.secondary,
                      activeTrackColor: theme.colorScheme.secondary.withOpacity(0.3),
                    ),
                  ],
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