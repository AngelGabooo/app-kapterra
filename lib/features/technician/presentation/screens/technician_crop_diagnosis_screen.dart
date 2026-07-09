// lib/features/technician/presentation/screens/technician_crop_diagnosis_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

  final List<Map<String, dynamic>> _categories = [
    {'label': '🌱 Estado vegetativo', 'value': 88, 'color': AppTheme.primaryGreen},
    {'label': '🍃 Estado foliar', 'value': 76, 'color': AppTheme.goldCoffee},
    {'label': '🍒 Fructificación', 'value': 91, 'color': AppTheme.primaryGreen},
    {'label': '🌳 Manejo del cultivo', 'value': 84, 'color': AppTheme.primaryGreen},
    {'label': '💧 Humedad', 'value': 73, 'color': AppTheme.goldCoffee},
  ];

  final List<Map<String, dynamic>> _issues = [
    {
      'title': '🦠 Posible roya inicial',
      'level': 'Bajo',
      'priority': 'Media',
      'priorityColor': AppTheme.alertOrange,
    },
    {
      'title': '🍃 Deficiencia leve de nitrógeno',
      'level': 'Leve',
      'priority': 'Baja',
      'priorityColor': AppTheme.goldCoffee,
    },
    {
      'title': '🌧 Humedad superior a la recomendada',
      'level': 'Moderado',
      'priority': 'Media',
      'priorityColor': AppTheme.alertOrange,
    },
  ];

  final List<Map<String, dynamic>> _risks = [
    {'label': '🦠 Enfermedades', 'level': 'Medio', 'color': AppTheme.alertOrange},
    {'label': '🐛 Plagas', 'level': 'Bajo', 'color': AppTheme.primaryGreen},
    {'label': '💧 Humedad', 'level': 'Alta', 'color': AppTheme.berryRed},
    {'label': '🌦 Clima', 'level': 'Favorable', 'color': AppTheme.primaryGreen},
  ];

  final List<String> _recommendations = [
    '✔ Aplicar monitoreo preventivo de roya.',
    '✔ Mejorar el manejo de humedad en el lote.',
    '✔ Incrementar fertilización nitrogenada.',
    '✔ Programar nueva inspección en 15 días.',
  ];

  final List<String> _evidenceImages = [
    '📷', '📷', '📷', '📷', '📷'
  ];

  // ── Navegación a Certificación ──────────────────────────────
  void _navigateToCertification() {
    context.push(
      RouteNames.technicianLotCertification,
      extra: {
        'lotName': widget.lotName ?? 'Lote Norte',
        'farmName': widget.farmName ?? 'El Mirador',
        'producerName': widget.producerName ?? 'Juan Pérez',
        'location': widget.location ?? 'Motozintla, Chiapas',
        'variety': 'Bourbon',
      },
    );
  }

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
                      status: 'Regular',
                      statusColor: AppTheme.goldCoffee,
                      score: 82,
                      description:
                      'El cultivo presenta buenas condiciones generales, aunque se identificaron factores que requieren atención preventiva.',
                    ),
                    const SizedBox(height: 20),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildExecutiveSummary(isDark, textColor),
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
                      confidence: 95,
                      description:
                      'Con base en las fotografías, condiciones ambientales y registros históricos, existe una probabilidad del 89% de que el cultivo responda favorablemente si se aplican las recomendaciones en los próximos 15 días.',
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
                      onCreateRecommendation: () {},
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
            icon: Icons.picture_as_pdf_outlined,
            isDark: isDark,
            onPressed: () {},
            size: 40,
            iconSize: 18,
            color: AppTheme.primaryGreen,
          ),
          const SizedBox(width: 4),
          NeumorphicIconButton(
            icon: Icons.share_outlined,
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
                  widget.lotName ?? 'Lote Norte',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '🌱 ${widget.farmName ?? 'El Mirador'}  •  👨‍🌾 ${widget.producerName ?? 'Juan Pérez'}',
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
                        widget.location ?? 'Motozintla, Chiapas',
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
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 12, color: textColor.withOpacity(0.4)),
                    const SizedBox(width: 4),
                    Text(
                      '15 junio 2026  •  Responsable: Carlos Gómez',
                      style: TextStyle(
                        fontSize: 11,
                        color: textColor.withOpacity(0.5),
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

  Widget _buildExecutiveSummary(bool isDark, Color textColor) {
    final items = [
      {'label': '🟢 Aspectos favorables', 'value': '3', 'color': AppTheme.primaryGreen},
      {'label': '🟠 Hallazgos importantes', 'value': '2', 'color': AppTheme.alertOrange},
      {'label': '🔴 Riesgos detectados', 'value': '1', 'color': AppTheme.berryRed},
      {'label': '📋 Acciones recomendadas', 'value': '5', 'color': AppTheme.goldCoffee},
    ];

    return NeumorphicBox(
      isDark: isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumen ejecutivo',
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
            children: items.map((item) {
              final color = item['color'] as Color;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item['value'] as String,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item['label'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor.withOpacity(0.7),
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
                        Icon(Icons.photo_library, size: 24, color: AppTheme.primaryGreen),
                        const SizedBox(height: 4),
                        Text(
                          'Fotografías',
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
                  child: Center(
                    child: Text(
                      _evidenceImages[index],
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                );
              },
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
              final isSelected = p['label'] == 'Alta';
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
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.alertOrange.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.alertOrange.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.alertOrange.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Text('🟠', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prioridad general: Alta',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      Text(
                        'Se requiere atención inmediata en los próximos 7 días.',
                        style: TextStyle(
                          fontSize: 12,
                          color: textColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                  // ✅ CONEXIÓN: Emitir certificación
                  if (label == 'Emitir certificación') {
                    _navigateToCertification();
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

  Widget _buildMainButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
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
            Icon(Icons.description_outlined, size: 18),
            SizedBox(width: 8),
            Text(
              'Generar Recomendación Técnica',
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
        Icons.home,           // ← Índice 0: Inicio (Dashboard)
        Icons.people,         // ← Índice 1: Productores
        Icons.calendar_today, // ← Índice 2: Agenda
        Icons.analytics,      // ← Índice 3: Diagnóstico / Reportes  ✅
        Icons.person,         // ← Índice 4: Perfil
      ],
      onTap: (index) {
        setState(() => _currentIndex = index);
        if (index == 0) {
          context.go(RouteNames.technicianDashboard);
        } else if (index == 1) {
          // context.go(RouteNames.technicianProducers);
        } else if (index == 2) {
          context.go(RouteNames.technicianAgenda);
        } else if (index == 3) {
          // ✅ CONEXIÓN: Navegar a Certificación del Lote
          _navigateToCertification();
        } else if (index == 4) {
          context.go(RouteNames.profile);
        }
      },
    );
  }
}