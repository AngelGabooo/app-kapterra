// lib/features/technician/presentation/widgets/lot_inspection/lot_inspection_form.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/lot_inspection/lot_info_card.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/lot_inspection/inspection_progress.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/lot_inspection/crop_health_selector.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/lot_inspection/crop_evaluation_list.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/lot_inspection/pests_checklist.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/lot_inspection/environmental_conditions.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/lot_inspection/management_checklist.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/lot_inspection/photo_gallery.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/lot_inspection/priority_selector.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/lot_inspection/ai_assistant_card.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/lot_inspection/inspection_summary_card.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/lot_inspection/section_title.dart';

class LotInspectionForm extends StatefulWidget {
  final bool isDark;
  final String lotName;
  final String farmName;
  final String producerName;
  final String location;
  final Function(Map<String, dynamic>) onSave;
  final VoidCallback onSaveDraft;

  const LotInspectionForm({
    super.key,
    required this.isDark,
    required this.lotName,
    required this.farmName,
    required this.producerName,
    required this.location,
    required this.onSave,
    required this.onSaveDraft,
  });

  @override
  State<LotInspectionForm> createState() => _LotInspectionFormState();
}

class _LotInspectionFormState extends State<LotInspectionForm> {
  // ── Estado general del cultivo ──────────────────────────────
  int _cropHealth = 2;

  // ── Evaluación del cultivo ──────────────────────────────────
  final List<Map<String, dynamic>> _cropEvaluation = [
    {'label': '🌱 Estado vegetativo', 'value': 1},
    {'label': '🍃 Color de hojas', 'value': 1},
    {'label': '🌸 Floración', 'value': 1},
    {'label': '🍒 Fructificación', 'value': 1},
    {'label': '🌳 Desarrollo de ramas', 'value': 1},
  ];

  // ── Sanidad del cultivo ──────────────────────────────────────
  final List<Map<String, dynamic>> _pests = [
    {'label': 'Roya', 'checked': false},
    {'label': 'Broca', 'checked': false},
    {'label': 'Minador', 'checked': false},
    {'label': 'Ojo de gallo', 'checked': false},
    {'label': 'Mancha de hierro', 'checked': false},
    {'label': 'Deficiencia nutricional', 'checked': false},
    {'label': 'Ninguna', 'checked': false},
  ];
  double _affectionPercentage = 0;

  // ── Condiciones ambientales ──────────────────────────────────
  double _temperature = 25;
  double _humidity = 65;
  int _weatherCondition = 0;
  int _shadeLevel = 2;
  int _irrigationStatus = 1;

  // ── Fertilización y manejo ──────────────────────────────────
  final List<Map<String, dynamic>> _management = [
    {'label': '🧪 Fertilización adecuada', 'value': 1},
    {'label': '🌿 Control de malezas', 'value': 1},
    {'label': '🛡 Manejo fitosanitario', 'value': 1},
    {'label': '✂ Estado de poda', 'value': 1},
  ];

  // ── Evidencias ──────────────────────────────────────────────
  final List<String> _photos = [];

  // ── Observaciones ────────────────────────────────────────────
  final TextEditingController _observationsController = TextEditingController();

  // ── Nivel de prioridad ──────────────────────────────────────
  int _priorityLevel = 1;

  // ── Progreso ──────────────────────────────────────────────────
  double _progress = 0.0;

  final List<String> _cropHealthOptions = [
    'Excelente', 'Bueno', 'Regular', 'Requiere atención', 'Crítico'
  ];

  @override
  void dispose() {
    _observationsController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    int completed = 0;
    int total = 0;

    if (_cropHealth != 2) completed++;
    total++;

    for (var item in _cropEvaluation) {
      total++;
      if (item['value'] != 1) completed++;
    }

    total++;
    if (_pests.any((p) => p['checked'] == true)) completed++;

    total++;
    if (_temperature != 25 || _humidity != 65 || _weatherCondition != 0) completed++;

    for (var item in _management) {
      total++;
      if (item['value'] != 1) completed++;
    }

    total++;
    if (_observationsController.text.isNotEmpty) completed++;

    setState(() {
      _progress = total > 0 ? completed / total : 0;
    });
  }

