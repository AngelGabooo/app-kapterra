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
  String? _technicianName;
  String? _technicianPhone;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTechnicianData();
  }

  void _loadTechnicianData() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    setState(() {
      _technicianName = userProvider.userName ?? 'Técnico no disponible';
      _technicianPhone = userProvider.userPhone ?? '';
      _isLoading = false;
    });

    debugPrint('👤 Técnico: $_technicianName');
    debugPrint('📞 Teléfono técnico: $_technicianPhone');
  }

  Future<void> _makeCall() async {
    if (_technicianPhone == null || _technicianPhone!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ No hay número de teléfono disponible'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await CallService.makeDirectCall(_technicianPhone!);

      if (success) {
        // La llamada se inició correctamente
        Navigator.pop(context);
      } else {
        _showSnackBar('❌ No se pudo realizar la llamada', Colors.red);
      }
    } catch (e) {
      _showSnackBar('❌ Error al realizar la llamada: $e', Colors.red);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final cardColor = isDark ? AppTheme.coffeeDeep : Colors.white;

    final bool hasPhone = _technicianPhone != null && _technicianPhone!.isNotEmpty;

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
              'Contactar al Técnico',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),

            // Subtítulo
            Text(
              _isLoading ? 'Cargando datos del técnico...' : 'Llama directamente a tu técnico asignado',
              style: TextStyle(
                fontSize: 13,
                color: textColor.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Información del técnico
            if (!_isLoading) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppTheme.coffeeDark.withOpacity(0.5)
                      : AppTheme.lightBeige.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.primaryGreen.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.engineering,
                            color: AppTheme.primaryGreen,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Técnico asignado',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: textColor.withOpacity(0.5),
                                ),
                              ),
                              Text(
                                _technicianName ?? 'No disponible',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (hasPhone) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 14,
                            color: AppTheme.primaryGreen,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _technicianPhone!,
                            style: TextStyle(
                              fontSize: 13,
                              color: textColor.withOpacity(0.7),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Disponible',
                              style: TextStyle(
                                fontSize: 9,
                                color: AppTheme.primaryGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],

            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppTheme.primaryGreen,
                  ),
                ),
              ),

            const SizedBox(height: 20),

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
                      hasPhone
                          ? 'Presiona "Llamar" para contactar directamente a tu técnico.'
                          : 'No hay número de teléfono registrado para tu técnico.',
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
                    onPressed: (_isLoading || !hasPhone) ? null : _makeCall,
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
                    label: Text(_isLoading ? 'Cargando...' : 'Llamar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasPhone ? AppTheme.primaryGreen : Colors.grey,
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