// lib/features/activities/presentation/screens/edit_activity_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/activities/data/models/activity_model.dart';
import 'package:kaabcafe/features/activities/presentation/providers/activities_provider.dart';
import 'package:kaabcafe/features/activities/presentation/widgets/activity_type_card.dart';
import 'package:kaabcafe/features/activities/presentation/widgets/evidence_uploader.dart';
import 'package:kaabcafe/features/activities/presentation/widgets/change_history_timeline.dart';
import 'package:kaabcafe/features/activities/presentation/widgets/traceability_impact_card.dart';
import 'package:kaabcafe/features/activities/domain/entities/activity_entity.dart';
import 'package:kaabcafe/features/farms/data/models/lot_model.dart';
import 'package:kaabcafe/features/farms/data/models/farm_details_model.dart';

class EditActivityScreen extends StatefulWidget {
  final ActivityModel activity;
  final LotModel lot;
  final FarmDetailsModel farm;

  const EditActivityScreen({
    super.key,
    required this.activity,
    required this.lot,
    required this.farm,
  });

  @override
  State<EditActivityScreen> createState() => _EditActivityScreenState();
}

class _EditActivityScreenState extends State<EditActivityScreen> {
  late ActivityType _selectedType;
  late DateTime _selectedDate;
  late String _selectedResponsible;
  late TextEditingController _descriptionController;
  late TextEditingController _quantityController;
  late String _quantityUnit;
  late TextEditingController _costController;
  late TextEditingController _durationController;
  late TextEditingController _observationsController;
  late List<String> _evidenceImages;
  bool _isSaving = false;

  final List<String> _responsibleOptions = ['Productor', 'Técnico', 'Trabajador'];
  final List<String> _quantityUnits = ['kg', 'litros', 'unidades', 'horas'];

  // ✅ Historial de cambios vacío
  final List<Map<String, dynamic>> _changeHistory = [];

