// lib/features/auth/presentation/widgets/register_form.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/features/auth/data/models/user_type_model.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/login_button.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/password_strength_indicator.dart';
import '../../../../core/themes/app_theme.dart';
import 'neumorphic_box.dart';

class RegisterForm extends StatefulWidget {
  final Function(RegisterData) onRegister;
  final bool showRoleSelector; // ✅ Nuevo parámetro

  const RegisterForm({
    super.key,
    required this.onRegister,
    this.showRoleSelector = true, // Por defecto true
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class RegisterData {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;
  final bool acceptTerms;
  final UserType? userType; // ✅ Agregar rol

  RegisterData({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.acceptTerms,
    this.userType,
  });
}

class _RegisterFormState extends State<RegisterForm> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  UserType? _selectedRole; // ✅ Rol seleccionado

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate() && _acceptTerms) {
      widget.onRegister(
        RegisterData(
          fullName: _fullNameController.text,
          email: _emailController.text,
          phoneNumber: _phoneController.text,
          password: _passwordController.text,
          acceptTerms: _acceptTerms,
          userType: _selectedRole,
        ),
      );
    } else if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Debes aceptar los términos y condiciones'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
    required ThemeData theme,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      prefixIcon: Icon(prefixIcon, color: theme.colorScheme.secondary),
      suffixIcon: suffixIcon,
      hintText: hintText,
      hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.4)),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: theme.colorScheme.error, width: 1.4),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: theme.colorScheme.error, width: 1.4),
      ),
      filled: false,
      contentPadding: const EdgeInsets.symmetric(vertical: 18),
    );
  }

  Widget _fieldLabel(ThemeData theme, String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface.withOpacity(0.9),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ SELECTOR DE ROL (si está habilitado)
          if (widget.showRoleSelector) ...[
            _fieldLabel(theme, 'Selecciona tu rol'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: UserType.values.map((role) {
                final isSelected = _selectedRole == role;
                return GestureDetector(
                  onTap: () => setState(() => _selectedRole = role),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary.withOpacity(0.15)
                          : (isDark ? AppTheme.coffeeDeep : const Color(0xFFF0E8D8)),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : (isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade300),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          role.icon,
                          size: 18,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          role.title,
                          style: TextStyle(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface.withOpacity(0.8),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],

          // Nombre completo
          _fieldLabel(theme, 'Nombre completo'),
          const SizedBox(height: 8),
          NeumorphicBox.inset(
            borderRadius: 20,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextFormField(
              controller: _fullNameController,
              textInputAction: TextInputAction.next,
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: _buildInputDecoration(
                hintText: 'Juan Pérez',
                prefixIcon: Icons.person_outline,
                theme: theme,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Por favor ingresa tu nombre completo';
                if (value.length < 3) return 'Nombre demasiado corto';
                return null;
              },
            ),
          ),

          const SizedBox(height: 20),

          // Correo electrónico
          _fieldLabel(theme, 'Correo electrónico'),
          const SizedBox(height: 8),
          NeumorphicBox.inset(
            borderRadius: 20,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: _buildInputDecoration(
                hintText: 'ejemplo@kaabterra.com',
                prefixIcon: Icons.email_outlined,
                theme: theme,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Por favor ingresa tu correo';
                if (!value.contains('@') || !value.contains('.')) return 'Ingresa un correo válido';
                return null;
              },
            ),
          ),

          const SizedBox(height: 20),

          // Número telefónico
          _fieldLabel(theme, 'Número telefónico'),
          const SizedBox(height: 8),
          NeumorphicBox.inset(
            borderRadius: 20,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: _buildInputDecoration(
                hintText: '+52 123 456 7890',
                prefixIcon: Icons.phone_outlined,
                theme: theme,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Por favor ingresa tu número telefónico';
                if (value.length < 10) return 'Número telefónico inválido';
                return null;
              },
            ),
          ),

          const SizedBox(height: 20),

          // Contraseña
          _fieldLabel(theme, 'Contraseña'),
          const SizedBox(height: 8),
          NeumorphicBox.inset(
            borderRadius: 20,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.next,
              onChanged: (_) => setState(() {}),
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: _buildInputDecoration(
                hintText: '••••••••',
                prefixIcon: Icons.lock_outline,
                theme: theme,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Por favor ingresa tu contraseña';
                if (value.length < 6) return 'La contraseña debe tener al menos 6 caracteres';
                return null;
              },
            ),
          ),

          // Indicador de fortaleza dinámico
          PasswordStrengthIndicator(password: _passwordController.text),

          const SizedBox(height: 20),

          // Confirmar contraseña
          _fieldLabel(theme, 'Confirmar contraseña'),
          const SizedBox(height: 8),
          NeumorphicBox.inset(
            borderRadius: 20,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _handleSubmit(),
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: _buildInputDecoration(
                hintText: '••••••••',
                prefixIcon: Icons.lock_outline,
                theme: theme,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                  ),
                  onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Por favor confirma tu contraseña';
                if (value != _passwordController.text) return 'Las contraseñas no coinciden';
                return null;
              },
            ),
          ),

          const SizedBox(height: 24),

          // Términos y condiciones
          NeumorphicBox(
            borderRadius: 16,
            intensity: 3,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Checkbox(
                  value: _acceptTerms,
                  onChanged: (value) => setState(() => _acceptTerms = value ?? false),
                  activeColor: theme.colorScheme.secondary,
                  checkColor: theme.brightness == Brightness.dark ? Colors.black : Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _acceptTerms = !_acceptTerms),
                    child: RichText(
                      text: TextSpan(
                        text: 'Acepto los ',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.8),
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: 'términos y condiciones',
                            style: TextStyle(
                              color: theme.colorScheme.tertiary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Botón principal
          LoginButton(
            text: 'Crear cuenta',
            onPressed: _handleSubmit,
          ),
        ],
      ),
    );
  }
}