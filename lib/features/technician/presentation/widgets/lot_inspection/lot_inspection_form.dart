// lib/features/technician/presentation/widgets/lot_inspection/lot_inspection_form.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/providers/farm_provider.dart';
import 'package:kaabcafe/core/providers/user_provider.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/technician/providers/technician_producers_provider.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/lot_inspection/lot_info_card.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/lot_inspection/inspection_progress.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/lot_inspection/crop_health_selector.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/lot_inspection/crop_evaluation_list.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/lot_inspection/pests_checklist.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/lot_inspection/environmental_conditions.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/lot_inspection/management_checklist.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/lot_inspection/priority_selector.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/lot_inspection/ai_assistant_card.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/lot_inspection/inspection_summary_card.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/lot_inspection/section_title.dart';
import 'package:kaabcafe/features/farms/data/models/farm_details_model.dart';
import 'package:kaabcafe/features/farms/data/models/lot_model.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import '../../../data/models/technician_model.dart';

class LotInspectionForm extends StatefulWidget {
  final bool isDark;
  final String lotName;
  final String farmName;
  final String producerName;
  final String location;
  final String? producerId;
  final Function(Map<String, dynamic>) onSave;
  final VoidCallback onSaveDraft;

  const LotInspectionForm({
    super.key,
    required this.isDark,
    required this.lotName,
    required this.farmName,
    required this.producerName,
    required this.location,
    this.producerId,
    required this.onSave,
    required this.onSaveDraft,
  });

  @override
  State<LotInspectionForm> createState() => _LotInspectionFormState();
}

class _LotInspectionFormState extends State<LotInspectionForm> {
  // ── SELECTOR DE PRODUCTOR ────────────────────────────────────
  String? _selectedProducerId;
  TechnicianProducerModel? _selectedProducer;

  // ── SELECTOR DE FINCA ──────────────────────────────────────
  String? _selectedFarmId;
  String? _selectedFarmName;
  List<FarmDetailsModel> _availableFarms = [];

