import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/activities/data/models/activity_model.dart';
import 'package:kaabcafe/features/activities/presentation/providers/activities_provider.dart';
import 'package:kaabcafe/features/activities/presentation/widgets/activity_type_card.dart';
import 'package:kaabcafe/features/activities/presentation/widgets/evidence_uploader.dart';
import 'package:kaabcafe/features/activities/presentation/widgets/traceability_summary.dart';
import 'package:kaabcafe/features/farms/data/models/lot_model.dart';
import 'package:kaabcafe/features/farms/data/models/farm_details_model.dart';
import 'package:kaabcafe/features/activities/domain/entities/activity_entity.dart';

class RegisterActivityScreen extends StatefulWidget {
  final LotModel lot;
  final FarmDetailsModel farm;

  const RegisterActivityScreen({
    super.key,
    required this.lot,
    required this.farm,
  });

  @override
  State<RegisterActivityScreen> createState() => _RegisterActivityScreenState();
}

class _RegisterActivityScreenState extends State<RegisterActivityScreen> {
  ActivityType? _selectedType;
  DateTime _selectedDate = DateTime.now();
  String _selectedResponsible = 'Productor';
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  String _quantityUnit = 'kg';
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _observationsController = TextEditingController();
  List<String> _evidenceImages = [];
  bool _isSaving = false;

