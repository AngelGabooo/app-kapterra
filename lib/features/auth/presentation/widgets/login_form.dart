// lib/features/auth/presentation/widgets/login_form.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/services/login_attempt_service.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/login_button.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/login_blocked_widget.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/neumorphic_box.dart';

class LoginForm extends StatefulWidget {
  final Function(String email, String password) onLogin;
  final VoidCallback onForgotPassword;

  const LoginForm({
    super.key,
    required this.onLogin,
    required this.onForgotPassword,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (_isSubmitting) return;

    final service = Provider.of<LoginAttemptService>(context, listen: false);

    if (service.isBlocked || service.isPermanentlyBlocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⛔ Cuenta bloqueada. Verifica el mensaje de arriba.'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      await widget.onLogin(
        _emailController.text,
        _passwordController.text,
      );

      setState(() {
        _isSubmitting = false;
      });
    }
  }

  InputDecoration _decoration(ThemeData theme, {
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: theme.colorScheme.secondary),
      suffixIcon: suffix,
      hintText: hint,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final service = Provider.of<LoginAttemptService>(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (service.isBlocked || service.isPermanentlyBlocked)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: LoginBlockedWidget(
                service: service,
                onUnblocked: () {
                  _formKey.currentState?.reset();
                  setState(() {});
                },
              ),
            ),

          Text(
            'Correo electrónico',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 8),
          NeumorphicBox.inset(
            borderRadius: 20,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              style: TextStyle(color: theme.colorScheme.onSurface),
              enabled: !service.isBlocked && !service.isPermanentlyBlocked,
              decoration: _decoration(
                theme,
                hint: 'ejemplo@kaabterra.com',
                icon: Icons.email_outlined,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Por favor ingresa tu correo';
                if (!value.contains('@') || !value.contains('.')) return 'Ingresa un correo válido';
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Contraseña',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 8),
          NeumorphicBox.inset(
            borderRadius: 20,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _handleSubmit(),
              enabled: !service.isBlocked && !service.isPermanentlyBlocked,
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: _decoration(
                theme,
                hint: '••••••••',
                icon: Icons.lock_outline,
                suffix: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Por favor ingresa tu contraseña';
                if (value.length < 6) return 'La contraseña debe tener al menos 6 caracteres';
                return null;
              },
            ),
          ),
          const SizedBox(height: 12),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: service.isBlocked || service.isPermanentlyBlocked ? null : widget.onForgotPassword,
              child: Text(
                '¿Olvidaste tu contraseña?',
                style: TextStyle(
                  color: theme.colorScheme.tertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          LoginButton(
            text: _isSubmitting ? 'Verificando...' : 'Iniciar sesión',
            onPressed: _handleSubmit,
            isLoading: _isSubmitting,
            enabled: !service.isBlocked && !service.isPermanentlyBlocked,
          ),

          if (!service.isBlocked && !service.isPermanentlyBlocked && service.attempts > 0)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Colors.orange.shade700,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Intentos restantes: ${6 - service.attempts}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.w500,
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