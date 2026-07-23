// lib/features/buyer/presentation/widgets/profile/cooperative_profile_edit_dialog.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class CooperativeProfileEditDialog extends StatefulWidget {
  final String title;
  final String initialValue;
  final Function(String) onSave;
  final TextInputType keyboardType;
  final int maxLines;

  const CooperativeProfileEditDialog({
    super.key,
    required this.title,
    required this.initialValue,
    required this.onSave,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  State<CooperativeProfileEditDialog> createState() => _CooperativeProfileEditDialogState();
}

class _CooperativeProfileEditDialogState extends State<CooperativeProfileEditDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: isDark ? AppTheme.coffeeDeep : Colors.white,
      title: Text(
        'Editar ${widget.title}',
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: TextField(
        controller: _controller,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        style: TextStyle(color: textColor),
        autofocus: true, // ✅ Auto-focus para mejor UX
        decoration: InputDecoration(
          hintText: 'Ingresa ${widget.title}',
          hintStyle: TextStyle(color: textColor.withOpacity(0.4)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppTheme.primaryGreen.withOpacity(0.3),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppTheme.primaryGreen.withOpacity(0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppTheme.primaryGreen),
          ),
          filled: true,
          fillColor: isDark ? AppTheme.coffeeDark : AppTheme.lightBeige,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // ✅ Asegurar que se cierra correctamente
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          style: TextButton.styleFrom(
            foregroundColor: textColor.withOpacity(0.6),
          ),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.trim().isNotEmpty) {
              widget.onSave(_controller.text.trim());
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            } else {
              // ✅ Mostrar snackbar si está vacío
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Por favor ingresa un valor'),
                  backgroundColor: Colors.orange,
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryGreen,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}