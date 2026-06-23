import 'package:flutter/material.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/login_button.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/password_strength_indicator.dart';

class RegisterForm extends StatefulWidget {
  final Function(RegisterData data) onRegister;

  const RegisterForm({super.key, required this.onRegister});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class RegisterData {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;
  final bool acceptTerms;

  RegisterData({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.acceptTerms,
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
  }) {
    return InputDecoration(
      prefixIcon: Icon(prefixIcon, color: theme.colorScheme.secondary),
      hintText: hintText,
      hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.4)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.15)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.15)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: theme.colorScheme.secondary, width: 2),
      ),
      filled: true,
      fillColor: theme.colorScheme.surface,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nombre completo
          Text(
            'Nombre completo',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
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

          const SizedBox(height: 20),

          // Correo electrónico
          Text(
            'Correo electrónico',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
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

          const SizedBox(height: 20),

          // Número telefónico
          Text(
            'Número telefónico',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
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

          const SizedBox(height: 20),

          // Contraseña
          Text(
            'Contraseña',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.next,
            onChanged: (_) => setState(() {}),
            style: TextStyle(color: theme.colorScheme.onSurface),
            decoration: _buildInputDecoration(
              hintText: '••••••••',
              prefixIcon: Icons.lock_outline,
              theme: theme,
            ).copyWith(
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

          // Indicador de fortaleza dinámico
          PasswordStrengthIndicator(password: _passwordController.text),

          const SizedBox(height: 20),

          // Confirmar contraseña
          Text(
            'Confirmar contraseña',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleSubmit(),
            style: TextStyle(color: theme.colorScheme.onSurface),
            decoration: _buildInputDecoration(
              hintText: '••••••••',
              prefixIcon: Icons.lock_outline,
              theme: theme,
            ).copyWith(
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

          const SizedBox(height: 24),

          // Términos y condiciones
          Row(
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

          const SizedBox(height: 24),

          // 🚨 RESTAURADO: Botón principal adaptable para crear cuenta
          LoginButton(
            text: 'Crear cuenta',
            onPressed: _handleSubmit,
          ),
        ],
      ),
    );
  }
}