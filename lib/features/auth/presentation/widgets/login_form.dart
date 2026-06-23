import 'package:flutter/material.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/login_button.dart';

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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onLogin(_emailController.text, _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email_outlined, color: theme.colorScheme.secondary),
              hintText: 'ejemplo@kaabterra.com',
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
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Por favor ingresa tu correo';
              if (!value.contains('@') || !value.contains('.')) return 'Ingresa un correo válido';
              return null;
            },
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
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleSubmit(),
            style: TextStyle(color: theme.colorScheme.onSurface),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock_outline, color: theme.colorScheme.secondary),
              suffixIcon: IconButton(
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
              hintText: '••••••••',
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
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Por favor ingresa tu contraseña';
              if (value.length < 6) return 'La contraseña debe tener al menos 6 caracteres';
              return null;
            },
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.onForgotPassword,
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
            text: 'Iniciar sesión',
            onPressed: _handleSubmit,
          ),
        ],
      ),
    );
  }
}