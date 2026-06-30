import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class ProfileEditDialog extends StatefulWidget {
  final String title;
  final String initialValue;
  final Function(String) onSave;
  final TextInputType keyboardType;
  final int maxLines;

  const ProfileEditDialog({
    super.key,
    required this.title,
    required this.initialValue,
    required this.onSave,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  State<ProfileEditDialog> createState() => _ProfileEditDialogState();
}

class _ProfileEditDialogState extends State<ProfileEditDialog> {
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
        decoration: InputDecoration(
          hintText: widget.title,
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
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.trim().isNotEmpty) {
              widget.onSave(_controller.text.trim());
              Navigator.pop(context);
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