  @override
  void initState() {
    super.initState();

    // ✅ Valores por defecto si la actividad está vacía
    _selectedType = widget.activity.type;
    _selectedDate = widget.activity.date;

    final responsible = widget.activity.responsible;
    _selectedResponsible = _responsibleOptions.contains(responsible) ? responsible : 'Productor';

    _descriptionController = TextEditingController(text: widget.activity.description.isNotEmpty
        ? widget.activity.description
        : '');
    _quantityController = TextEditingController(text: widget.activity.quantity > 0
        ? widget.activity.quantity.toString()
        : '');
    _quantityUnit = widget.activity.quantityUnit.isNotEmpty ? widget.activity.quantityUnit : 'kg';
    _costController = TextEditingController(text: widget.activity.cost > 0
        ? widget.activity.cost.toString()
        : '');
    _durationController = TextEditingController(text: '');
    _observationsController = TextEditingController(text: widget.activity.observations.isNotEmpty
        ? widget.activity.observations
        : '');
    _evidenceImages = List.from(widget.activity.evidenceUrls);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _quantityController.dispose();
    _costController.dispose();
    _durationController.dispose();
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
    }
  }

  void _saveChanges() async {
    // Validación: al menos debe tener descripción o tipo
    if (_descriptionController.text.trim().isEmpty && _selectedType == ActivityType.other) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa la descripción de la actividad'),
          backgroundColor: AppTheme.alertOrange,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final updatedActivity = ActivityModel(
      id: widget.activity.id,
      type: _selectedType,
      status: widget.activity.status,
      date: _selectedDate,
      responsible: _selectedResponsible,
      description: _descriptionController.text,
      quantity: double.tryParse(_quantityController.text) ?? 0,
      quantityUnit: _quantityUnit,
      cost: double.tryParse(_costController.text) ?? 0,
      evidenceUrls: _evidenceImages,
      observations: _observationsController.text,
    );

    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isSaving = false);
    _showConfirmDialog(updatedActivity);
  }

  void _showConfirmDialog(ActivityModel updatedActivity) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('¿Guardar modificaciones?'),
        content: const Text(
          'Los cambios se reflejarán en el historial del lote y en los indicadores asociados.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _showSuccessDialog(updatedActivity);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryGreen),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(ActivityModel updatedActivity) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, color: AppTheme.primaryGreen, size: 48),
            ),
            const SizedBox(height: 24),
            const Text(
              '¡Actividad actualizada!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.darkCoffee),
            ),
            const SizedBox(height: 12),
            const Text(
              'La información ha sido actualizada correctamente.',
              style: TextStyle(fontSize: 14, color: AppTheme.darkCoffee),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      context.pop();
                    },
                    child: const Text('Volver'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      context.go(RouteNames.activities);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryGreen),
                    child: const Text('Ver actividades'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('¿Eliminar actividad?'),
        content: const Text(
          'Esta acción eliminará la actividad del historial del lote. No se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Actividad eliminada'), backgroundColor: Colors.red),
              );
              context.go(RouteNames.activities);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBeige,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoCard(),
                    const SizedBox(height: 20),
                    _buildActivityTypeSection(),
                    const SizedBox(height: 20),
                    _buildFormCard(),
                    const SizedBox(height: 20),
                    EvidenceUploader(
                      initialImages: _evidenceImages,
                      onImagesAdded: (images) => setState(() => _evidenceImages = images),
                    ),
                    const SizedBox(height: 20),
                    _buildObservationsCard(),
                    const SizedBox(height: 20),
                    // ✅ Historial de cambios vacío
                    ChangeHistoryTimeline(history: _changeHistory),
                    const SizedBox(height: 20),
                    const TraceabilityImpactCard(),
                    const SizedBox(height: 20),
                    _buildSummaryCard(),
                    const SizedBox(height: 24),
                    _buildActionButtons(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: Icon(Icons.arrow_back, color: AppTheme.darkCoffee),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Editar Actividad',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.darkCoffee),
                ),
                const SizedBox(height: 2),
                Text(
                  'Actualiza la información registrada.',
                  style: TextStyle(fontSize: 12, color: AppTheme.darkCoffee.withOpacity(0.6)),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppTheme.primaryGreen, AppTheme.secondaryGreen]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextButton(
              onPressed: _isSaving ? null : _saveChanges,
              style: TextButton.styleFrom(foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
              child: _isSaving
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                  : const Text('Guardar'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: _selectedType.color.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
                child: Icon(_selectedType.icon, size: 22, color: _selectedType.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_selectedType.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.darkCoffee)),
                    Text(widget.lot.name, style: TextStyle(fontSize: 13, color: AppTheme.darkCoffee.withOpacity(0.6))),
                    Text(widget.farm.name, style: TextStyle(fontSize: 12, color: AppTheme.darkCoffee.withOpacity(0.5))),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.activity.status == ActivityStatus.completed ? AppTheme.primaryGreen.withOpacity(0.1) : AppTheme.alertOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.activity.status == ActivityStatus.completed ? 'Completada' : 'Pendiente',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: widget.activity.status == ActivityStatus.completed ? AppTheme.primaryGreen : AppTheme.alertOrange),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: AppTheme.goldCoffee),
              const SizedBox(width: 6),
              Text('Actividad registrada el ${_formatDate(widget.activity.date)}', style: TextStyle(fontSize: 12, color: AppTheme.darkCoffee.withOpacity(0.6))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTypeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tipo de actividad', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.darkCoffee)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 0.75),
            itemCount: ActivityType.values.length,
            itemBuilder: (context, index) {
              final type = ActivityType.values[index];
              return ActivityTypeCard(
                type: type,
                isSelected: _selectedType == type,
                onTap: () => setState(() => _selectedType = type),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateField(),
          const SizedBox(height: 16),
          _buildResponsibleField(),
          const SizedBox(height: 16),
          _buildDescriptionField(),
          const SizedBox(height: 16),
          _buildQuantityField(),
          const SizedBox(height: 16),
          _buildCostField(),
          const SizedBox(height: 16),
          _buildDurationField(),
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }

  Widget _buildResponsibleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            }
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Descripción', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.darkCoffee)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Describe la actividad realizada...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.withOpacity(0.3))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityField() {
    return Row(
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
                value: _quantityUnit,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.withOpacity(0.3))),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                items: _quantityUnits.map((unit) => DropdownMenuItem(value: unit, child: Text(unit))).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _quantityUnit = value);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCostField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Costo asociado (MXN)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.darkCoffee)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _costController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            prefixText: '\$ ',
            hintText: '0.00',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.withOpacity(0.3))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildDurationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Duración (horas)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.darkCoffee)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _durationController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Horas invertidas',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.withOpacity(0.3))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildObservationsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Observaciones adicionales', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.darkCoffee)),
          const SizedBox(height: 12),
          TextFormField(
            controller: _observationsController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Observaciones adicionales...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.withOpacity(0.3))),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppTheme.primaryGreen.withOpacity(0.05), AppTheme.goldCoffee.withOpacity(0.02)]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Resumen actualizado', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCoffee)),
          const SizedBox(height: 12),
          _buildSummaryRow(Icons.assignment, 'Actividad', _selectedType.title),
          _buildSummaryRow(Icons.landscape, 'Lote', widget.lot.name),
          _buildSummaryRow(Icons.calendar_today, 'Fecha', '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
          _buildSummaryRow(Icons.attach_money, 'Costo', '\$${_costController.text.isEmpty ? '0' : _costController.text} MXN'),
          _buildSummaryRow(Icons.person, 'Responsable', _selectedResponsible),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppTheme.primaryGreen),
          const SizedBox(width: 12),
          SizedBox(width: 80, child: Text(label, style: TextStyle(fontSize: 12, color: AppTheme.darkCoffee.withOpacity(0.6)))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.darkCoffee))),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _saveChanges,
            icon: const Icon(Icons.save_rounded),
            label: const Text('Guardar Cambios', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close_rounded),
            label: const Text('Cancelar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.darkCoffee,
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: AppTheme.darkCoffee.withOpacity(0.2)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _confirmDelete,
            icon: const Icon(Icons.delete_outline),
            label: const Text('Eliminar Actividad', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) => '${date.day} de ${_getMonthName(date.month)} de ${date.year}';
  String _getMonthName(int month) => ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'][month - 1];
}