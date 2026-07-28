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
  });

  final String? lotName;
  final String? farmName;
  final String? producerName;
  final String? location;

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

  // ✅ TODOS LOS DATOS VACÍOS
  final List<Map<String, dynamic>> _categories = [];
  final List<Map<String, dynamic>> _issues = [];
  final List<Map<String, dynamic>> _risks = [];
  final List<String> _recommendations = [];
  final List<String> _evidenceImages = [];

  @override
  void initState() {
    super.initState();
    _loadTechnicianData();

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

  void _navigateToCertification() {
    context.push(
      RouteNames.technicianLotCertification,
      extra: {
        'lotName': widget.lotName ?? 'Lote',
        'farmName': widget.farmName ?? 'Finca',
        'producerName': _selectedProducer?.name ?? widget.producerName ?? 'Productor',
        'location': _selectedProducer?.location ?? widget.location ?? 'Ubicación',
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
        farmId: 'farm_001',
        farmName: widget.farmName ?? _selectedProducer!.farmName ?? 'Finca',
        lotId: 'lot_001',
        lotName: widget.lotName ?? _selectedProducer!.lotName ?? 'Lote',
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
        evidenceUrls: [],
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    final double healthScore = _categories.isEmpty ? 0 :
    (_categories.fold(0, (sum, cat) => sum + (cat['value'] as int)) / _categories.length);
    final int healthScoreInt = healthScore.toInt();
    final String status = _categories.isEmpty ? 'Sin evaluar' :
    healthScore >= 80 ? 'Excelente' : healthScore >= 60 ? 'Atención' : 'Riesgo';
    final Color statusColor = _categories.isEmpty ? Colors.grey :
    healthScore >= 80 ? Colors.green : healthScore >= 60 ? Colors.orange : Colors.red;

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
                    const SizedBox(height: 16),
                    _buildLotInfoCard(isDark, textColor),
                    const SizedBox(height: 20),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    DiagnosisSummaryCard(
                      isDark: isDark,
                      status: status,
                      statusColor: statusColor,
                      score: healthScoreInt,
                      description: _categories.isEmpty
                          ? 'Selecciona un productor y comienza el diagnóstico.'
                          : 'Diagnóstico basado en ${_categories.length} categorías evaluadas.',
                    ),
                    const SizedBox(height: 20),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildSectionTitle('Análisis por categorías', isDark),
                    const SizedBox(height: 12),
                    if (_categories.isEmpty)
                      _buildEmptyMessage('Agrega categorías para evaluar', isDark)
                    else
                      ..._categories.map((cat) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: DiagnosisCategoryCard(
                          isDark: isDark,
                          label: cat['label'] as String,
                          value: cat['value'] as int,
                          color: cat['color'] as Color,
                        ),
                      )),
                    const SizedBox(height: 20),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildSectionTitle('Problemas detectados', isDark),
                    const SizedBox(height: 12),
                    if (_issues.isEmpty)
                      _buildEmptyMessage('Sin problemas detectados', isDark)
                    else
                      ..._issues.map((issue) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: DiagnosisIssueCard(
                          isDark: isDark,
                          title: issue['title'] as String,
                          level: issue['level'] as String,
                          priority: issue['priority'] as String,
                          priorityColor: issue['priorityColor'] as Color,
                          onTap: () {},
                        ),
                      )),
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 20),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildSectionTitle('Factores de riesgo', isDark),
                    const SizedBox(height: 12),
                    if (_risks.isEmpty)
                      _buildEmptyMessage('Sin factores de riesgo identificados', isDark)
                    else
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _risks.map((risk) => DiagnosisRiskIndicator(
                          isDark: isDark,
                          label: risk['label'] as String,
                          level: risk['level'] as String,
                          color: risk['color'] as Color,
                        )).toList(),
                      ),
                    const SizedBox(height: 20),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    DiagnosisPredictionCard(isDark: isDark),
                    const SizedBox(height: 20),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildSectionTitle('Galería de evidencias', isDark),
                    const SizedBox(height: 12),
                    if (_evidenceImages.isEmpty)
                      _buildEmptyMessage('Agrega evidencias del diagnóstico', isDark)
                    else
                      _buildEvidenceGallery(isDark, textColor),
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 20),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildPriorityIndicator(isDark, textColor),
                    const SizedBox(height: 24),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildQuickActions(isDark),
                    const SizedBox(height: 24),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildMainButton(),
                    const SizedBox(height: 100),
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

  // ✅ SELECTOR DE PRODUCTOR CORREGIDO
  Widget _buildProducerSelector(bool isDark, Color textColor) {
    final producersProvider = Provider.of<TechnicianProducersProvider>(context);
    final producers = producersProvider.producers;

    if (producers.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.coffeeDeep.withOpacity(0.7) : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.alertOrange.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(Icons.warning, color: AppTheme.alertOrange, size: 32),
            const SizedBox(height: 8),
            Text(
              'No tienes productores asignados',
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
            Text(
              'La cooperativa debe asignarte un productor para realizar diagnósticos.',
              style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // ✅ Verificar si el ID seleccionado existe en la lista
    final bool hasValidSelection = _selectedProducerId != null &&
        producers.any((p) => p.id == _selectedProducerId);

    // Si no es válido, resetear la selección
    if (!hasValidSelection && _selectedProducerId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _selectedProducerId = null;
          _selectedProducer = null;
        });
      });
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.coffeeDeep.withOpacity(0.7) : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: textColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seleccionar productor *',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: hasValidSelection ? _selectedProducerId : null,
            isExpanded: true,
            hint: Text(
              'Selecciona un productor',
              style: TextStyle(color: textColor.withOpacity(0.4)),
            ),
            dropdownColor: isDark ? AppTheme.coffeeDeep : Colors.white,
            style: TextStyle(color: textColor, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Selecciona un productor',
              hintStyle: TextStyle(color: textColor.withOpacity(0.4)),
              prefixIcon: Icon(Icons.person, color: AppTheme.primaryGreen),
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
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
                        children: [
                          Text(
                            producer.name,
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            producer.location,
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
                _selectedProducerId = value;
                _selectedProducer = producers.firstWhere((p) => p.id == value);
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Selecciona un productor';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark, Color textColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: Row(
        children: [
          NeumorphicIconButton(
            icon: Icons.arrow_back,
            isDark: isDark,
            onPressed: () => context.pop(),
            size: 40,
            iconSize: 18,
            color: textColor,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Diagnóstico del Cultivo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Resultado del análisis técnico.',
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor.withOpacity(0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          NeumorphicIconButton(
            icon: Icons.save_outlined,
            isDark: isDark,
            onPressed: _saveDiagnosisToReports,
            size: 40,
            iconSize: 18,
            color: AppTheme.primaryGreen,
          ),
          const SizedBox(width: 4),
          NeumorphicIconButton(
            icon: Icons.picture_as_pdf_outlined,
            isDark: isDark,
            onPressed: () {},
            size: 40,
            iconSize: 18,
            color: AppTheme.primaryGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildLotInfoCard(bool isDark, Color textColor) {
    final producerName = _selectedProducer?.name ?? widget.producerName ?? 'Productor';
    final location = _selectedProducer?.location ?? widget.location ?? 'Ubicación';
    final farmName = _selectedProducer?.farmName ?? widget.farmName ?? 'Finca';
    final lotName = _selectedProducer?.lotName ?? widget.lotName ?? 'Lote';

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
              children: [
                Text(
                  lotName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '🌱 $farmName  •  👨‍🌾 $producerName',
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
                        location,
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
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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