// lib/features/technician/presentation/screens/technician_crop_diagnosis_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/providers/user_provider.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/aurora_background.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/diagnosis/diagnosis_summary_card.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/diagnosis/diagnosis_category_card.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/diagnosis/diagnosis_issue_card.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/diagnosis/diagnosis_ai_card.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/diagnosis/diagnosis_risk_indicator.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/diagnosis/diagnosis_prediction_card.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/diagnosis/diagnosis_recommendation_card.dart';
import 'package:kaabcafe/features/technician/providers/technician_producers_provider.dart';
import 'package:kaabcafe/features/technician/providers/technician_reports_provider.dart';
import 'package:kaabcafe/features/technician/data/models/technician_diagnosis_model.dart';
import 'package:kaabcafe/features/technician/data/models/technician_model.dart';

class TechnicianCropDiagnosisScreen extends StatefulWidget {
  const TechnicianCropDiagnosisScreen({
    super.key,
    this.lotName,
    this.farmName,
    this.producerName,
    this.location,
    this.inspectionData,
  });

  final String? lotName;
  final String? farmName;
  final String? producerName;
  final String? location;
  final Map<String, dynamic>? inspectionData;

  @override
  State<TechnicianCropDiagnosisScreen> createState() =>
      _TechnicianCropDiagnosisScreenState();
}

