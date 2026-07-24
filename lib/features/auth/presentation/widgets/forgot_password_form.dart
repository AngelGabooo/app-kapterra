// lib/features/auth/presentation/widgets/forgot_password_form.dart

import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/login_button.dart';
import 'neumorphic_box.dart';

class ForgotPasswordForm extends StatefulWidget {
  final Function(String email) onSendResetLink;
  final bool isLoading;

  const ForgotPasswordForm({
    super.key,
    required this.onSendResetLink,
    this.isLoading = false,
  });

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

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
    final isDark = theme.brightness == Brightness.dark;

    return Form(
      key: _formKey,
      child: Column(
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
          NeumorphicBox.inset(
            borderRadius: 20,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _handleSubmit(),
              enabled: !widget.isLoading,
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: theme.colorScheme.secondary,
                ),
                hintText: 'ejemplo@kaabterra.com',
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                ),
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
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu correo';
                }
                if (!value.contains('@') || !value.contains('.')) {
                  return 'Ingresa un correo válido';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 24),
          LoginButton(
            text: widget.isLoading ? 'Enviando...' : 'Enviar enlace de recuperación',
            onPressed: _handleSubmit,
            isLoading: widget.isLoading,
            isEnabled: !widget.isLoading,
          ),
        ],
      ),
    );
  }
}