import 'package:flutter/material.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/login_button.dart';

class ForgotPasswordForm extends StatefulWidget {
  final Function(String email) onSendResetLink;

  const ForgotPasswordForm({super.key, required this.onSendResetLink});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onSendResetLink(_emailController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Campo de correo electrónico
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(theme.brightness == Brightness.dark ? 0.3 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _handleSubmit(),
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email_outlined, color: theme.colorScheme.secondary),
                hintText: 'correo@ejemplo.com',
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                ),
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
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu correo electrónico';
                }
                if (!value.contains('@') || !value.contains('.')) {
                  return 'Ingresa un correo electrónico válido';
                }
                return null;
              },
            ),
          ),

          const SizedBox(height: 24),

          // Botón enviar enlace
          LoginButton(
            text: 'Enviar enlace de recuperación',
            onPressed: _handleSubmit,
            isLoading: _isLoading,
          ),

          const SizedBox(height: 16),

          // Texto informativo
          Row(
            children: [
              Icon(
                Icons.security_outlined,
                size: 16,
                color: theme.colorScheme.secondary.withOpacity(0.8),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Recibirás un enlace seguro para crear una nueva contraseña.',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}