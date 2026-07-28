// lib/features/technician/presentation/widgets/visit_registration_form.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/providers/user_provider.dart';
import 'package:kaabcafe/core/providers/notification_provider.dart';
import 'package:kaabcafe/core/providers/farm_provider.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';
import 'package:kaabcafe/features/technician/providers/technician_visits_provider.dart';
import 'package:kaabcafe/features/technician/providers/technician_reports_provider.dart';
import 'package:kaabcafe/features/technician/providers/technician_producers_provider.dart';
import 'package:kaabcafe/features/technician/data/models/technician_visit_model.dart';
import 'package:kaabcafe/features/technician/data/models/technician_model.dart' show TechnicianProducerModel, ProducerStatus;
import 'package:kaabcafe/features/dashboard/data/models/notification_model.dart';

import '../../../farms/data/models/farm_details_model.dart';
import '../../../farms/data/models/lot_model.dart';

class VisitRegistrationForm extends StatefulWidget {
  final bool isDark;
  final String? producerName;
  final String? farmName;
  final String? lotName;
  final String? location;
  final String? producerId;
  final String? producerEmail;
  final String? producerPhone;
  final String? visitId;
  final Function(Map<String, dynamic>) onSave;
  final VoidCallback onSaveDraft;

  const VisitRegistrationForm({
    super.key,
    required this.isDark,
    this.producerName,
    this.farmName,
    this.lotName,
    this.location,
    this.producerId,
    this.producerEmail,
    this.producerPhone,
    this.visitId,
    required this.onSave,
    required this.onSaveDraft,
  });

  @override
  State<VisitRegistrationForm> createState() => _VisitRegistrationFormState();
}

class _VisitRegistrationFormState extends State<VisitRegistrationForm> {
  final _observationsController = TextEditingController();
  final _followUpController = TextEditingController();

  // ✅ SELECTOR DE PRODUCTOR
  String? _selectedProducerId;
  TechnicianProducerModel? _selectedProducer;

  // ✅ SELECTOR DE FINCA Y LOTE
  String? _selectedFarmId;
  String? _selectedFarmName;
  String? _selectedLotName;
  List<FarmDetailsModel> _availableFarms = [];
  List<LotModel> _availableLots = [];

  String? _selectedObjective;
  int _cropHealth = 2;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  // ✅ PRÓXIMA VISITA
  String _nextVisitOption = 'no';
  DateTime? _nextVisitDate;
  TimeOfDay? _nextVisitTime;
  String _nextVisitReason = '';

  // Datos del técnico
  String _technicianName = '';
  String _technicianEmail = '';
  String _technicianId = '';

  final List<Map<String, dynamic>> _checklistItems = [
    {'label': 'Productor presente', 'checked': false},
    {'label': 'Se inspeccionó el lote', 'checked': false},
    {'label': 'Se revisó la humedad', 'checked': false},
    {'label': 'Se revisó el estado sanitario', 'checked': false},
    {'label': 'Se entregaron recomendaciones', 'checked': false},
  ];

  double _checklistProgress = 0.0;

  final List<String> _objectiveOptions = [
    'Inspección general',
    'Seguimiento de plagas',
    'Certificación',
    'Seguimiento de recomendación',
    'Revisión de cosecha',
    'Acopio',
    'Otro',
  ];

  final List<Map<String, dynamic>> _cropHealthOptions = [
    {'label': 'Excelente', 'color': AppTheme.primaryGreen, 'emoji': '🌟'},
    {'label': 'Bueno', 'color': AppTheme.secondaryGreen, 'emoji': '👍'},
    {'label': 'Regular', 'color': AppTheme.goldCoffee, 'emoji': '😐'},
    {'label': 'Requiere atención', 'color': AppTheme.alertOrange, 'emoji': '⚠️'},
    {'label': 'Crítico', 'color': AppTheme.berryRed, 'emoji': '🚨'},
  ];

  @override
  void initState() {
    super.initState();
    _loadTechnicianData();

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
  }

