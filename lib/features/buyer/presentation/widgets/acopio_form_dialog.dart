import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/buyer/data/models/acopio_model.dart';

class AcopioFormDialog extends StatefulWidget {
  final Function(AcopioModel) onSave;

  const AcopioFormDialog({super.key, required this.onSave});

  @override
  State<AcopioFormDialog> createState() => _AcopioFormDialogState();
}

class _AcopioFormDialogState extends State<AcopioFormDialog> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final _producerController = TextEditingController();
  final _lotController = TextEditingController();
  final _grossWeightController = TextEditingController();
  final _netWeightController = TextEditingController();
  final _humidityController = TextEditingController();
  final _classificationController = TextEditingController();
  final _warehouseController = TextEditingController();
  final _shelfController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _selectedStatus = 'Pendiente';

  final List<String> _statusOptions = [
    'Pendiente',
    'En revisión',
    'Clasificado',
    'Almacenado',
    'Vendido',
  ];

  final List<String> _classificationOptions = [
    'Especialidad',
    'Primera',
    'Segunda',
    'Tercera',
    'Pendiente',
  ];

  @override
  void dispose() {
    _producerController.dispose();
    _lotController.dispose();
    _grossWeightController.dispose();
    _netWeightController.dispose();
    _humidityController.dispose();
    _classificationController.dispose();
    _warehouseController.dispose();
    _shelfController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryGreen,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final acopio = AcopioModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        producerName: _producerController.text.trim(),
        lotName: _lotController.text.trim(),
        date: _selectedDate,
        grossWeight: double.parse(_grossWeightController.text),
        netWeight: double.parse(_netWeightController.text),
        humidity: double.parse(_humidityController.text),
        classification: _classificationController.text.trim(),
        status: _getStatusFromString(_selectedStatus),
        warehouse: _warehouseController.text.trim(),
        shelf: _shelfController.text.trim(),
      );

      widget.onSave(acopio);
      Navigator.pop(context);
    }
  }

  AcopioStatus _getStatusFromString(String status) {
    switch (status) {
      case 'Pendiente': return AcopioStatus.pending;
      case 'En revisión': return AcopioStatus.inReview;
      case 'Clasificado': return AcopioStatus.classified;
      case 'Almacenado': return AcopioStatus.stored;
      case 'Vendido': return AcopioStatus.sold;
      default: return AcopioStatus.pending;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final cardColor = isDark ? AppTheme.coffeeDeep : Colors.white;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      backgroundColor: cardColor,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.inventory,
                        color: AppTheme.primaryGreen,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Registrar Acopio',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Productor
                _buildTextField(
                  label: 'Productor',
                  controller: _producerController,
                  icon: Icons.person,
                  hintText: 'Juan Pérez',
                ),
                const SizedBox(height: 16),

                // Lote
                _buildTextField(
                  label: 'Lote',
                  controller: _lotController,
                  icon: Icons.coffee,
                  hintText: 'Lote Norte',
                ),
                const SizedBox(height: 16),

                // Fecha
                _buildDateField(
                  label: 'Fecha de entrega',
                  date: _selectedDate,
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: 16),

                // Peso bruto y neto (Row)
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: 'Peso bruto (kg)',
                        controller: _grossWeightController,
                        icon: Icons.monitor_weight,
                        hintText: '620',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        label: 'Peso neto (kg)',
                        controller: _netWeightController,
                        icon: Icons.monitor_weight,
                        hintText: '610',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Humedad
                _buildTextField(
                  label: 'Humedad (%)',
                  controller: _humidityController,
                  icon: Icons.water_drop,
                  hintText: '11.8',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                // Clasificación
                _buildDropdownField(
                  label: 'Clasificación',
                  value: _classificationController.text.isEmpty ? 'Pendiente' : _classificationController.text,
                  options: _classificationOptions,
                  onChanged: (value) {
                    setState(() {
                      _classificationController.text = value ?? '';
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Estado
                _buildDropdownField(
                  label: 'Estado',
                  value: _selectedStatus,
                  options: _statusOptions,
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value ?? 'Pendiente';
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Bodega y estante (Row)
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: 'Bodega',
                        controller: _warehouseController,
                        icon: Icons.warehouse,
                        hintText: 'A',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        label: 'Estante',
                        controller: _shelfController,
                        icon: Icons.shelves,
                        hintText: '12',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Botones
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Guardar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textColor.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 18, color: AppTheme.primaryGreen),
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppTheme.primaryGreen),
            ),
            filled: true,
            fillColor: isDark ? AppTheme.coffeeDark : Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Campo requerido';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textColor.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(16),
              color: isDark ? AppTheme.coffeeDark : Colors.white,
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 18, color: AppTheme.primaryGreen),
                const SizedBox(width: 12),
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> options,
    required Function(String?) onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textColor.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.arrow_drop_down, size: 18, color: AppTheme.primaryGreen),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppTheme.primaryGreen),
            ),
            filled: true,
            fillColor: isDark ? AppTheme.coffeeDark : Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          items: options.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: onChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Campo requerido';
            }
            return null;
          },
        ),
      ],
    );
  }
}