// lib/features/dashboard/presentation/widgets/contact_producer/contact_cooperativa_dialog.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/providers/user_provider.dart';
import 'package:kaabcafe/core/providers/cooperative_contact_provider.dart';
import 'package:kaabcafe/core/providers/farm_provider.dart';
import 'package:kaabcafe/core/providers/cooperatives_provider.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/dashboard/data/models/cooperative_contact_request_model.dart';
import 'package:kaabcafe/features/farms/data/models/farm_details_model.dart';

class ContactCooperativaDialog extends StatefulWidget {
  const ContactCooperativaDialog({super.key});

  @override
  State<ContactCooperativaDialog> createState() => _ContactCooperativaDialogState();
}

class _ContactCooperativaDialogState extends State<ContactCooperativaDialog> {
  final TextEditingController _messageController = TextEditingController();
  String? _selectedFarmId;
  String? _selectedCooperativeId;
  bool _isLoading = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendRequest() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final contactProvider = Provider.of<CooperativeContactProvider>(context, listen: false);
    final farmProvider = Provider.of<FarmProvider>(context, listen: false);
    final cooperativesProvider = Provider.of<CooperativesProvider>(context, listen: false);

    if (_selectedCooperativeId == null) {
      _showError('Por favor, selecciona una cooperativa');
      return;
    }

    if (_selectedFarmId == null) {
      _showError('Por favor, selecciona una finca');
      return;
    }

    if (_messageController.text.trim().isEmpty) {
      _showError('Por favor, escribe un mensaje para la cooperativa');
      return;
    }

    final selectedFarm = farmProvider.farms.firstWhere(
          (f) => f.id == _selectedFarmId,
      orElse: () => farmProvider.farms.first,
    );

    final selectedCoop = cooperativesProvider.cooperatives.firstWhere(
          (c) => c.id == _selectedCooperativeId,
      orElse: () => throw Exception('Cooperativa no encontrada'),
    );

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 800));

    final request = CooperativeContactRequestModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      producerName: userProvider.userName ?? 'Productor',
      producerEmail: userProvider.userEmail ?? 'email@ejemplo.com',
      producerPhone: userProvider.userPhone ?? 'Sin teléfono',
      farmName: selectedFarm.name,
      location: selectedFarm.location,
      message: _messageController.text.trim(),
      requestDate: DateTime.now(),
      status: 'pending',
      cooperativeName: selectedCoop.name,
    );

    contactProvider.addRequest(request);

    setState(() => _isLoading = false);

    _showSuccessDialog(selectedCoop.name, selectedFarm.name);
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

  void _showSuccessDialog(String coopName, String farmName) {
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
              const SizedBox(height: 4),
              Text(
                'Finca: $farmName',
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

    userProvider.refreshCooperativeRegistration();
    coopProvider.refresh();
    setState(() {});

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

    final farmProvider = Provider.of<FarmProvider>(context);
    final userFarms = farmProvider.farms;

    final cooperativesProvider = Provider.of<CooperativesProvider>(context);
    final cooperatives = cooperativesProvider.cooperatives;

    debugPrint('🔍 Cooperativas disponibles en diálogo (Productor): ${cooperatives.length}');

    final bool hasCooperatives = cooperatives.isNotEmpty;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 620,
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
                    Icons.handshake_outlined,
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
                        'Contactar Cooperativa',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        hasCooperatives
                            ? 'Selecciona una cooperativa para tu café'
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
            const SizedBox(height: 10),

            // ✅ Contenido del formulario
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ✅ Seleccionar finca
                      _buildDropdownField(
                        label: 'Selecciona tu finca *',
                        hint: userFarms.isEmpty ? 'No tienes fincas registradas' : 'Selecciona una finca',
                        icon: Icons.landscape,
                        value: _selectedFarmId,
                        onChanged: (value) {
                          setState(() {
                            _selectedFarmId = value;
                          });
                        },
                        items: userFarms.map<DropdownMenuItem<String>>((farm) {
                          return DropdownMenuItem<String>(
                            value: farm.id,
                            child: Row(
                              children: [
                                Icon(Icons.landscape, size: 14, color: AppTheme.primaryGreen),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        farm.name,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: textColor,
                                        ),
                                      ),
                                      Text(
                                        '📍 ${farm.location} • ${farm.hectares} ha',
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: textColor.withOpacity(0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        isDark: isDark,
                        textColor: textColor,
                        isEmpty: userFarms.isEmpty,
                      ),
                      const SizedBox(height: 10),

                      // ✅ Seleccionar cooperativa
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
                              child: Row(
                                children: [
                                  Icon(Icons.apartment, size: 14, color: AppTheme.primaryGreen),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          coop.name,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: textColor,
                                          ),
                                        ),
                                        Text(
                                          '📍 ${coop.location} • ${coop.email}',
                                          style: TextStyle(
                                            fontSize: 9,
                                            color: textColor.withOpacity(0.5),
                                          ),
                                        ),
                                      ],
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
                        Container(
                          padding: const EdgeInsets.all(10),
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
                                  'No hay cooperativas registradas.\nSi eres cooperativa, regístrate con ese rol.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: textColor.withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 10),

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
                          maxLines: 2,
                          minLines: 1,
                          style: TextStyle(color: textColor, fontSize: 12),
                          decoration: const InputDecoration(
                            hintText: 'Describe tu producción y lo que buscas...',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                            prefixIcon: Icon(
                              Icons.message_outlined,
                              color: AppTheme.primaryGreen,
                              size: 16,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ✅ Botón enviar
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (hasCooperatives && !_isLoading) ? _sendRequest : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: hasCooperatives ? AppTheme.primaryGreen : Colors.grey,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.send, size: 14),
                              SizedBox(width: 4),
                              Text(
                                'Enviar solicitud',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
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

  // ✅ Widget helper para dropdown - CORREGIDO
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: textColor.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 3),
        Container(
          height: 42,
          decoration: BoxDecoration(
            border: Border.all(
              color: textColor.withOpacity(0.1),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Row(
                children: [
                  Icon(icon, color: textColor.withOpacity(0.4), size: 16),
                  const SizedBox(width: 6),
                  Text(
                    isEmpty ? 'No hay opciones disponibles' : hint,
                    style: TextStyle(
                      color: isEmpty ? Colors.grey : textColor.withOpacity(0.4),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              dropdownColor: isDark ? AppTheme.coffeeDeep : Colors.white,
              style: TextStyle(color: textColor, fontSize: 12),
              icon: Icon(Icons.arrow_drop_down, color: textColor.withOpacity(0.5), size: 24),
              items: items,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}