  final List<String> _responsibleOptions = ['Productor', 'Técnico', 'Trabajador'];
  final List<String> _quantityUnits = ['kg', 'litros', 'unidades', 'horas'];

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
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryGreen,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && mounted) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveActivity() async {
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un tipo de actividad')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    // Crear la nueva actividad como ActivityEntity
    final newActivity = ActivityEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      lotId: widget.lot.id,
      lotName: widget.lot.name,
      farmId: widget.farm.id,
      farmName: widget.farm.name,
      type: _convertTypeToEntity(_selectedType!),
      status: ActivityStatusEntity.completed,
      date: _selectedDate,
      scheduledDate: null,
      responsible: _selectedResponsible,
      description: _descriptionController.text,
      quantity: double.tryParse(_quantityController.text) ?? 0,
      quantityUnit: _quantityUnit,
      cost: double.tryParse(_costController.text) ?? 0,
      evidenceUrls: _evidenceImages,
      observations: _observationsController.text,
      metadata: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Guardar usando el provider
    final provider = Provider.of<ActivitiesProvider>(context, listen: false);
    final savedActivity = await provider.createActivity(newActivity);

    setState(() {
      _isSaving = false;
    });

    if (savedActivity != null && mounted) {
      _showSuccessDialog();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al guardar la actividad'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  ActivityTypeEntity _convertTypeToEntity(ActivityType type) {
    switch (type) {
      case ActivityType.fertilization:
        return ActivityTypeEntity.fertilization;
      case ActivityType.pruning:
        return ActivityTypeEntity.pruning;
      case ActivityType.pestControl:
        return ActivityTypeEntity.pestControl;
      case ActivityType.weedControl:
        return ActivityTypeEntity.weedControl;
      case ActivityType.irrigation:
        return ActivityTypeEntity.irrigation;
      case ActivityType.harvest:
        return ActivityTypeEntity.harvest;
      case ActivityType.inspection:
        return ActivityTypeEntity.inspection;
      case ActivityType.other:
        return ActivityTypeEntity.other;
    }
  }

  void _saveDraft() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Borrador guardado'),
        backgroundColor: AppTheme.goldCoffee,
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
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
              child: const Icon(
                Icons.check_circle,
                color: AppTheme.primaryGreen,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '¡Actividad registrada!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkCoffee,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'La información ha sido añadida al historial del lote y a la trazabilidad del café.',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.darkCoffee,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      if (mounted) {
                        // Navegar a la lista de actividades
                        context.go(RouteNames.activities);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Ver actividades'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      if (mounted) {
                        _resetForm();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Registrar otra'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _selectedType = null;
      _selectedDate = DateTime.now();
      _descriptionController.clear();
      _quantityController.clear();
      _costController.clear();
      _observationsController.clear();
      _evidenceImages = [];
    });
  }

  void _goBack() {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    } else {
      context.go(RouteNames.myFarms);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightBeige,
              AppTheme.primaryGreen.withOpacity(0.03),
              AppTheme.lightBeige,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Barra superior
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _goBack,
                      icon: const Icon(Icons.arrow_back),
                      color: AppTheme.darkCoffee,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Registrar Actividad',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkCoffee,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Documenta las actividades realizadas en tu lote.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.darkCoffee.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Contenido con scroll
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Información del lote
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.agriculture, size: 18, color: AppTheme.primaryGreen),
                                const SizedBox(width: 8),
                                Text(
                                  widget.lot.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.darkCoffee,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.farm.name,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.darkCoffee.withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(Icons.location_on, size: 10, color: AppTheme.goldCoffee),
                                const SizedBox(width: 4),
                                Text(
                                  widget.farm.location,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppTheme.darkCoffee.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Tipo de actividad
                      const Text(
                        '¿Qué actividad realizaste?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.darkCoffee,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: ActivityType.values.length,
                        itemBuilder: (context, index) {
                          final type = ActivityType.values[index];
                          return ActivityTypeCard(
                            type: type,
                            isSelected: _selectedType == type,
                            onTap: () {
                              setState(() {
                                _selectedType = type;
                              });
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // Formulario
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Fecha
                            const Text(
                              'Fecha de actividad',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.darkCoffee,
                              ),
                            ),
                            const SizedBox(height: 6),
                            GestureDetector(
                              onTap: _selectDate,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_today, size: 16, color: AppTheme.primaryGreen),
                                    const SizedBox(width: 10),
                                    Text(
                                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Responsable
                            const Text(
                              'Responsable',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.darkCoffee,
                              ),
                            ),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: _selectedResponsible,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: AppTheme.primaryGreen),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                              items: _responsibleOptions.map((option) {
                                return DropdownMenuItem(
                                  value: option,
                                  child: Text(option, style: const TextStyle(fontSize: 13)),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedResponsible = value!;
                                });
                              },
                            ),

                            const SizedBox(height: 16),

                            // Descripción
                            const Text(
                              'Descripción',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.darkCoffee,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _descriptionController,
                              maxLines: 2,
                              decoration: InputDecoration(
                                hintText: 'Describe brevemente la actividad realizada...',
                                hintStyle: const TextStyle(fontSize: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: AppTheme.primaryGreen),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Cantidad aplicada
                            const Text(
                              'Cantidad aplicada',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.darkCoffee,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: _quantityController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: 'Cantidad',
                                      hintStyle: const TextStyle(fontSize: 12),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: AppTheme.primaryGreen),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: _quantityUnit,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: AppTheme.primaryGreen),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    ),
                                    items: _quantityUnits.map((unit) {
                                      return DropdownMenuItem(
                                        value: unit,
                                        child: Text(unit, style: const TextStyle(fontSize: 12)),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _quantityUnit = value!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Costo asociado
                            const Text(
                              'Costo asociado (opcional)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.darkCoffee,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _costController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                prefixText: '\$ ',
                                hintText: '0.00',
                                hintStyle: const TextStyle(fontSize: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: AppTheme.primaryGreen),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Evidencias
                      EvidenceUploader(
                        onImagesAdded: (images) {
                          setState(() {
                            _evidenceImages = images;
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      // Observaciones
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Observaciones adicionales',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.darkCoffee,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _observationsController,
                              maxLines: 2,
                              decoration: InputDecoration(
                                hintText: 'Observaciones adicionales...',
                                hintStyle: const TextStyle(fontSize: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: AppTheme.primaryGreen),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Resumen de trazabilidad
                      const TraceabilitySummary(),

                      const SizedBox(height: 24),

                      // Botones
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _saveDraft,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.goldCoffee,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                side: BorderSide(color: AppTheme.goldCoffee.withOpacity(0.5)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text('Guardar borrador'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isSaving ? null : _saveActivity,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryGreen,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: _isSaving
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                                  : const Text('Guardar actividad'),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}