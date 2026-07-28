// lib/features/technician/presentation/widgets/join_cooperative_dialog.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/providers/user_provider.dart';
import 'package:kaabcafe/core/providers/technician_contact_provider.dart';
import 'package:kaabcafe/core/providers/cooperatives_provider.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/dashboard/data/models/technician_contact_request_model.dart';

class JoinCooperativeDialog extends StatefulWidget {
  const JoinCooperativeDialog({super.key});

  @override
  State<JoinCooperativeDialog> createState() => _JoinCooperativeDialogState();
}

class _JoinCooperativeDialogState extends State<JoinCooperativeDialog> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _specialtyController = TextEditingController();
  String? _selectedCooperativeId;
  bool _isLoading = false;

  @override
  void dispose() {
    _messageController.dispose();
    _specialtyController.dispose();
    super.dispose();
  }

  void _sendRequest() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final contactProvider = Provider.of<TechnicianContactProvider>(context, listen: false);
    final cooperativesProvider = Provider.of<CooperativesProvider>(context, listen: false);

    if (_selectedCooperativeId == null) {
      _showError('Por favor, selecciona una cooperativa');
      return;
    }

    if (_messageController.text.trim().isEmpty) {
      _showError('Por favor, escribe un mensaje para la cooperativa');
      return;
    }

    // Obtener la cooperativa seleccionada
    final selectedCoop = cooperativesProvider.cooperatives.firstWhere(
          (c) => c.id == _selectedCooperativeId,
      orElse: () => throw Exception('Cooperativa no encontrada'),
    );

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 800));

    final request = TechnicianContactRequestModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      technicianName: userProvider.userName ?? 'Técnico',
      technicianEmail: userProvider.userEmail ?? 'email@ejemplo.com',
      technicianPhone: userProvider.userPhone ?? 'Sin teléfono',
      specialty: _specialtyController.text.trim().isNotEmpty
          ? _specialtyController.text.trim()
          : 'Agronomía',
      message: _messageController.text.trim(),
      requestDate: DateTime.now(),
      status: 'pending',
      cooperativeName: selectedCoop.name,
    );

    contactProvider.addRequest(request);

    setState(() => _isLoading = false);

    _showSuccessDialog(selectedCoop.name);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.alertOrange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  void _showSuccessDialog(String coopName) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: isDark ? AppTheme.coffeeDeep : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  size: 48,
                  color: AppTheme.primaryGreen,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '✅ Solicitud enviada',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppTheme.darkCoffee,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tu solicitud ha sido enviada a $coopName.',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white.withOpacity(0.7) : AppTheme.darkCoffee.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'La cooperativa se pondrá en contacto contigo pronto.',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white.withOpacity(0.5) : AppTheme.darkCoffee.withOpacity(0.5),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('Entendido'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _refreshCooperatives() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final coopProvider = Provider.of<CooperativesProvider>(context, listen: false);

    // ✅ Forzar recarga desde UserProvider
    userProvider.refreshCooperativeRegistration();

    // ✅ Forzar notificación
    coopProvider.refresh();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🔄 Recargando cooperativas...'),
        duration: Duration(seconds: 1),
        backgroundColor: AppTheme.primaryGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final cardColor = isDark ? AppTheme.coffeeDeep : Colors.white;

    // ✅ Obtener cooperativas del provider
    final cooperativesProvider = Provider.of<CooperativesProvider>(context);
    final cooperatives = cooperativesProvider.cooperatives;

    // ✅ Debug: Imprimir cantidad de cooperativas
    debugPrint('🔍 Cooperativas disponibles en diálogo: ${cooperatives.length}');

    // ✅ Si no hay cooperativas, mostrar mensaje
    final bool hasCooperatives = cooperatives.isNotEmpty;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 600,
        ),
        padding: const EdgeInsets.all(16),
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
            // ✅ Encabezado
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.engineering_outlined,
                    color: AppTheme.primaryGreen,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Unirse a Cooperativa',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        hasCooperatives
                            ? 'Solicita trabajar con una cooperativa'
                            : 'No hay cooperativas registradas aún',
                        style: TextStyle(
                          fontSize: 11,
                          color: hasCooperatives
                              ? textColor.withOpacity(0.5)
                              : AppTheme.alertOrange.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                // ✅ Botón de refresco
                IconButton(
                  onPressed: _refreshCooperatives,
                  icon: Icon(
                    Icons.refresh,
                    color: AppTheme.primaryGreen,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: textColor.withOpacity(0.5),
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ✅ Contenido del formulario
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ✅ Seleccionar cooperativa (dinámica)
                      if (hasCooperatives)
                        _buildDropdownField(
                          label: 'Selecciona una cooperativa *',
                          hint: 'Selecciona una cooperativa',
                          icon: Icons.apartment,
                          value: _selectedCooperativeId,
                          onChanged: (value) {
                            setState(() {
                              _selectedCooperativeId = value;
                            });
                          },
                          items: cooperatives.map<DropdownMenuItem<String>>((coop) {
                            return DropdownMenuItem<String>(
                              value: coop.id,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    coop.name,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: textColor,
                                    ),
                                  ),
                                  Text(
                                    '📍 ${coop.location} • ${coop.email}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: textColor.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          isDark: isDark,
                          textColor: textColor,
                          isEmpty: false,
                        )
                      else
                      // ✅ Mensaje cuando no hay cooperativas
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.alertOrange.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppTheme.alertOrange.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 18,
                                color: AppTheme.alertOrange,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'No hay cooperativas registradas en el sistema.\n\nSi eres una cooperativa, regístrate con ese rol para aparecer aquí.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: textColor.withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 12),

                      // ✅ Especialidad
                      Text(
                        'Especialidad',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: textColor.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: textColor.withOpacity(0.1),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: _specialtyController,
                          style: TextStyle(color: textColor, fontSize: 13),
                          decoration: const InputDecoration(
                            hintText: 'Ej: Agronomía, Fitopatología, Suelos...',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                            prefixIcon: Icon(
                              Icons.science,
                              color: AppTheme.primaryGreen,
                              size: 18,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ✅ Mensaje
                      Text(
                        'Mensaje para la cooperativa *',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: textColor.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: textColor.withOpacity(0.1),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: _messageController,
                          maxLines: 3,
                          minLines: 2,
                          style: TextStyle(color: textColor, fontSize: 13),
                          decoration: const InputDecoration(
                            hintText: 'Describe tu experiencia y especialidad...',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                            prefixIcon: Icon(
                              Icons.message_outlined,
                              color: AppTheme.primaryGreen,
                              size: 18,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ✅ Botón enviar
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (hasCooperatives && !_isLoading) ? _sendRequest : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: hasCooperatives ? AppTheme.primaryGreen : Colors.grey,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.send, size: 16),
                              SizedBox(width: 6),
                              Text(
                                'Enviar solicitud',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Widget helper para dropdown
  Widget _buildDropdownField({
    required String label,
    required String hint,
    required IconData icon,
    required String? value,
    required Function(String?) onChanged,
    required List<DropdownMenuItem<String>> items,
    required bool isDark,
    required Color textColor,
    bool isEmpty = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textColor.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: textColor.withOpacity(0.1),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            isExpanded: true,
            hint: Text(
              isEmpty ? 'No hay opciones disponibles' : hint,
              style: TextStyle(
                color: isEmpty ? Colors.grey : textColor.withOpacity(0.4),
                fontSize: 12,
              ),
            ),
            dropdownColor: isDark ? AppTheme.coffeeDeep : Colors.white,
            style: TextStyle(color: textColor, fontSize: 13),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: isEmpty ? Colors.grey : AppTheme.primaryGreen,
                size: 18,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            items: items,
            onChanged: onChanged,
            validator: (value) {
              if (value == null) {
                return 'Campo requerido';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}