// lib/features/dashboard/presentation/widgets/contact_producer/contact_producer_dialog.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/providers/user_provider.dart';
import 'package:kaabcafe/core/services/call_service.dart';

class ContactProducerDialog extends StatefulWidget {
  const ContactProducerDialog({super.key});

  @override
  State<ContactProducerDialog> createState() => _ContactProducerDialogState();
}

class _ContactProducerDialogState extends State<ContactProducerDialog> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;

  // Número del productor (ejemplo - puedes obtenerlo del provider)
  final String _producerPhone = '+528144384806';

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _makeCallWithBot(String phoneNumber) async {
    setState(() => _isLoading = true);

    try {
      // Obtener el número del cliente desde UserProvider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final clientPhone = userProvider.userPhone ?? '+528144384806';

      // Llamar al bot de Twilio
      final success = await CallService.makeCall(
        clientPhoneNumber: clientPhone,
        producerPhone: phoneNumber,
        producerName: _nameController.text.isNotEmpty
            ? _nameController.text
            : 'Productor',
      );

      if (success) {
        _showSnackBar('📞 Te llamaremos para conectar con el productor', Colors.green);
        Navigator.pop(context);
      } else {
        _showSnackBar('❌ No se pudo iniciar la llamada. Intenta de nuevo.', Colors.red);
      }
    } catch (e) {
      _showSnackBar('❌ Error al realizar la llamada: $e', Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _handleCall() {
    final phone = _phoneController.text.trim();
    if (phone.isNotEmpty) {
      _makeCallWithBot(phone);
    } else {
      _makeCallWithBot(_producerPhone);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final cardColor = isDark ? AppTheme.coffeeDeep : Colors.white;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: textColor.withOpacity(0.06),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icono
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryGreen, AppTheme.secondaryGreen],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.phone_in_talk,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),

            // Título
            Text(
              'Contactar al Productor',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),

            // Subtítulo
            Text(
              'El bot te llamará para conectar con el productor',
              style: TextStyle(
                fontSize: 13,
                color: textColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 20),

            // Campo de nombre
            TextField(
              controller: _nameController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'Nombre del productor (opcional)',
                hintStyle: TextStyle(color: textColor.withOpacity(0.4)),
                prefixIcon: Icon(Icons.person, color: AppTheme.primaryGreen),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: textColor.withOpacity(0.1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: textColor.withOpacity(0.1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppTheme.primaryGreen),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 12),

            // Campo de teléfono
            TextField(
              controller: _phoneController,
              style: TextStyle(color: textColor),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Número de teléfono del productor',
                hintStyle: TextStyle(color: textColor.withOpacity(0.4)),
                prefixIcon: Icon(Icons.phone, color: AppTheme.primaryGreen),
                suffixIcon: IconButton(
                  icon: Icon(Icons.contacts, color: AppTheme.primaryGreen),
                  onPressed: () {
                    _phoneController.text = _producerPhone;
                  },
                  tooltip: 'Usar número de ejemplo',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: textColor.withOpacity(0.1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: textColor.withOpacity(0.1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppTheme.primaryGreen),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 12),

            // Info del bot
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.goldCoffee.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.goldCoffee.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: AppTheme.goldCoffee,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'El bot te llamará primero y luego te conectará con el productor.',
                      style: TextStyle(
                        fontSize: 11,
                        color: textColor.withOpacity(0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Botones
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: textColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      side: BorderSide(color: textColor.withOpacity(0.2)),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _handleCall,
                    icon: _isLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Icon(Icons.call),
                    label: Text(_isLoading ? 'Llamando...' : 'Llamar con Bot'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}