  void _loadTechnicianData() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.userName != null) {
      _technicianName = userProvider.userName!;
    }
    if (userProvider.userEmail != null) {
      _technicianEmail = userProvider.userEmail!;
    }
    _technicianId = userProvider.userEmail ?? 'technician_001';
  }

  @override
  void dispose() {
    _observationsController.dispose();
    _followUpController.dispose();
    super.dispose();
  }

  // ✅ CARGAR FINCAS Y LOTES DEL PRODUCTOR DESDE FARM_PROVIDER
  void _loadFarmsAndLots(TechnicianProducerModel producer) {
    final farmProvider = Provider.of<FarmProvider>(context, listen: false);

    // Usar el email del productor como ID
    final producerId = producer.email.isNotEmpty ? producer.email : producer.id;

    debugPrint('🔍 Buscando fincas para productor: $producerId');

    // Obtener fincas del productor
    final farms = farmProvider.getFarmsByProducer(producerId);

    debugPrint('🔍 Fincas encontradas para ${producer.name}: ${farms.length}');

    setState(() {
      _availableFarms = farms;
      if (farms.isNotEmpty) {
        _selectedFarmId = farms.first.id;
        _selectedFarmName = farms.first.name;
        // Cargar lotes de la primera finca
        _loadLotsForFarm(farms.first.id);
      } else {
        if (producer.farmName != null && producer.farmName!.isNotEmpty) {
          _selectedFarmName = producer.farmName;
        }
        if (producer.lotName != null && producer.lotName!.isNotEmpty) {
          _selectedLotName = producer.lotName;
        }
        _availableLots = [];
      }
    });
  }

  void _loadLotsForFarm(String farmId) {
    final farmProvider = Provider.of<FarmProvider>(context, listen: false);
    final lots = farmProvider.getLotsForFarm(farmId);

    debugPrint('🔍 Lotes encontrados para finca: ${lots.length}');
    for (final lot in lots) {
      debugPrint('  📦 Lote: ${lot.name}');
    }

    setState(() {
      _availableLots = lots;
      if (lots.isNotEmpty) {
        _selectedLotName = lots.first.name;
        debugPrint('✅ Lote seleccionado automáticamente: $_selectedLotName');
      } else {
        _selectedLotName = null;
        debugPrint('⚠️ No hay lotes disponibles');
      }
    });
  }

  void _updateChecklistProgress() {
    final checked = _checklistItems.where((item) => item['checked'] == true).length;
    setState(() {
      _checklistProgress = checked / _checklistItems.length;
    });
  }

  void _toggleChecklist(int index) {
    setState(() {
      _checklistItems[index]['checked'] = !_checklistItems[index]['checked'];
    });
    _updateChecklistProgress();
  }

  bool _isFormComplete() {
    if (_selectedProducerId == null) return false;
    if (_selectedObjective == null) return false;
    if (_observationsController.text.trim().isEmpty) return false;
    return true;
  }

  void _saveVisitToReports(Map<String, dynamic> visitData) {
    try {
      final reportsProvider = Provider.of<TechnicianReportsProvider>(context, listen: false);

      final visit = TechnicianVisitModel(
        id: visitData['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        technicianId: visitData['technicianId'] ?? _technicianId,
        technicianName: visitData['technicianName'] ?? _technicianName,
        producerId: visitData['producerId'] ?? _selectedProducerId ?? 'unknown',
        producerName: visitData['producerName'] ?? _selectedProducer?.name ?? 'Productor',
        farmId: visitData['farmId'] ?? _selectedFarmId ?? 'farm_001',
        farmName: visitData['farmName'] ?? _selectedFarmName ?? 'Finca',
        lotId: visitData['lotId'] ?? 'lot_001',
        lotName: visitData['lotName'] ?? _selectedLotName ?? 'Lote',
        location: visitData['location'] ?? _selectedProducer?.location ?? 'Ubicación',
        visitDate: visitData['visitDate'] ?? DateTime.now(),
        objective: visitData['objective'] ?? _selectedObjective ?? 'Inspección general',
        observations: visitData['observations'] ?? _observationsController.text.trim(),
        recommendations: [],
        evidenceUrls: [],
        status: 'completed',
        isUrgent: visitData['isUrgent'] ?? false,
        createdAt: DateTime.now(),
      );

      reportsProvider.addVisit(visit);
      debugPrint('✅ Visita guardada en reportes para ${visit.producerName}');
    } catch (e) {
      debugPrint('❌ Error al guardar en reportes: $e');
    }
  }

  void _notifyProducerOfVisit(Map<String, dynamic> visitData) {
    try {
      final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);

      final visitDate = visitData['visitDate'] ?? DateTime.now();
      final formattedDate = _formatDate(visitDate);
      final formattedTime = _formatTime(visitDate);

      final notification = NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: '📋 Visita programada',
        message: 'El técnico ${visitData['technicianName'] ?? _technicianName} ha programado una visita a tu finca para el $formattedDate a las $formattedTime.',
        type: 'visit_scheduled',
        date: DateTime.now(),
        isRead: false,
        data: {
          'visitId': visitData['id'],
          'producerId': visitData['producerId'] ?? _selectedProducerId,
          'technicianId': visitData['technicianId'] ?? _technicianId,
          'visitDate': visitDate.toIso8601String(),
          'farmName': visitData['farmName'] ?? _selectedFarmName,
          'location': visitData['location'] ?? _selectedProducer?.location,
        },
        senderName: visitData['technicianName'] ?? _technicianName,
        senderId: visitData['technicianId'] ?? _technicianId,
      );

      notificationProvider.addNotification(notification);
      debugPrint('✅ Notificación enviada al productor: ${visitData['producerName']}');
    } catch (e) {
      debugPrint('❌ Error al enviar notificación: $e');
    }
  }

  void _saveVisitToProvider(Map<String, dynamic> visitData) {
    try {
      final visitsProvider = Provider.of<TechnicianVisitsProvider>(context, listen: false);

      final visit = TechnicianVisitModel(
        id: visitData['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        technicianId: visitData['technicianId'] ?? _technicianId,
        technicianName: visitData['technicianName'] ?? _technicianName,
        producerId: visitData['producerId'] ?? _selectedProducerId ?? 'unknown',
        producerName: visitData['producerName'] ?? _selectedProducer?.name ?? 'Productor',
        farmId: visitData['farmId'] ?? _selectedFarmId ?? 'farm_001',
        farmName: visitData['farmName'] ?? _selectedFarmName ?? 'Finca',
        lotId: visitData['lotId'] ?? 'lot_001',
        lotName: visitData['lotName'] ?? _selectedLotName ?? 'Lote',
        location: visitData['location'] ?? _selectedProducer?.location ?? 'Ubicación',
        visitDate: visitData['visitDate'] ?? DateTime.now(),
        objective: visitData['objective'] ?? _selectedObjective ?? 'Inspección general',
        observations: visitData['observations'] ?? _observationsController.text.trim(),
        recommendations: [],
        evidenceUrls: [],
        status: 'pending',
        isUrgent: visitData['isUrgent'] ?? false,
        createdAt: DateTime.now(),
      );

      visitsProvider.addVisit(visit);
      debugPrint('✅ Visita guardada en el provider: ${visit.producerName}');
    } catch (e) {
      debugPrint('❌ Error al guardar visita: $e');
    }
  }

  String _formatDate(DateTime date) {
    final months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _submitForm() {
    if (!_isFormComplete()) {
      _showValidationDialog();
      return;
    }

    final visitDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final data = {
      'id': widget.visitId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'producerId': _selectedProducerId,
      'producerName': _selectedProducer?.name ?? 'Productor',
      'phone': _selectedProducer?.phone ?? '',
      'email': _selectedProducer?.email ?? '',
      'farmId': _selectedFarmId ?? '',
      'farmName': _selectedFarmName ?? '',
      'lotId': _selectedLotName ?? '',
      'lotName': _selectedLotName ?? '',
      'location': _selectedProducer?.location ?? widget.location ?? '',
      'objective': _selectedObjective,
      'cropHealth': _cropHealthOptions[_cropHealth]['label'],
      'observations': _observationsController.text.trim(),
      'checklist': _checklistItems,
      'followUp': _followUpController.text.trim(),
      'nextVisitDate': _nextVisitOption == 'yes' ? _nextVisitDate : null,
      'nextVisitTime': _nextVisitOption == 'yes' ? _nextVisitTime : null,
      'nextVisitReason': _nextVisitOption == 'yes' ? _nextVisitReason : '',
      'technicianName': _technicianName,
      'technicianEmail': _technicianEmail,
      'technicianId': _technicianId,
      'visitDate': visitDate,
      'isUrgent': _cropHealth <= 1,
    };

    _saveVisitToProvider(data);
    _notifyProducerOfVisit(data);
    _saveVisitToReports(data);
    widget.onSave(data);
  }

  void _navigateToLotInspection() {
    context.push(
      RouteNames.technicianLotInspection,
      extra: {
        'lotName': _selectedLotName ?? '',
        'farmName': _selectedFarmName ?? '',
        'producerName': _selectedProducer?.name ?? '',
        'location': _selectedProducer?.location ?? widget.location ?? '',
        'phone': _selectedProducer?.phone ?? '',
        'email': _selectedProducer?.email ?? '',
        'producerId': _selectedProducerId,
      },
    );
  }

  void _showValidationDialog() {
    List<String> errors = [];

    if (_selectedProducerId == null) errors.add('• Selecciona un productor para la visita');
    if (_selectedObjective == null) errors.add('• Selecciona un objetivo para la visita');
    if (_observationsController.text.trim().isEmpty) errors.add('• Agrega observaciones de la visita');

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
                  Icons.check_circle_outline,
                  size: 48,
                  color: AppTheme.primaryGreen,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '¿Finalizar visita?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: widget.isDark ? Colors.white : AppTheme.darkCoffee,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'La información quedará registrada en el historial técnico del productor.',
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
                        _navigateToLotInspection();
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
                      child: const Text('Finalizar'),
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

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _nextVisitDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryGreen,
              onPrimary: Colors.white,
              surface: widget.isDark ? AppTheme.coffeeDeep : Colors.white,
              onSurface: widget.isDark ? Colors.white : AppTheme.darkCoffee,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _nextVisitDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _nextVisitTime ?? const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryGreen,
              onPrimary: Colors.white,
              surface: widget.isDark ? AppTheme.coffeeDeep : Colors.white,
              onSurface: widget.isDark ? Colors.white : AppTheme.darkCoffee,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _nextVisitTime = picked);
    }
  }

  // ============================================================
  // ✅ MÉTODOS DE CONSTRUCCIÓN DE WIDGETS
  // ============================================================

  Widget _buildSectionTitle(String title, Color textColor) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryGreen, AppTheme.goldCoffee],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ],
    );
  }

  // ✅ SELECTOR DE PRODUCTOR
  // lib/features/technician/presentation/widgets/visit_registration_form.dart