  void _togglePest(int index) {
    setState(() {
      if (_pests[index]['label'] == 'Ninguna') {
        for (var pest in _pests) {
          pest['checked'] = false;
        }
        _pests[index]['checked'] = true;
      } else {
        _pests[index]['checked'] = !_pests[index]['checked'];
        _pests.last['checked'] = false;
      }
      _updateProgress();
    });
  }

  void _submitForm() {
    final data = {
      'lotName': widget.lotName,
      'farmName': widget.farmName,
      'producerName': widget.producerName,
      'location': widget.location,
      'cropHealth': _cropHealthOptions[_cropHealth],
      'cropEvaluation': _cropEvaluation,
      'pests': _pests,
      'affectionPercentage': _affectionPercentage,
      'temperature': _temperature,
      'humidity': _humidity,
      'weather': _weatherCondition,
      'shadeLevel': _shadeLevel,
      'irrigation': _irrigationStatus,
      'management': _management,
      'photos': _photos,
      'observations': _observationsController.text,
      'priority': _priorityLevel,
    };
    widget.onSave(data);
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: widget.isDark ? AppTheme.coffeeDeep : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
                child: Icon(
                  Icons.health_and_safety_outlined,
                  size: 48,
                  color: AppTheme.primaryGreen,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '¿Finalizar inspección?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: widget.isDark ? Colors.white : AppTheme.darkCoffee,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'La información registrada será utilizada para generar un diagnóstico técnico del lote.',
                style: TextStyle(
                  fontSize: 14,
                  color: (widget.isDark ? Colors.white : AppTheme.darkCoffee).withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: (widget.isDark ? Colors.white : AppTheme.darkCoffee).withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          color: widget.isDark ? Colors.white : AppTheme.darkCoffee,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _submitForm();
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
                      child: const Text('Generar Diagnóstico'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDark ? Colors.white : AppTheme.darkCoffee;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Información del lote', isDark: widget.isDark),
        const SizedBox(height: 8),
        LotInfoCard(
          isDark: widget.isDark,
          lotName: widget.lotName,
          farmName: widget.farmName,
          producerName: widget.producerName,
          location: widget.location,
        ),
        const SizedBox(height: 20),

        SectionTitle(title: 'Progreso de la inspección', isDark: widget.isDark),
        const SizedBox(height: 8),
        InspectionProgress(
          isDark: widget.isDark,
          progress: _progress,
        ),
        const SizedBox(height: 20),

        SectionTitle(title: 'Estado general del cultivo', isDark: widget.isDark),
        const SizedBox(height: 8),
        CropHealthSelector(
          isDark: widget.isDark,
          value: _cropHealth,
          onChanged: (value) {
            setState(() {
              _cropHealth = value;
              _updateProgress();
            });
          },
        ),
        const SizedBox(height: 20),

        SectionTitle(title: 'Evaluación del cultivo', isDark: widget.isDark),
        const SizedBox(height: 8),
        CropEvaluationList(
          isDark: widget.isDark,
          items: _cropEvaluation,
          onChanged: (index, value) {
            setState(() {
              _cropEvaluation[index]['value'] = value;
              _updateProgress();
            });
          },
        ),
        const SizedBox(height: 20),

        SectionTitle(title: 'Sanidad del cultivo', isDark: widget.isDark),
        const SizedBox(height: 8),
        PestsChecklist(
          isDark: widget.isDark,
          pests: _pests,
          affectionPercentage: _affectionPercentage,
          onPestToggled: _togglePest,
          onPercentageChanged: (value) {
            setState(() => _affectionPercentage = value);
          },
        ),
        const SizedBox(height: 20),

        SectionTitle(title: 'Condiciones ambientales', isDark: widget.isDark),
        const SizedBox(height: 8),
        EnvironmentalConditions(
          isDark: widget.isDark,
          temperature: _temperature,
          humidity: _humidity,
          weatherCondition: _weatherCondition,
          shadeLevel: _shadeLevel,
          irrigationStatus: _irrigationStatus,
          onTemperatureChanged: (v) {
            setState(() {
              _temperature = v;
              _updateProgress();
            });
          },
          onHumidityChanged: (v) {
            setState(() {
              _humidity = v;
              _updateProgress();
            });
          },
          onWeatherChanged: (v) {
            setState(() {
              _weatherCondition = v;
              _updateProgress();
            });
          },
          onShadeChanged: (v) {
            setState(() {
              _shadeLevel = v;
              _updateProgress();
            });
          },
          onIrrigationChanged: (v) {
            setState(() {
              _irrigationStatus = v;
              _updateProgress();
            });
          },
        ),
        const SizedBox(height: 20),

        SectionTitle(title: 'Fertilización y manejo', isDark: widget.isDark),
        const SizedBox(height: 8),
        ManagementChecklist(
          isDark: widget.isDark,
          items: _management,
          onChanged: (index, value) {
            setState(() {
              _management[index]['value'] = value;
              _updateProgress();
            });
          },
        ),
        const SizedBox(height: 20),

        SectionTitle(title: 'Evidencias fotográficas', isDark: widget.isDark),
        const SizedBox(height: 8),
        PhotoGallery(
          isDark: widget.isDark,
          photos: _photos,
          onAddPhoto: () {
            setState(() => _photos.add('📷 Foto ${_photos.length + 1}'));
          },
          onAddImage: () {
            setState(() => _photos.add('🖼 Imagen ${_photos.length + 1}'));
          },
          onRemovePhoto: (index) {
            setState(() => _photos.removeAt(index));
          },
        ),
        const SizedBox(height: 20),

        SectionTitle(title: 'Observaciones técnicas', isDark: widget.isDark),
        const SizedBox(height: 8),
        _buildObservationsField(),
        const SizedBox(height: 20),

        SectionTitle(title: 'Nivel de prioridad', isDark: widget.isDark),
        const SizedBox(height: 8),
        PrioritySelector(
          isDark: widget.isDark,
          value: _priorityLevel,
          onChanged: (value) {
            setState(() {
              _priorityLevel = value;
              _updateProgress();
            });
          },
        ),
        const SizedBox(height: 20),

        SectionTitle(title: 'Asistente IA', isDark: widget.isDark),
        const SizedBox(height: 8),
        AIAssistantCard(isDark: widget.isDark),
        const SizedBox(height: 20),

        SectionTitle(title: 'Resumen automático', isDark: widget.isDark),
        const SizedBox(height: 8),
        InspectionSummaryCard(
          isDark: widget.isDark,
          cropHealth: _cropHealth,
          pests: _pests,
          photosCount: _photos.length,
          hasObservations: _observationsController.text.isNotEmpty,
          priority: _priorityLevel,
        ),
        const SizedBox(height: 24),

        _buildActionButtons(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildObservationsField() {
    final textColor = widget.isDark ? Colors.white : AppTheme.darkCoffee;

    return Container(
      decoration: BoxDecoration(
        color: widget.isDark
            ? AppTheme.coffeeDeep.withOpacity(0.7)
            : const Color(0xFFE8E0D5).withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: textColor.withOpacity(0.06),
          width: 0.5,
        ),
        boxShadow: const [],
      ),
      padding: const EdgeInsets.all(14),
      child: TextFormField(
        controller: _observationsController,
        maxLines: 4,
        style: TextStyle(color: textColor, fontSize: 14),
        onChanged: (_) => _updateProgress(),
        decoration: InputDecoration(
          hintText: 'Describe los hallazgos observados durante la inspección...',
          hintStyle: TextStyle(color: textColor.withOpacity(0.4), fontSize: 14),
          border: InputBorder.none,
          counterText: '',
        ),
        maxLength: 500,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: widget.onSaveDraft,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.goldCoffee,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              side: BorderSide(
                color: AppTheme.goldCoffee.withOpacity(0.4),
                width: 1.5,
              ),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.save_outlined, size: 16),
                SizedBox(width: 6),
                Text(
                  'Guardar borrador',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _showConfirmDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.health_and_safety_outlined, size: 16),
                SizedBox(width: 6),
                Text(
                  'Generar Diagnóstico',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}