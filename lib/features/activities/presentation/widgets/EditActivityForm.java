// lib/features/activities/presentation/widgets/edit_activity_form.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/activities/data/models/activity_model.dart';

class EditActivityForm extends StatefulWidget {
  final ActivityModel activity;
  final Function(ActivityType) onTypeChanged;
  final Function(DateTime) onDateChanged;
  final Function(String) onResponsibleChanged;
  final Function(String) onDescriptionChanged;
  final Function(double) onQuantityChanged;
  final Function(String) onQuantityUnitChanged;
  final Function(double) onCostChanged;
  final Function(String) onObservationsChanged;

  const EditActivityForm({
    super.key,
    required this.activity,
    required this.onTypeChanged,
    required this.onDateChanged,
    required this.onResponsibleChanged,
    required this.onDescriptionChanged,
    required this.onQuantityChanged,
    required this.onQuantityUnitChanged,
    required this.onCostChanged,
    required this.onObservationsChanged,
  });

  @override
  State<EditActivityForm> createState() => _EditActivityFormState();
}

class _EditActivityFormState extends State<EditActivityForm> {
  late ActivityType _selectedType;
  late DateTime _selectedDate;
  late String _selectedResponsible;
  late TextEditingController _descriptionController;
  late TextEditingController _quantityController;
  late String _selectedQuantityUnit;
  late TextEditingController _costController;
  late TextEditingController _observationsController;

  final List<String> _responsibleOptions = ['Productor', 'Técnico', 'Trabajador'];
  final List<String> _quantityUnits = ['kg', 'litros', 'unidades', 'horas'];

  @override
  void initState() {
    super.initState();
    _selectedType = widget.activity.type;
    _selectedDate = widget.activity.date;
    _selectedResponsible = widget.activity.responsible;
    _descriptionController = TextEditingController(text: widget.activity.description);
    _quantityController = TextEditingController(text: widget.activity.quantity.toString());
    _selectedQuantityUnit = widget.activity.quantityUnit.isNotEmpty ? widget.activity.quantityUnit : 'kg';
    _costController = TextEditingController(text: widget.activity.cost.toString());
    _observationsController = TextEditingController(text: widget.activity.observations);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _quantityController.dispose();
    _costController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: AppTheme.primaryGreen),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && mounted) {
      setState(() => _selectedDate = picked);
      widget.onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fecha de actividad
        const Text('Fecha de actividad', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.darkCoffee)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 18, color: AppTheme.primaryGreen),
                const SizedBox(width: 10),
                Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}', style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Responsable
        const Text('Responsable', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.darkCoffee)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedResponsible,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.withOpacity(0.3))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          items: _responsibleOptions.map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedResponsible = value);
              widget.onResponsibleChanged(value);
            }
          },
        ),

        const SizedBox(height: 16),

        // Descripción
        const Text('Descripción', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.darkCoffee)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descriptionController,
          maxLines: 3,
          onChanged: widget.onDescriptionChanged,
          decoration: InputDecoration(
            hintText: 'Describe la actividad realizada...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.withOpacity(0.3))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),

        const SizedBox(height: 16),

        // Cantidad aplicada
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Cantidad aplicada', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.darkCoffee)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) => widget.onQuantityChanged(double.tryParse(value) ?? 0),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.withOpacity(0.3))),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Unidad', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.darkCoffee)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedQuantityUnit,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.withOpacity(0.3))),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    items: _quantityUnits.map((unit) => DropdownMenuItem(value: unit, child: Text(unit))).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedQuantityUnit = value);
                        widget.onQuantityUnitChanged(value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Costo asociado
        const Text('Costo asociado (MXN)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.darkCoffee)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _costController,
          keyboardType: TextInputType.number,
          onChanged: (value) => widget.onCostChanged(double.tryParse(value) ?? 0),
          decoration: InputDecoration(
            prefixText: '\$ ',
            hintText: '0.00',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.withOpacity(0.3))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),

        const SizedBox(height: 16),

        // Duración (opcional)
        const Text('Duración (horas)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.darkCoffee)),
        const SizedBox(height: 8),
        TextFormField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Horas invertidas',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.withOpacity(0.3))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),

        const SizedBox(height: 16),

        // Observaciones
        const Text('Observaciones adicionales', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.darkCoffee)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _observationsController,
          maxLines: 2,
          onChanged: widget.onObservationsChanged,
          decoration: InputDecoration(
            hintText: 'Observaciones adicionales...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.withOpacity(0.3))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }
}