class _TechnicianCropDiagnosisScreenState
    extends State<TechnicianCropDiagnosisScreen> {
  int _currentIndex = 3;

  // ✅ DATOS DEL PRODUCTOR SELECCIONADO
  String? _selectedProducerId;
  TechnicianProducerModel? _selectedProducer;

  // ✅ DATOS DEL TÉCNICO
  String _technicianName = '';
  String _technicianId = '';

  // ✅ DATOS DE LA INSPECCIÓN (desde el formulario)
  Map<String, dynamic>? _inspectionData;
  String _lotName = '';
  String _farmName = '';
  String _producerName = '';
  String _location = '';

  // ✅ DATOS DEL DIAGNÓSTICO
  final List<Map<String, dynamic>> _categories = [];
  final List<Map<String, dynamic>> _issues = [];
  final List<Map<String, dynamic>> _risks = [];
  final List<String> _recommendations = [];
  final List<String> _evidenceImages = [];

  @override
  void initState() {
    super.initState();
    _loadTechnicianData();
    _processInspectionData();
    _generateDiagnosisFromInspection();

    // ✅ Buscar el productor por nombre si viene desde la navegación
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
    _technicianId = userProvider.userEmail ?? 'technician_001';
  }

  // ✅ PROCESAR DATOS DE LA INSPECCIÓN
  void _processInspectionData() {
    if (widget.inspectionData != null) {
      _inspectionData = widget.inspectionData;
      _lotName = widget.inspectionData!['lotName'] ?? widget.lotName ?? '';
      _farmName = widget.inspectionData!['farmName'] ?? widget.farmName ?? '';
      _producerName = widget.inspectionData!['producerName'] ?? widget.producerName ?? '';
      _location = widget.inspectionData!['location'] ?? widget.location ?? '';

      final photos = widget.inspectionData!['photos'] as List<String>? ?? [];
      _evidenceImages.addAll(photos);

      debugPrint('✅ Datos de inspección procesados: $_lotName');
    } else {
      _lotName = widget.lotName ?? '';
      _farmName = widget.farmName ?? '';
      _producerName = widget.producerName ?? '';
      _location = widget.location ?? '';
    }
  }

  // ✅ GENERAR DIAGNÓSTICO A PARTIR DE LA INSPECCIÓN
  void _generateDiagnosisFromInspection() {
    if (_inspectionData == null) return;

    final data = _inspectionData!;

    final healthIndex = data['cropHealthIndex'] ?? 2;

    _categories.add({
      'label': '🌱 Salud general del cultivo',
      'value': _mapHealthToScore(healthIndex),
      'color': _getHealthColor(healthIndex),
    });

    final evaluation = data['cropEvaluation'] as List<dynamic>? ?? [];
    final evalLabels = [
      'Estado vegetativo',
      'Color de hojas',
      'Floración',
      'Fructificación',
      'Desarrollo de ramas',
    ];

    for (int i = 0; i < evaluation.length && i < evalLabels.length; i++) {
      final value = evaluation[i]['value'] ?? 1;
      _categories.add({
        'label': evalLabels[i],
        'value': _mapEvaluationToScore(value),
        'color': _getEvaluationColor(value),
      });
    }

    final pests = data['pests'] as List<dynamic>? ?? [];
    final detectedPests = pests.where((p) => p['checked'] == true).toList();

    if (detectedPests.isNotEmpty) {
      final pestNames = detectedPests.map((p) => p['label'] as String).join(', ');
      _issues.add({
        'title': 'Plagas detectadas: $pestNames',
        'level': _getPestLevel(detectedPests.length),
        'priority': _getPestPriority(detectedPests.length),
        'priorityColor': _getPestPriorityColor(detectedPests.length),
      });

      _risks.add({
        'label': 'Presencia de plagas',
        'level': _getPestLevel(detectedPests.length),
        'color': _getPestPriorityColor(detectedPests.length),
      });
    }

    final affection = data['affectionPercentage'] ?? 0;
    if (affection > 20) {
      _risks.add({
        'label': 'Afectación en cultivo',
        'level': affection > 50 ? 'Alto' : 'Medio',
        'color': affection > 50 ? AppTheme.berryRed : AppTheme.alertOrange,
      });
    }

    final temp = data['temperature'] ?? 25;
    final humidity = data['humidity'] ?? 65;

    if (temp > 30 || temp < 18) {
      _risks.add({
        'label': 'Temperatura extrema (${temp}°C)',
        'level': temp > 30 ? 'Alto' : 'Medio',
        'color': temp > 30 ? AppTheme.berryRed : AppTheme.alertOrange,
      });
    }

    if (humidity > 80 || humidity < 40) {
      _risks.add({
        'label': 'Humedad ${humidity > 80 ? 'excesiva' : 'baja'} (${humidity}%)',
        'level': humidity > 80 ? 'Alto' : 'Medio',
        'color': humidity > 80 ? AppTheme.berryRed : AppTheme.alertOrange,
      });
    }

    final management = data['management'] as List<dynamic>? ?? [];
    var managementIssues = [];
    for (int i = 0; i < management.length; i++) {
      final value = management[i]['value'] ?? 1;
      if (value < 3) {
        final labels = ['Fertilización', 'Control de malezas', 'Manejo fitosanitario', 'Estado de poda'];
        managementIssues.add(labels[i]);
      }
    }

    if (managementIssues.isNotEmpty) {
      _issues.add({
        'title': 'Aspectos de manejo a mejorar: ${managementIssues.join(', ')}',
        'level': 'Medio',
        'priority': 'Media',
        'priorityColor': AppTheme.goldCoffee,
      });
    }

    _generateRecommendations(data);

    final observations = data['observations'] ?? '';
    if (observations.isNotEmpty) {
      _recommendations.add('📝 Observación técnica: $observations');
    }
  }

  int _mapHealthToScore(int healthIndex) {
    switch (healthIndex) {
      case 0: return 95;
      case 1: return 80;
      case 2: return 60;
      case 3: return 40;
      case 4: return 20;
      default: return 60;
    }
  }

  Color _getHealthColor(int healthIndex) {
    switch (healthIndex) {
      case 0: return AppTheme.primaryGreen;
      case 1: return AppTheme.secondaryGreen;
      case 2: return AppTheme.goldCoffee;
      case 3: return AppTheme.alertOrange;
      case 4: return AppTheme.berryRed;
      default: return AppTheme.goldCoffee;
    }
  }

  int _mapEvaluationToScore(int value) {
    switch (value) {
      case 1: return 90;
      case 2: return 70;
      case 3: return 50;
      case 4: return 30;
      default: return 70;
    }
  }

  Color _getEvaluationColor(int value) {
    switch (value) {
      case 1: return AppTheme.primaryGreen;
      case 2: return AppTheme.secondaryGreen;
      case 3: return AppTheme.goldCoffee;
      case 4: return AppTheme.alertOrange;
      default: return AppTheme.goldCoffee;
    }
  }

  String _getPestLevel(int pestCount) {
    if (pestCount >= 4) return 'Crítico';
    if (pestCount >= 2) return 'Alto';
    if (pestCount >= 1) return 'Medio';
    return 'Bajo';
  }

  String _getPestPriority(int pestCount) {
    if (pestCount >= 4) return 'Crítica';
    if (pestCount >= 2) return 'Alta';
    if (pestCount >= 1) return 'Media';
    return 'Baja';
  }

  Color _getPestPriorityColor(int pestCount) {
    if (pestCount >= 4) return AppTheme.berryRed;
    if (pestCount >= 2) return AppTheme.alertOrange;
    if (pestCount >= 1) return AppTheme.goldCoffee;
    return AppTheme.primaryGreen;
  }

  void _generateRecommendations(Map<String, dynamic> data) {
    final healthIndex = data['cropHealthIndex'] ?? 2;
    final pests = data['pests'] as List<dynamic>? ?? [];
    final detectedPests = pests.where((p) => p['checked'] == true).toList();
    final affection = data['affectionPercentage'] ?? 0;
    final temp = data['temperature'] ?? 25;
    final humidity = data['humidity'] ?? 65;
    final shadeLevel = data['shadeLevel'] ?? 2;
    final irrigation = data['irrigationStatus'] ?? 1;
    final management = data['management'] as List<dynamic>? ?? [];

    if (healthIndex >= 3) {
      _recommendations.add('⚠️ El cultivo requiere atención inmediata. Programa una visita de seguimiento.');
    } else if (healthIndex == 2) {
      _recommendations.add('📋 El cultivo está en estado regular. Se recomienda monitoreo constante.');
    } else if (healthIndex <= 1) {
      _recommendations.add('✅ El cultivo presenta buenas condiciones. Continúa con el manejo actual.');
    }

    if (detectedPests.isNotEmpty) {
      final pestNames = detectedPests.map((p) => p['label'] as String).join(', ');
      _recommendations.add('🐛 Control de plagas: Se detectó $pestNames. Aplica tratamiento específico.');

      if (affection > 30) {
        _recommendations.add('🚨 El nivel de afectación es del ${affection.toStringAsFixed(0)}%. Considera un plan de control intensivo.');
      }
    }

    if (temp > 30) {
      _recommendations.add('🌡️ Temperatura alta (${temp}°C). Asegura riego adecuado y considera sombra temporal.');
    } else if (temp < 18) {
      _recommendations.add('🌡️ Temperatura baja (${temp}°C). Protege el cultivo de heladas.');
    }

    if (humidity > 80) {
      _recommendations.add('💧 Humedad alta (${humidity}%). Monitorea presencia de hongos.');
    } else if (humidity < 40) {
      _recommendations.add('💧 Humedad baja (${humidity}%). Aumenta frecuencia de riego.');
    }

    if (shadeLevel < 2) {
      _recommendations.add('☀️ Nivel de sombra bajo. Considera aumentar sombra para proteger el cultivo.');
    }

    if (irrigation < 2) {
      _recommendations.add('💦 Riego insuficiente. Asegura un riego adecuado según la temporada.');
    }

    for (int i = 0; i < management.length; i++) {
      final value = management[i]['value'] ?? 1;
      if (value < 3) {
        final labels = ['Fertilización', 'Control de malezas', 'Manejo fitosanitario', 'Estado de poda'];
        _recommendations.add('🌱 Mejorar el manejo de: ${labels[i]}.');
      }
    }

    if (_recommendations.isEmpty) {
      _recommendations.add('✅ El cultivo está en buenas condiciones. Mantén el manejo actual.');
    }
  }

  // ✅ MÉTODO PARA OBTENER EL DIAGNÓSTICO ACTUAL
  TechnicianDiagnosisModel? _getCurrentDiagnosis() {
    if (_categories.isEmpty || _selectedProducer == null) return null;

    double healthScore = _categories.fold(0, (sum, cat) => sum + (cat['value'] as int)) / _categories.length;

    return TechnicianDiagnosisModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      technicianId: _technicianId,
      technicianName: _technicianName,
      producerId: _selectedProducer!.id,
      producerName: _selectedProducer!.name,
      farmId: _inspectionData?['farmId'] ?? 'farm_001',
      farmName: _farmName,
      lotId: _inspectionData?['lotId'] ?? 'lot_001',
      lotName: _lotName,
      location: _selectedProducer!.location,
      diagnosisDate: DateTime.now(),
      healthScore: healthScore,
      status: healthScore >= 80 ? 'Excelente' : healthScore >= 60 ? 'Atención' : 'Riesgo',
      categories: _categories.map((cat) => DiagnosisCategory(
        label: cat['label'] as String,
        value: cat['value'] as int,
        color: cat['color'] as Color,
      )).toList(),
      issues: _issues.map((issue) => DiagnosisIssue(
        title: issue['title'] as String,
        level: issue['level'] as String,
        priority: issue['priority'] as String,
        priorityColor: issue['priorityColor'] as Color,
      )).toList(),
      risks: _risks.map((risk) => DiagnosisRisk(
        label: risk['label'] as String,
        level: risk['level'] as String,
        color: risk['color'] as Color,
      )).toList(),
      recommendations: _recommendations,
      certification: null,
      evidenceUrls: _evidenceImages,
      createdAt: DateTime.now(),
    );
  }

  void _navigateToCertification() {
    context.push(
      RouteNames.technicianLotCertification,
      extra: {
        'lotName': _lotName,
        'farmName': _farmName,
        'producerName': _selectedProducer?.name ?? _producerName,
        'location': _selectedProducer?.location ?? _location,
        'variety': 'Bourbon',
      },
    );
  }

  void _saveDiagnosisToReports() {
    try {
      if (_selectedProducer == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚠️ Selecciona un productor para guardar el diagnóstico'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final reportsProvider = Provider.of<TechnicianReportsProvider>(context, listen: false);

      double healthScore = 0;
      if (_categories.isNotEmpty) {
        final total = _categories.fold(0, (sum, cat) => sum + (cat['value'] as int));
        healthScore = total / _categories.length;
      }

      final diagnosis = TechnicianDiagnosisModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        technicianId: _technicianId,
        technicianName: _technicianName,
        producerId: _selectedProducer!.id,
        producerName: _selectedProducer!.name,
        farmId: _inspectionData?['farmId'] ?? 'farm_001',
        farmName: _farmName,
        lotId: _inspectionData?['lotId'] ?? 'lot_001',
        lotName: _lotName,
        location: _selectedProducer!.location,
        diagnosisDate: DateTime.now(),
        healthScore: healthScore,
        status: healthScore >= 80 ? 'Excelente' : healthScore >= 60 ? 'Atención' : 'Riesgo',
        categories: _categories.map((cat) => DiagnosisCategory(
          label: cat['label'] as String,
          value: cat['value'] as int,
          color: cat['color'] as Color,
        )).toList(),
        issues: _issues.map((issue) => DiagnosisIssue(
          title: issue['title'] as String,
          level: issue['level'] as String,
          priority: issue['priority'] as String,
          priorityColor: issue['priorityColor'] as Color,
        )).toList(),
        risks: _risks.map((risk) => DiagnosisRisk(
          label: risk['label'] as String,
          level: risk['level'] as String,
          color: risk['color'] as Color,
        )).toList(),
        recommendations: _recommendations,
        certification: null,
        evidenceUrls: _evidenceImages,
        createdAt: DateTime.now(),
      );

      reportsProvider.addDiagnosis(diagnosis);
      debugPrint('✅ Diagnóstico guardado en reportes para ${_selectedProducer!.name}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Diagnóstico guardado correctamente'),
          backgroundColor: AppTheme.primaryGreen,
        ),
      );
    } catch (e) {
      debugPrint('❌ Error al guardar diagnóstico: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error al guardar diagnóstico: $e'),
          backgroundColor: AppTheme.berryRed,
        ),
      );
    }
  }

  // ── MÉTODOS DE CONSTRUCCIÓN ──────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: AuroraBackground(
        isDark: isDark,
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _buildHeader(isDark, textColor),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildProducerSelector(isDark, textColor),
                    const SizedBox(height: 8),
                    _buildLotInfoCard(isDark, textColor),
                    const SizedBox(height: 8),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    DiagnosisSummaryCard(
                      isDark: isDark,
                      diagnosis: _getCurrentDiagnosis(),
                    ),
                    const SizedBox(height: 8),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildSectionTitle('Análisis por categorías', isDark),
                    const SizedBox(height: 6),
                    if (_categories.isEmpty)
                      _buildEmptyMessage('Agrega categorías para evaluar', isDark)
                    else
                      ..._categories.map((cat) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: DiagnosisCategoryCard(
                          isDark: isDark,
                          label: cat['label'] as String,
                          value: cat['value'] as int,
                          color: cat['color'] as Color,
                        ),
                      )),
                    const SizedBox(height: 8),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildSectionTitle('Problemas detectados', isDark),
                    const SizedBox(height: 6),
                    if (_issues.isEmpty)
                      _buildEmptyMessage('Sin problemas detectados', isDark)
                    else
                      ..._issues.map((issue) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: DiagnosisIssueCard(
                          isDark: isDark,
                          title: issue['title'] as String,
                          level: issue['level'] as String,
                          priority: issue['priority'] as String,
                          priorityColor: issue['priorityColor'] as Color,
                          onTap: () {},
                        ),
                      )),
                    const SizedBox(height: 8),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    DiagnosisAICard(
                      isDark: isDark,
                      confidence: _categories.isNotEmpty ? 75 : 0,
                      description: _categories.isNotEmpty
                          ? 'Análisis basado en ${_categories.length} categorías evaluadas.'
                          : 'Agrega categorías para obtener un análisis predictivo.',
                      onExplain: () {},
                    ),
                    const SizedBox(height: 8),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildSectionTitle('Factores de riesgo', isDark),
                    const SizedBox(height: 6),
                    if (_risks.isEmpty)
                      _buildEmptyMessage('Sin factores de riesgo identificados', isDark)
                    else
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: _risks.map((risk) => DiagnosisRiskIndicator(
                          isDark: isDark,
                          label: risk['label'] as String,
                          level: risk['level'] as String,
                          color: risk['color'] as Color,
                        )).toList(),
                      ),
                    const SizedBox(height: 8),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    DiagnosisPredictionCard(
                      isDark: isDark,
                      diagnosis: _getCurrentDiagnosis(),
                    ),
                    const SizedBox(height: 8),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildSectionTitle('Evidencias del diagnóstico', isDark),
                    const SizedBox(height: 6),
                    if (_evidenceImages.isEmpty)
                      _buildEmptyMessage('Sin evidencias del diagnóstico', isDark)
                    else
                      _buildEvidenceGallery(isDark, textColor),
                    const SizedBox(height: 8),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    DiagnosisRecommendationCard(
                      isDark: isDark,
                      recommendations: _recommendations,
                      onCreateRecommendation: () {
                        _showAddRecommendationDialog(isDark);
                      },
                    ),
                    const SizedBox(height: 8),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildPriorityIndicator(isDark, textColor),
                    const SizedBox(height: 8),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildQuickActions(isDark),
                    const SizedBox(height: 8),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildMainButton(),
                    const SizedBox(height: 50),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(isDark),
    );
  }

  Widget _buildProducerSelector(bool isDark, Color textColor) {
    final producersProvider = Provider.of<TechnicianProducersProvider>(context);
    final producers = producersProvider.producers;

    if (producers.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.coffeeDeep.withOpacity(0.7) : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.alertOrange.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.warning, color: AppTheme.alertOrange, size: 24),
            const SizedBox(width: 12),
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

    final bool hasValidSelection = _selectedProducerId != null &&
        producers.any((p) => p.id == _selectedProducerId);

    if (!hasValidSelection && _selectedProducerId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _selectedProducerId = null;
          _selectedProducer = null;
        });
      });
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.coffeeDeep.withOpacity(0.7) : Colors.white.withOpacity(0.9),
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
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: textColor.withOpacity(0.1),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Icon(Icons.person, color: AppTheme.primaryGreen, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: hasValidSelection ? _selectedProducerId : null,
                      isExpanded: true,
                      hint: Text(
                        'Selecciona un productor',
                        style: TextStyle(color: textColor.withOpacity(0.4), fontSize: 12),
                      ),
                      dropdownColor: isDark ? AppTheme.coffeeDeep : Colors.white,
                      style: TextStyle(color: textColor, fontSize: 12),
                      icon: Icon(Icons.arrow_drop_down, color: textColor.withOpacity(0.5)),
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
                                      producer.location,
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
                          _selectedProducerId = value;
                          _selectedProducer = producers.firstWhere((p) => p.id == value);
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark, Color textColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Row(
        children: [
          NeumorphicIconButton(
            icon: Icons.arrow_back,
            isDark: isDark,
            onPressed: () => context.pop(),
            size: 36,
            iconSize: 16,
            color: textColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Diagnóstico del Cultivo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Resultado del análisis técnico.',
                  style: TextStyle(
                    fontSize: 11,
                    color: textColor.withOpacity(0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          NeumorphicIconButton(
            icon: Icons.save_outlined,
            isDark: isDark,
            onPressed: _saveDiagnosisToReports,
            size: 36,
            iconSize: 16,
            color: AppTheme.primaryGreen,
          ),
          const SizedBox(width: 4),
          NeumorphicIconButton(
            icon: Icons.picture_as_pdf_outlined,
            isDark: isDark,
            onPressed: () {},
            size: 36,
            iconSize: 16,
            color: AppTheme.primaryGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildLotInfoCard(bool isDark, Color textColor) {
    final producerName = _selectedProducer?.name ?? _producerName;
    final location = _selectedProducer?.location ?? _location;
    final farmName = _farmName;
    final lotName = _lotName;

    return NeumorphicBox(
      isDark: isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.goldCoffee, AppTheme.primaryGreen],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Text('☕', style: TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  lotName.isNotEmpty ? lotName : 'Lote sin nombre',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '🌱 ${farmName.isNotEmpty ? farmName : 'Finca sin nombre'}  •  👨‍🌾 ${producerName.isNotEmpty ? producerName : 'Productor'}',
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor.withOpacity(0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 12, color: textColor.withOpacity(0.4)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location.isNotEmpty ? location : 'Ubicación no especificada',
                        style: TextStyle(
                          fontSize: 11,
                          color: textColor.withOpacity(0.5),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyMessage(String message, bool isDark) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.03)
            : AppTheme.darkCoffee.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: textColor.withOpacity(0.06),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 16, color: textColor.withOpacity(0.2)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 12,
                color: textColor.withOpacity(0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

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

  Widget _buildEvidenceGallery(bool isDark, Color textColor) {
    return NeumorphicBox(
      isDark: isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _evidenceImages.add('📷 Evidencia ${_evidenceImages.length + 1}');
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : AppTheme.darkCoffee.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: textColor.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.photo_library, size: 24, color: AppTheme.primaryGreen),
                        const SizedBox(height: 4),
                        Text(
                          'Agregar foto',
                          style: TextStyle(
                            fontSize: 12,
                            color: textColor.withOpacity(0.6),
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
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : AppTheme.darkCoffee.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: textColor.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.video_library, size: 24, color: AppTheme.goldCoffee),
                        const SizedBox(height: 4),
                        Text(
                          'Videos',
                          style: TextStyle(
                            fontSize: 12,
                            color: textColor.withOpacity(0.6),
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
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : AppTheme.darkCoffee.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: textColor.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.description, size: 24, color: AppTheme.alertOrange),
                        const SizedBox(height: 4),
                        Text(
                          'Documentos',
                          style: TextStyle(
                            fontSize: 12,
                            color: textColor.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_evidenceImages.isNotEmpty)
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _evidenceImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            _evidenceImages[index],
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _evidenceImages.removeAt(index);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: AppTheme.berryRed,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          if (_evidenceImages.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Agrega evidencias del diagnóstico',
                style: TextStyle(
                  fontSize: 12,
                  color: textColor.withOpacity(0.4),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPriorityIndicator(bool isDark, Color textColor) {
    final priorities = [
      {'label': 'Baja', 'color': AppTheme.primaryGreen, 'emoji': '🟢'},
      {'label': 'Media', 'color': AppTheme.goldCoffee, 'emoji': '🟡'},
      {'label': 'Alta', 'color': AppTheme.alertOrange, 'emoji': '🟠'},
      {'label': 'Crítica', 'color': AppTheme.berryRed, 'emoji': '🔴'},
    ];

    final healthScore = _categories.isEmpty ? 0 :
    (_categories.fold(0, (sum, cat) => sum + (cat['value'] as int)) / _categories.length);
    final String selectedPriority = _categories.isEmpty ? 'Sin prioridad' :
    healthScore >= 80 ? 'Baja' : healthScore >= 60 ? 'Media' : 'Alta';

    return NeumorphicBox(
      isDark: isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nivel de prioridad',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: priorities.map((p) {
              final color = p['color'] as Color;
              final isSelected = p['label'] == selectedPriority;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withOpacity(0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? color
                        : textColor.withOpacity(0.1),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      p['emoji'] as String,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      p['label'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? color : textColor,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(bool isDark) {
    final actions = [
      {'icon': Icons.note_add, 'label': 'Crear recomendación', 'color': AppTheme.primaryGreen},
      {'icon': Icons.verified, 'label': 'Emitir certificación', 'color': AppTheme.goldCoffee},
      {'icon': Icons.calendar_today, 'label': 'Programar seguimiento', 'color': AppTheme.alertOrange},
      {'icon': Icons.picture_as_pdf, 'label': 'Exportar reporte', 'color': AppTheme.berryRed},
      {'icon': Icons.add_photo_alternate, 'label': 'Agregar evidencia', 'color': AppTheme.secondaryGreen},
    ];

    return NeumorphicBox(
      isDark: isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Acciones rápidas',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppTheme.darkCoffee,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: actions.map((action) {
              final color = action['color'] as Color;
              final label = action['label'] as String;
              final icon = action['icon'] as IconData;

              return GestureDetector(
                onTap: () {
                  if (label == 'Emitir certificación') {
                    _navigateToCertification();
                  } else if (label == 'Crear recomendación') {
                    _showAddRecommendationDialog(isDark);
                  } else if (label == 'Agregar evidencia') {
                    setState(() {
                      _evidenceImages.add('📷 Evidencia ${_evidenceImages.length + 1}');
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: color.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 16, color: color),
                      const SizedBox(width: 6),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : AppTheme.darkCoffee,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showAddRecommendationDialog(bool isDark) {
    final controller = TextEditingController();
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppTheme.coffeeDeep : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Agregar recomendación',
          style: TextStyle(color: textColor),
        ),
        content: TextField(
          controller: controller,
          maxLines: 3,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            hintText: 'Escribe una recomendación técnica...',
            hintStyle: TextStyle(color: textColor.withOpacity(0.4)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: textColor.withOpacity(0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: textColor.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primaryGreen),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  _recommendations.add(controller.text.trim());
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ Recomendación agregada'),
                    backgroundColor: AppTheme.primaryGreen,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
              foregroundColor: Colors.white,
            ),
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  Widget _buildMainButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveDiagnosisToReports,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.save_outlined, size: 18),
            SizedBox(width: 8),
            Text(
              'Guardar Diagnóstico',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(bool isDark) {
    return NeumorphicBottomNav(
      isDark: isDark,
      currentIndex: _currentIndex,
      items: const [
        Icons.home,
        Icons.people,
        Icons.calendar_today,
        Icons.analytics,
        Icons.person,
      ],
      onTap: (index) {
        setState(() => _currentIndex = index);
        if (index == 0) {
          context.go(RouteNames.technicianDashboard);
        } else if (index == 1) {
          context.go(RouteNames.technicianProducers);
        } else if (index == 2) {
          context.go(RouteNames.technicianAgenda);
        } else if (index == 3) {
          _navigateToCertification();
        } else if (index == 4) {
          context.go(RouteNames.profile);
        }
      },
    );
  }
}