// ✅ SELECTOR DE PRODUCTOR - VERSIÓN CORREGIDA
  Widget _buildProducerSelector(Color cardColor, Color textColor) {
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
            Icon(Icons.warning, color: AppTheme.alertOrange, size: 24),
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
      padding: const EdgeInsets.all(12),
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
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
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
                      style: TextStyle(color: textColor.withOpacity(0.4), fontSize: 13),
                    ),
                  ],
                ),
                dropdownColor: widget.isDark ? AppTheme.coffeeDeep : Colors.white,
                style: TextStyle(color: textColor, fontSize: 13),
                icon: Icon(Icons.arrow_drop_down, color: textColor.withOpacity(0.5), size: 28),
                items: producers.map((producer) {
                  return DropdownMenuItem(
                    value: producer.id,
                    child: Row(
                      children: [
                        Icon(Icons.person, size: 16, color: AppTheme.primaryGreen),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                producer.name,
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '📍 ${producer.location}',
                                style: TextStyle(fontSize: 10, color: textColor.withOpacity(0.5)),
                              ),
                              Text(
                                '🌱 ${producer.farmsCount} fincas • ☕ ${producer.lotsCount} lotes',
                                style: TextStyle(fontSize: 9, color: textColor.withOpacity(0.3)),
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
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ SELECTOR DE FINCA
  // ✅ SELECTOR DE FINCA - VERSIÓN CORREGIDA
  Widget _buildFarmSelector(Color cardColor, Color textColor) {
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
                  fontSize: 13,
                  color: textColor.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
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
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
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
                      style: TextStyle(color: textColor.withOpacity(0.4), fontSize: 13),
                    ),
                  ],
                ),
                dropdownColor: widget.isDark ? AppTheme.coffeeDeep : Colors.white,
                style: TextStyle(color: textColor, fontSize: 13),
                icon: Icon(Icons.arrow_drop_down, color: textColor.withOpacity(0.5), size: 28),
                items: _availableFarms.map((farm) {
                  final lotCount = _getLotsCountForFarm(farm.id);
                  return DropdownMenuItem(
                    value: farm.id,
                    child: Row(
                      children: [
                        Icon(Icons.landscape, size: 16, color: AppTheme.primaryGreen),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                farm.name,
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '📍 ${farm.location} • ${farm.hectares} ha • $lotCount lotes',
                                style: TextStyle(fontSize: 10, color: textColor.withOpacity(0.5)),
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
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _getLotsCountForFarm(String farmId) {
    final farmProvider = Provider.of<FarmProvider>(context, listen: false);
    return farmProvider.getLotsForFarm(farmId).length;
  }

  // ✅ SELECTOR DE LOTE
  // ✅ SELECTOR DE LOTE - VERSIÓN CORREGIDA
  Widget _buildLotSelector(Color cardColor, Color textColor) {
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
                  fontSize: 13,
                  color: textColor.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
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
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
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
                      style: TextStyle(color: textColor.withOpacity(0.4), fontSize: 13),
                    ),
                  ],
                ),
                dropdownColor: widget.isDark ? AppTheme.coffeeDeep : Colors.white,
                style: TextStyle(color: textColor, fontSize: 13),
                icon: Icon(Icons.arrow_drop_down, color: textColor.withOpacity(0.5), size: 28),
                items: _availableLots.map((lot) {
                  return DropdownMenuItem(
                    value: lot.name,
                    child: Row(
                      children: [
                        Icon(Icons.view_module, size: 16, color: AppTheme.primaryGreen),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                lot.name,
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '🌱 ${lot.variety} • ${lot.area} ha • ${lot.statusText}',
                                style: TextStyle(fontSize: 10, color: textColor.withOpacity(0.5)),
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
  Widget _buildProducerInfo(Color cardColor, Color textColor) {
    return NeumorphicBox(
      isDark: widget.isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildInfoRow('👤 Nombre', _selectedProducer?.name ?? 'No seleccionado', textColor),
          const SizedBox(height: 8),
          _buildInfoRow('📱 Celular', _selectedProducer?.phone ?? 'No disponible', textColor),
          const SizedBox(height: 8),
          _buildInfoRow('✉️ Email', _selectedProducer?.email ?? 'No disponible', textColor),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color textColor) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: textColor.withOpacity(0.6),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // ✅ INFORMACIÓN AUTOMÁTICA
  Widget _buildAutoInfoCard(Color cardColor, Color textColor) {
    final now = DateTime.now();

    return NeumorphicBox(
      isDark: widget.isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildAutoInfoRow(Icons.calendar_today, 'Fecha', '${now.day}/${now.month}/${now.year}', textColor),
          const SizedBox(height: 8),
          _buildAutoInfoRow(
            Icons.access_time,
            'Hora de inicio',
            '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
            textColor,
          ),
          const SizedBox(height: 8),
          _buildAutoInfoRow(
            Icons.location_on,
            'Ubicación',
            _selectedProducer?.location ?? widget.location ?? 'No especificada',
            textColor,
          ),
          const SizedBox(height: 8),
          _buildAutoInfoRow(Icons.person, 'Responsable', _technicianName.isNotEmpty ? _technicianName : 'No asignado', textColor),
          const SizedBox(height: 8),
          _buildAutoInfoRow(Icons.email, 'Correo técnico', _technicianEmail.isNotEmpty ? _technicianEmail : 'No disponible', textColor),
        ],
      ),
    );
  }

  Widget _buildAutoInfoRow(IconData icon, String label, String value, Color textColor) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.primaryGreen),
        const SizedBox(width: 12),
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: textColor.withOpacity(0.6),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // ✅ OBJETIVO DE LA VISITA
  Widget _buildObjectiveDropdown(Color cardColor, Color textColor) {
    return NeumorphicBox(
      isDark: widget.isDark,
      borderRadius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonFormField<String>(
        value: _selectedObjective,
        isExpanded: true,
        dropdownColor: widget.isDark ? AppTheme.coffeeDeep : Colors.white,
        style: TextStyle(color: textColor, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Selecciona el objetivo *',
          hintStyle: TextStyle(color: textColor.withOpacity(0.4), fontSize: 14),
          border: InputBorder.none,
          prefixIcon: Icon(Icons.flag_outlined, color: AppTheme.primaryGreen),
        ),
        items: _objectiveOptions.map((option) {
          return DropdownMenuItem(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: (value) => setState(() => _selectedObjective = value),
        validator: (value) => value == null ? 'Selecciona un objetivo' : null,
      ),
    );
  }

  // ✅ ESTADO DEL CULTIVO
  Widget _buildCropHealthSelector(Color cardColor, Color textColor) {
    return NeumorphicBox(
      isDark: widget.isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(14),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: List.generate(_cropHealthOptions.length, (index) {
          final option = _cropHealthOptions[index];
          final isSelected = _cropHealth == index;
          return GestureDetector(
            onTap: () => setState(() => _cropHealth = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? (option['color'] as Color).withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? (option['color'] as Color)
                      : textColor.withOpacity(0.1),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    option['emoji'],
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    option['label'],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? (option['color'] as Color) : textColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // ✅ OBSERVACIONES
  Widget _buildObservationsField(Color cardColor, Color textColor) {
    return NeumorphicBox(
      isDark: widget.isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Observaciones *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(requerido)',
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.berryRed.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _observationsController,
            maxLines: 4,
            style: TextStyle(color: textColor, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Describe las condiciones observadas durante la visita...',
              hintStyle: TextStyle(color: textColor.withOpacity(0.4), fontSize: 14),
              border: InputBorder.none,
              counterText: '',
            ),
            maxLength: 500,
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }

  // ✅ CHECKLIST
  Widget _buildChecklist(Color cardColor, Color textColor) {
    return NeumorphicBox(
      isDark: widget.isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          ..._checklistItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: GestureDetector(
                onTap: () => _toggleChecklist(index),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: item['checked']
                            ? AppTheme.primaryGreen
                            : Colors.transparent,
                        border: Border.all(
                          color: item['checked']
                              ? AppTheme.primaryGreen
                              : textColor.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: item['checked']
                          ? const Icon(Icons.check, size: 12, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item['label'],
                        style: TextStyle(
                          fontSize: 13,
                          color: item['checked']
                              ? textColor.withOpacity(0.7)
                              : textColor,
                          decoration: item['checked']
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: _checklistProgress,
                    minHeight: 5,
                    backgroundColor: textColor.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation(AppTheme.primaryGreen),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${(_checklistProgress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ NOTAS DE SEGUIMIENTO
  Widget _buildFollowUpField(Color cardColor, Color textColor) {
    return NeumorphicBox(
      isDark: widget.isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(14),
      child: TextFormField(
        controller: _followUpController,
        maxLines: 3,
        style: TextStyle(color: textColor, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Registrar acciones pendientes para la siguiente visita...',
          hintStyle: TextStyle(color: textColor.withOpacity(0.4), fontSize: 14),
          border: InputBorder.none,
          counterText: '',
        ),
      ),
    );
  }

  // ✅ PRÓXIMA VISITA
  Widget _buildNextVisitCard(Color cardColor, Color textColor) {
    return NeumorphicBox(
      isDark: widget.isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _nextVisitOption = 'no'),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _nextVisitOption == 'no'
                    ? AppTheme.primaryGreen.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _nextVisitOption == 'no'
                      ? AppTheme.primaryGreen
                      : textColor.withOpacity(0.1),
                  width: _nextVisitOption == 'no' ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Radio<String>(
                    value: 'no',
                    groupValue: _nextVisitOption,
                    onChanged: (value) => setState(() => _nextVisitOption = value!),
                    activeColor: AppTheme.primaryGreen,
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.check_circle_outline, color: AppTheme.primaryGreen),
                  const SizedBox(width: 8),
                  Text(
                    'No requiere otra cita',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: _nextVisitOption == 'no' ? FontWeight.w600 : FontWeight.w400,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => setState(() => _nextVisitOption = 'yes'),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _nextVisitOption == 'yes'
                    ? AppTheme.goldCoffee.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _nextVisitOption == 'yes'
                      ? AppTheme.goldCoffee
                      : textColor.withOpacity(0.1),
                  width: _nextVisitOption == 'yes' ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Radio<String>(
                    value: 'yes',
                    groupValue: _nextVisitOption,
                    onChanged: (value) => setState(() => _nextVisitOption = value!),
                    activeColor: AppTheme.goldCoffee,
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.calendar_today, color: AppTheme.goldCoffee),
                  const SizedBox(width: 8),
                  Text(
                    'Requiere cita de seguimiento',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: _nextVisitOption == 'yes' ? FontWeight.w600 : FontWeight.w400,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_nextVisitOption == 'yes') ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: widget.isDark
                            ? Colors.white.withOpacity(0.05)
                            : AppTheme.darkCoffee.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: textColor.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today, size: 16, color: AppTheme.goldCoffee),
                          const SizedBox(width: 6),
                          Text(
                            _nextVisitDate != null
                                ? '${_nextVisitDate!.day}/${_nextVisitDate!.month}/${_nextVisitDate!.year}'
                                : 'Seleccionar fecha',
                            style: TextStyle(
                              fontSize: 12,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectTime(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: widget.isDark
                            ? Colors.white.withOpacity(0.05)
                            : AppTheme.darkCoffee.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: textColor.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.access_time, size: 16, color: AppTheme.goldCoffee),
                          const SizedBox(width: 6),
                          Text(
                            _nextVisitTime != null
                                ? _nextVisitTime!.format(context)
                                : 'Seleccionar hora',
                            style: TextStyle(
                              fontSize: 12,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextFormField(
              style: TextStyle(color: textColor, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Motivo de la próxima visita (opcional)',
                hintStyle: TextStyle(color: textColor.withOpacity(0.4), fontSize: 13),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: textColor.withOpacity(0.1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: textColor.withOpacity(0.1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppTheme.primaryGreen),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              onChanged: (value) => _nextVisitReason = value,
            ),
          ],
        ],
      ),
    );
  }

  // ✅ RESUMEN
  Widget _buildSummaryCard(Color cardColor, Color textColor) {
    final totalChecklist = _checklistItems.where((item) => item['checked'] == true).length;

    return NeumorphicBox(
      isDark: widget.isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          _buildSummaryRow('👨‍🌾 Productor', _selectedProducer?.name ?? 'No seleccionado', textColor),
          const SizedBox(height: 6),
          _buildSummaryRow('📱 Celular', _selectedProducer?.phone ?? 'No disponible', textColor),
          const SizedBox(height: 6),
          _buildSummaryRow('✉️ Email', _selectedProducer?.email ?? 'No disponible', textColor),
          const SizedBox(height: 6),
          _buildSummaryRow('🌱 Finca', _selectedFarmName ?? 'No seleccionada', textColor),
          const SizedBox(height: 6),
          _buildSummaryRow('☕ Lote', _selectedLotName ?? 'No seleccionado', textColor),
          const SizedBox(height: 6),
          _buildSummaryRow('📍 Ubicación', _selectedProducer?.location ?? widget.location ?? 'No especificada', textColor),
          const SizedBox(height: 6),
          _buildSummaryRow('📋 Checklist', '$totalChecklist/${_checklistItems.length} completados', textColor),
          const SizedBox(height: 6),
          _buildSummaryRow('👤 Responsable', _technicianName.isNotEmpty ? _technicianName : 'No asignado', textColor),
          if (_nextVisitOption == 'yes' && _nextVisitDate != null) ...[
            const SizedBox(height: 6),
            _buildSummaryRow('📅 Próxima visita', '${_nextVisitDate!.day}/${_nextVisitDate!.month}/${_nextVisitDate!.year} ${_nextVisitTime != null ? _nextVisitTime!.format(context) : ''}', textColor),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, Color textColor) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: textColor.withOpacity(0.6),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // ✅ BOTONES DE ACCIÓN
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
                Icon(Icons.check_circle_outline, size: 16),
                SizedBox(width: 6),
                Text(
                  'Finalizar Visita',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ✅ MÉTODO BUILD PRINCIPAL
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDark ? Colors.white : AppTheme.darkCoffee;
    final cardColor = widget.isDark
        ? AppTheme.coffeeDeep.withOpacity(0.7)
        : const Color(0xFFE8E0D5).withOpacity(0.9);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Seleccionar productor ─────────────────────────────
          _buildSectionTitle('Seleccionar productor', textColor),
          const SizedBox(height: 8),
          _buildProducerSelector(cardColor, textColor),
          const SizedBox(height: 16),

          // ── Seleccionar finca ──────────────────────────────────
          _buildSectionTitle('Seleccionar finca', textColor),
          const SizedBox(height: 8),
          _buildFarmSelector(cardColor, textColor),
          const SizedBox(height: 16),

          // ── Seleccionar lote ──────────────────────────────────
          _buildSectionTitle('Seleccionar lote', textColor),
          const SizedBox(height: 8),
          _buildLotSelector(cardColor, textColor),
          const SizedBox(height: 16),

          // ── Información del productor ──────────────────────────
          _buildSectionTitle('Información del productor', textColor),
          const SizedBox(height: 8),
          _buildProducerInfo(cardColor, textColor),
          const SizedBox(height: 16),

          // ── Información automática ──────────────────────────────
          _buildSectionTitle('Información automática', textColor),
          const SizedBox(height: 8),
          _buildAutoInfoCard(cardColor, textColor),
          const SizedBox(height: 16),

          // ── Objetivo de la visita ────────────────────────────────
          _buildSectionTitle('Objetivo de la visita', textColor),
          const SizedBox(height: 8),
          _buildObjectiveDropdown(cardColor, textColor),
          const SizedBox(height: 16),

          // ── Estado general del cultivo ────────────────────────────
          _buildSectionTitle('Estado general del cultivo', textColor),
          const SizedBox(height: 8),
          _buildCropHealthSelector(cardColor, textColor),
          const SizedBox(height: 16),

          // ── Observaciones ────────────────────────────────────────
          _buildSectionTitle('Observaciones', textColor),
          const SizedBox(height: 8),
          _buildObservationsField(cardColor, textColor),
          const SizedBox(height: 16),

          // ── Checklist de visita ──────────────────────────────────
          _buildSectionTitle('Checklist de visita', textColor),
          const SizedBox(height: 8),
          _buildChecklist(cardColor, textColor),
          const SizedBox(height: 16),

          // ── Notas de seguimiento ──────────────────────────────────
          _buildSectionTitle('Notas de seguimiento', textColor),
          const SizedBox(height: 8),
          _buildFollowUpField(cardColor, textColor),
          const SizedBox(height: 16),

          // ── Programar próxima visita ──────────────────────────────
          _buildSectionTitle('Programar próxima visita', textColor),
          const SizedBox(height: 8),
          _buildNextVisitCard(cardColor, textColor),
          const SizedBox(height: 16),

          // ── Resumen de la visita ──────────────────────────────────
          _buildSectionTitle('Resumen de la visita', textColor),
          const SizedBox(height: 8),
          _buildSummaryCard(cardColor, textColor),
          const SizedBox(height: 24),

          // ── Botones de acción ────────────────────────────────────
          _buildActionButtons(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}