  // ── SELECTOR DE LOTE ──────────────────────────────────────
  String? _selectedLotName;
  List<LotModel> _availableLots = [];

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
  void initState() {
    super.initState();

    if (widget.producerName != null && widget.producerName!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final producersProvider = Provider.of<TechnicianProducersProvider>(context, listen: false);
        try {
          final producer = producersProvider.producers.firstWhere(
                (p) => p.name == widget.producerName,
          );
          setState(() {
            _selectedProducerId = producer.id;
            _selectedProducer = producer;
            _loadFarmsAndLots(producer);
          });
        } catch (e) {
          debugPrint('⚠️ Productor no encontrado: ${widget.producerName}');
        }
      });
    }

    if (widget.lotName != null && widget.lotName!.isNotEmpty) {
      _selectedLotName = widget.lotName;
    }
    if (widget.farmName != null && widget.farmName!.isNotEmpty) {
      _selectedFarmName = widget.farmName;
    }
  }

  @override
  void dispose() {
    _observationsController.dispose();
    super.dispose();
  }

  void _loadFarmsAndLots(TechnicianProducerModel producer) {
    final farmProvider = Provider.of<FarmProvider>(context, listen: false);

    final producerId = producer.email.isNotEmpty ? producer.email : producer.id;
    final farms = farmProvider.getFarmsByProducer(producerId);

    debugPrint('🔍 Fincas encontradas para ${producer.name}: ${farms.length}');

    setState(() {
      _availableFarms = farms;
      if (farms.isNotEmpty) {
        _selectedFarmId = farms.first.id;
        _selectedFarmName = farms.first.name;
        _loadLotsForFarm(farms.first.id);
      } else {
        _availableLots = [];
        if (producer.farmName != null && producer.farmName!.isNotEmpty) {
          _selectedFarmName = producer.farmName;
        }
        if (producer.lotName != null && producer.lotName!.isNotEmpty) {
          _selectedLotName = producer.lotName;
        }
      }
    });
  }

  void _loadLotsForFarm(String farmId) {
    final farmProvider = Provider.of<FarmProvider>(context, listen: false);
    final lots = farmProvider.getLotsForFarm(farmId);

    debugPrint('🔍 Lotes encontrados para finca: ${lots.length}');

    setState(() {
      _availableLots = lots;
      if (lots.isNotEmpty) {
        _selectedLotName = lots.first.name;
        debugPrint('✅ Lote seleccionado automáticamente: $_selectedLotName');
      } else {
        _selectedLotName = null;
      }
    });
  }

  int _getLotsCountForFarm(String farmId) {
    final farmProvider = Provider.of<FarmProvider>(context, listen: false);
    return farmProvider.getLotsForFarm(farmId).length;
  }

  void _updateProgress() {
    int completed = 0;
    int total = 0;

    if (_selectedProducerId != null) completed++;
    total++;

    if (_selectedFarmId != null) completed++;
    total++;

    if (_selectedLotName != null) completed++;
    total++;

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

  bool _isFormComplete() {
    if (_selectedProducerId == null) return false;
    if (_selectedFarmId == null) return false;
    if (_selectedLotName == null) return false;
    if (_observationsController.text.trim().isEmpty) return false;
    return true;
  }

  void _submitForm() {
    if (!_isFormComplete()) {
      _showValidationDialog();
      return;
    }

    final data = {
      'producerName': _selectedProducer?.name ?? widget.producerName,
      'producerId': _selectedProducerId,
      'farmName': _selectedFarmName ?? widget.farmName,
      'farmId': _selectedFarmId,
      'lotName': _selectedLotName ?? widget.lotName,
      'location': _selectedProducer?.location ?? widget.location,
      'cropHealth': _cropHealthOptions[_cropHealth],
      'cropHealthIndex': _cropHealth,
      'cropEvaluation': _cropEvaluation,
      'pests': _pests,
      'affectionPercentage': _affectionPercentage,
      'temperature': _temperature,
      'humidity': _humidity,
      'weather': _weatherCondition,
      'shadeLevel': _shadeLevel,
      'irrigation': _irrigationStatus,
      'management': _management,
      'observations': _observationsController.text,
      'priority': _priorityLevel,
    };

    widget.onSave(data);
    _navigateToDiagnosis(data);
  }

  void _navigateToDiagnosis(Map<String, dynamic> inspectionData) {
    context.push(
      RouteNames.technicianCropDiagnosis,
      extra: {
        'inspectionData': inspectionData,
        'lotName': inspectionData['lotName'],
        'farmName': inspectionData['farmName'],
        'producerName': inspectionData['producerName'],
        'location': inspectionData['location'],
        'producerId': inspectionData['producerId'],
      },
    );
  }

  void _showValidationDialog() {
    List<String> errors = [];

    if (_selectedProducerId == null) errors.add('• Selecciona un productor');
    if (_selectedFarmId == null) errors.add('• Selecciona una finca');
    if (_selectedLotName == null) errors.add('• Selecciona un lote');
    if (_observationsController.text.trim().isEmpty) errors.add('• Agrega observaciones técnicas');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '⚠️ Información incompleta',
          style: TextStyle(
            color: widget.isDark ? Colors.white : AppTheme.darkCoffee,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: errors.map((error) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              error,
              style: TextStyle(
                color: widget.isDark ? Colors.white.withOpacity(0.8) : AppTheme.darkCoffee.withOpacity(0.8),
              ),
            ),
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Completar'),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog() {
    if (!_isFormComplete()) {
      _showValidationDialog();
      return;
    }

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

  // ── WIDGETS ──────────────────────────────────────────────────

  // ✅ SELECTOR DE PRODUCTOR - CORREGIDO
  Widget _buildProducerSelector() {
    final textColor = widget.isDark ? Colors.white : AppTheme.darkCoffee;
    final producersProvider = Provider.of<TechnicianProducersProvider>(context);
    final producers = producersProvider.producers;

    if (producers.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: widget.isDark ? AppTheme.coffeeDeep.withOpacity(0.7) : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.alertOrange.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.warning, color: AppTheme.alertOrange, size: 28),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'No tienes productores asignados',
                    style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    'La cooperativa debe asignarte un productor.',
                    style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: widget.isDark ? AppTheme.coffeeDeep.withOpacity(0.7) : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: textColor.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seleccionar productor *',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: textColor.withOpacity(0.1),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedProducerId,
                isExpanded: true,
                hint: Row(
                  children: [
                    Icon(Icons.person, color: textColor.withOpacity(0.4), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Selecciona un productor',
                      style: TextStyle(color: textColor.withOpacity(0.4), fontSize: 12),
                    ),
                  ],
                ),
                dropdownColor: widget.isDark ? AppTheme.coffeeDeep : Colors.white,
                style: TextStyle(color: textColor, fontSize: 12),
                icon: Icon(Icons.arrow_drop_down, color: textColor.withOpacity(0.5), size: 28),
                items: producers.map((producer) {
                  return DropdownMenuItem(
                    value: producer.id,
                    child: Row(
                      children: [
                        Icon(Icons.person, size: 14, color: AppTheme.primaryGreen),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                producer.name,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '📍 ${producer.location}',
                                style: TextStyle(fontSize: 9, color: textColor.withOpacity(0.5)),
                              ),
                              Text(
                                '🌱 ${producer.farmsCount} fincas • ☕ ${producer.lotsCount} lotes',
                                style: TextStyle(fontSize: 8, color: textColor.withOpacity(0.3)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProducerId = value;
                    _selectedProducer = producers.firstWhere((p) => p.id == value);
                    _loadFarmsAndLots(_selectedProducer!);
                    _updateProgress();
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ SELECTOR DE FINCA - CORREGIDO
  Widget _buildFarmSelector() {
    final textColor = widget.isDark ? Colors.white : AppTheme.darkCoffee;

    if (_selectedProducerId == null) {
      return const SizedBox.shrink();
    }

    if (_availableFarms.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: widget.isDark ? AppTheme.coffeeDeep.withOpacity(0.7) : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.alertOrange.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(Icons.warning, color: AppTheme.alertOrange, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Este productor no tiene fincas registradas',
                style: TextStyle(
                  fontSize: 12,
                  color: textColor.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: widget.isDark ? AppTheme.coffeeDeep.withOpacity(0.7) : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: textColor.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seleccionar finca *',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: textColor.withOpacity(0.1),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedFarmId,
                isExpanded: true,
                hint: Row(
                  children: [
                    Icon(Icons.landscape, color: textColor.withOpacity(0.4), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Selecciona una finca',
                      style: TextStyle(color: textColor.withOpacity(0.4), fontSize: 12),
                    ),
                  ],
                ),
                dropdownColor: widget.isDark ? AppTheme.coffeeDeep : Colors.white,
                style: TextStyle(color: textColor, fontSize: 12),
                icon: Icon(Icons.arrow_drop_down, color: textColor.withOpacity(0.5), size: 28),
                items: _availableFarms.map((farm) {
                  final lotCount = _getLotsCountForFarm(farm.id);
                  return DropdownMenuItem(
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
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '📍 ${farm.location} • ${farm.hectares} ha • $lotCount lotes',
                                style: TextStyle(fontSize: 9, color: textColor.withOpacity(0.5)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFarmId = value;
                    final farm = _availableFarms.firstWhere((f) => f.id == value);
                    _selectedFarmName = farm.name;
                    _loadLotsForFarm(value!);
                    _updateProgress();
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ SELECTOR DE LOTE - CORREGIDO
  Widget _buildLotSelector() {
    final textColor = widget.isDark ? Colors.white : AppTheme.darkCoffee;

    if (_selectedFarmId == null || _availableFarms.isEmpty) {
      return const SizedBox.shrink();
    }

    if (_availableLots.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: widget.isDark ? AppTheme.coffeeDeep.withOpacity(0.7) : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.alertOrange.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: AppTheme.alertOrange, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Esta finca no tiene lotes registrados',
                style: TextStyle(
                  fontSize: 12,
                  color: textColor.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: widget.isDark ? AppTheme.coffeeDeep.withOpacity(0.7) : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: textColor.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seleccionar lote *',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: textColor.withOpacity(0.1),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedLotName,
                isExpanded: true,
                hint: Row(
                  children: [
                    Icon(Icons.view_module, color: textColor.withOpacity(0.4), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      _availableLots.isEmpty ? 'No hay lotes disponibles' : 'Selecciona un lote',
                      style: TextStyle(color: textColor.withOpacity(0.4), fontSize: 12),
                    ),
                  ],
                ),
                dropdownColor: widget.isDark ? AppTheme.coffeeDeep : Colors.white,
                style: TextStyle(color: textColor, fontSize: 12),
                icon: Icon(Icons.arrow_drop_down, color: textColor.withOpacity(0.5), size: 28),
                items: _availableLots.map((lot) {
                  return DropdownMenuItem(
                    value: lot.name,
                    child: Row(
                      children: [
                        Icon(Icons.view_module, size: 14, color: AppTheme.primaryGreen),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                lot.name,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '🌱 ${lot.variety} • ${lot.area} ha • ${lot.statusText}',
                                style: TextStyle(fontSize: 9, color: textColor.withOpacity(0.5)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLotName = value;
                    _updateProgress();
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ INFORMACIÓN DEL PRODUCTOR
  Widget _buildProducerInfo() {
    final textColor = widget.isDark ? Colors.white : AppTheme.darkCoffee;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.isDark ? AppTheme.coffeeDeep.withOpacity(0.7) : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: textColor.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person, color: AppTheme.primaryGreen, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _selectedProducer?.name ?? 'Productor no seleccionado',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  '📍 ${_selectedProducer?.location ?? widget.location ?? 'Ubicación no especificada'}',
                  style: TextStyle(
                    fontSize: 11,
                    color: textColor.withOpacity(0.5),
                  ),
                ),
                Text(
                  '🌱 ${_availableFarms.length} fincas • ☕ ${_availableLots.length} lotes',
                  style: TextStyle(
                    fontSize: 10,
                    color: textColor.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'Observaciones técnicas *',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(requerido)',
                style: TextStyle(
                  fontSize: 10,
                  color: AppTheme.berryRed.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _observationsController,
            maxLines: 3,
            style: TextStyle(color: textColor, fontSize: 13),
            onChanged: (_) => _updateProgress(),
            decoration: InputDecoration(
              hintText: 'Describe los hallazgos observados durante la inspección...',
              hintStyle: TextStyle(color: textColor.withOpacity(0.4), fontSize: 13),
              border: InputBorder.none,
              counterText: '',
            ),
            maxLength: 500,
          ),
        ],
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
              padding: const EdgeInsets.symmetric(vertical: 10),
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
                Icon(Icons.save_outlined, size: 14),
                SizedBox(width: 4),
                Text(
                  'Guardar borrador',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
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
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.health_and_safety_outlined, size: 14),
                SizedBox(width: 4),
                Text(
                  'Generar Diagnóstico',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDark ? Colors.white : AppTheme.darkCoffee;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Seleccionar productor ─────────────────────────────
          SectionTitle(title: 'Seleccionar productor', isDark: widget.isDark),
          const SizedBox(height: 6),
          _buildProducerSelector(),
          const SizedBox(height: 10),

          // ── Seleccionar finca ──────────────────────────────────
          SectionTitle(title: 'Seleccionar finca', isDark: widget.isDark),
          const SizedBox(height: 6),
          _buildFarmSelector(),
          const SizedBox(height: 10),

          // ── Seleccionar lote ──────────────────────────────────
          SectionTitle(title: 'Seleccionar lote', isDark: widget.isDark),
          const SizedBox(height: 6),
          _buildLotSelector(),
          const SizedBox(height: 10),

          // ── Información del productor ──────────────────────────
          SectionTitle(title: 'Información del productor', isDark: widget.isDark),
          const SizedBox(height: 6),
          _buildProducerInfo(),
          const SizedBox(height: 10),

          // ── Información del lote ──────────────────────────────
          SectionTitle(title: 'Información del lote', isDark: widget.isDark),
          const SizedBox(height: 6),
          LotInfoCard(
            isDark: widget.isDark,
            lotName: _selectedLotName ?? widget.lotName,
            farmName: _selectedFarmName ?? widget.farmName,
            producerName: _selectedProducer?.name ?? widget.producerName,
            location: _selectedProducer?.location ?? widget.location,
          ),
          const SizedBox(height: 14),

          // ── Progreso de la inspección ──────────────────────────
          SectionTitle(title: 'Progreso de la inspección', isDark: widget.isDark),
          const SizedBox(height: 6),
          InspectionProgress(
            isDark: widget.isDark,
            progress: _progress,
          ),
          const SizedBox(height: 14),

          // ── Estado general del cultivo ──────────────────────────
          SectionTitle(title: 'Estado general del cultivo', isDark: widget.isDark),
          const SizedBox(height: 6),
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
          const SizedBox(height: 14),

          // ── Evaluación del cultivo ──────────────────────────────
          SectionTitle(title: 'Evaluación del cultivo', isDark: widget.isDark),
          const SizedBox(height: 6),
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
          const SizedBox(height: 14),

          // ── Sanidad del cultivo ──────────────────────────────────
          SectionTitle(title: 'Sanidad del cultivo', isDark: widget.isDark),
          const SizedBox(height: 6),
          PestsChecklist(
            isDark: widget.isDark,
            pests: _pests,
            affectionPercentage: _affectionPercentage,
            onPestToggled: _togglePest,
            onPercentageChanged: (value) {
              setState(() => _affectionPercentage = value);
            },
          ),
          const SizedBox(height: 14),

          // ── Condiciones ambientales ──────────────────────────────
          SectionTitle(title: 'Condiciones ambientales', isDark: widget.isDark),
          const SizedBox(height: 6),
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
          const SizedBox(height: 14),

          // ── Fertilización y manejo ──────────────────────────────
          SectionTitle(title: 'Fertilización y manejo', isDark: widget.isDark),
          const SizedBox(height: 6),
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
          const SizedBox(height: 14),

          // ── Observaciones técnicas ──────────────────────────────
          SectionTitle(title: 'Observaciones técnicas', isDark: widget.isDark),
          const SizedBox(height: 6),
          _buildObservationsField(),
          const SizedBox(height: 14),

          // ── Nivel de prioridad ──────────────────────────────────
          SectionTitle(title: 'Nivel de prioridad', isDark: widget.isDark),
          const SizedBox(height: 6),
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
          const SizedBox(height: 14),

          // ── Asistente IA ─────────────────────────────────────────
          SectionTitle(title: 'Asistente IA', isDark: widget.isDark),
          const SizedBox(height: 6),
          AIAssistantCard(isDark: widget.isDark),
          const SizedBox(height: 14),

          // ── Resumen automático ──────────────────────────────────
          SectionTitle(title: 'Resumen automático', isDark: widget.isDark),
          const SizedBox(height: 6),
          InspectionSummaryCard(
            isDark: widget.isDark,
            cropHealth: _cropHealth,
            pests: _pests,
            photosCount: 0,
            hasObservations: _observationsController.text.isNotEmpty,
            priority: _priorityLevel,
          ),
          const SizedBox(height: 16),

          _buildActionButtons(),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}