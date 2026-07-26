// lib/features/buyer/presentation/screens/reports/reports_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/buyer/presentation/screens/reports/widgets/report_card.dart';
import 'package:kaabcafe/features/buyer/presentation/screens/reports/widgets/report_filter.dart';
import 'package:kaabcafe/features/buyer/presentation/screens/reports/widgets/report_chart.dart';
import 'package:kaabcafe/features/technician/providers/technician_reports_provider.dart';
import 'package:kaabcafe/features/technician/data/models/technician_visit_model.dart';
import 'package:kaabcafe/features/technician/data/models/technician_diagnosis_model.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int _currentIndex = 3;
  String _selectedPeriod = 'Este mes';
  String _selectedReportType = 'Producción';
  String _selectedTechnician = 'Todos';

  final List<String> _periods = ['Hoy', 'Esta semana', 'Este mes', 'Este año'];
  final List<String> _reportTypes = [
    'Producción',
    'Acopio',
    'Ventas',
    'Trazabilidad',
    'Visitas Técnicas',
    'Diagnósticos',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<TechnicianReportsProvider>(context, listen: false);
      // Cargar datos de ejemplo (en producción vendrían del backend)
      _loadSampleData(provider);
    });
  }

  void _loadSampleData(TechnicianReportsProvider provider) {
    // ✅ VISITAS DE EJEMPLO
    provider.addVisit(TechnicianVisitModel(
      id: 'v1',
      technicianId: 't1',
      technicianName: 'Ing. María González',
      producerId: 'p1',
      producerName: 'Juan Pérez Gómez',
      farmId: 'f1',
      farmName: 'Finca El Mirador',
      lotId: 'l1',
      lotName: 'Lote Central',
      location: 'Motozintla, Chiapas',
      visitDate: DateTime.now().subtract(const Duration(days: 2)),
      objective: 'Evaluación fitosanitaria',
      observations: 'Se detectaron signos tempranos de roya en el 15% del lote. Se recomienda aplicación de fungicida.',
      recommendations: ['Aplicar fungicida sistémico', 'Monitorear cada 15 días'],
      evidenceUrls: [],
      status: 'completed',
      isUrgent: false,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ));

    provider.addVisit(TechnicianVisitModel(
      id: 'v2',
      technicianId: 't2',
      technicianName: 'Ing. Carlos Ramírez',
      producerId: 'p2',
      producerName: 'María López Hernández',
      farmId: 'f2',
      farmName: 'Finca Santa Lucía',
      lotId: 'l2',
      lotName: 'Lote La Esperanza',
      location: 'Tapachula, Chiapas',
      visitDate: DateTime.now().subtract(const Duration(days: 5)),
      objective: 'Revisión de cosecha',
      observations: 'La cosecha avanza bien. Se recomienda empezar la selección de café de especialidad.',
      recommendations: ['Iniciar selección de granos', 'Mantener registros de calidad'],
      evidenceUrls: [],
      status: 'completed',
      isUrgent: false,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ));

    // ✅ DIAGNÓSTICOS DE EJEMPLO
    provider.addDiagnosis(TechnicianDiagnosisModel(
      id: 'd1',
      technicianId: 't1',
      technicianName: 'Ing. María González',
      producerId: 'p1',
      producerName: 'Juan Pérez Gómez',
      farmId: 'f1',
      farmName: 'Finca El Mirador',
      lotId: 'l1',
      lotName: 'Lote Central',
      location: 'Motozintla, Chiapas',
      diagnosisDate: DateTime.now().subtract(const Duration(days: 3)),
      healthScore: 82.5,
      status: 'Atención',
      categories: [
        DiagnosisCategory(label: 'Fertilidad del suelo', value: 75, color: Colors.orange),
        DiagnosisCategory(label: 'Sanidad vegetal', value: 65, color: Colors.orange),
        DiagnosisCategory(label: 'Riego', value: 90, color: Colors.green),
        DiagnosisCategory(label: 'Nutrición', value: 80, color: Colors.green),
      ],
      issues: [
        DiagnosisIssue(
          title: 'Roya detectada',
          level: 'Medio',
          priority: 'Alta',
          priorityColor: Colors.orange,
        ),
        DiagnosisIssue(
          title: 'Fertilización deficiente',
          level: 'Bajo',
          priority: 'Media',
          priorityColor: Colors.blue,
        ),
      ],
      risks: [
        DiagnosisRisk(label: 'Humedad excesiva', level: 'Medio', color: Colors.orange),
        DiagnosisRisk(label: 'Temperatura elevada', level: 'Bajo', color: Colors.blue),
      ],
      recommendations: ['Aplicar fungicida', 'Ajustar riego', 'Monitorear temperatura'],
      certification: null,
      evidenceUrls: [],
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ));

    provider.addDiagnosis(TechnicianDiagnosisModel(
      id: 'd2',
      technicianId: 't2',
      technicianName: 'Ing. Carlos Ramírez',
      producerId: 'p2',
      producerName: 'María López Hernández',
      farmId: 'f2',
      farmName: 'Finca Santa Lucía',
      lotId: 'l2',
      lotName: 'Lote La Esperanza',
      location: 'Tapachula, Chiapas',
      diagnosisDate: DateTime.now().subtract(const Duration(days: 6)),
      healthScore: 92.0,
      status: 'Excelente',
      categories: [
        DiagnosisCategory(label: 'Fertilidad del suelo', value: 95, color: Colors.green),
        DiagnosisCategory(label: 'Sanidad vegetal', value: 90, color: Colors.green),
        DiagnosisCategory(label: 'Riego', value: 88, color: Colors.green),
        DiagnosisCategory(label: 'Nutrición', value: 95, color: Colors.green),
      ],
      issues: [],
      risks: [],
      recommendations: ['Mantener prácticas actuales', 'Considerar certificación de especialidad'],
      certification: 'Orgánico',
      evidenceUrls: [],
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
    ));
  }

  // ✅ OBTENER TÉCNICOS ÚNICOS
  List<String> get _technicians {
    final provider = Provider.of<TechnicianReportsProvider>(context);
    final allTechs = provider.visits.map((v) => v.technicianName).toList();
    allTechs.addAll(provider.diagnoses.map((d) => d.technicianName));
    return ['Todos', ...allTechs.toSet().toList()];
  }

  // ✅ CONTAR VISITAS POR TÉCNICO
  int _countVisitsByTechnician(String technicianName) {
    final provider = Provider.of<TechnicianReportsProvider>(context);
    if (technicianName == 'Todos') {
      return provider.totalVisits;
    }
    return provider.visits.where((v) => v.technicianName == technicianName).length;
  }

  // ✅ CONTAR DIAGNÓSTICOS POR TÉCNICO
  int _countDiagnosesByTechnician(String technicianName) {
    final provider = Provider.of<TechnicianReportsProvider>(context);
    if (technicianName == 'Todos') {
      return provider.totalDiagnoses;
    }
    return provider.diagnoses.where((d) => d.technicianName == technicianName).length;
  }

  // ✅ OBTENER VISITAS FILTRADAS
  List<TechnicianVisitModel> _getFilteredVisits() {
    final provider = Provider.of<TechnicianReportsProvider>(context);
    if (_selectedTechnician == 'Todos') {
      return provider.visits;
    }
    return provider.visits.where((v) => v.technicianName == _selectedTechnician).toList();
  }

  // ✅ OBTENER DIAGNÓSTICOS FILTRADOS
  List<TechnicianDiagnosisModel> _getFilteredDiagnoses() {
    final provider = Provider.of<TechnicianReportsProvider>(context);
    if (_selectedTechnician == 'Todos') {
      return provider.diagnoses;
    }
    return provider.diagnoses.where((d) => d.technicianName == _selectedTechnician).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final cardColor = isDark ? AppTheme.coffeeDeep : Colors.white;

    final provider = Provider.of<TechnicianReportsProvider>(context);
    final hasData = provider.totalVisits > 0 || provider.totalDiagnoses > 0;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.coffeeDark : AppTheme.lightBeige,
      body: SafeArea(
        child: Column(
          children: [
            // ── Barra superior ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reportes',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Análisis, estadísticas y reportes técnicos',
                          style: TextStyle(
                            fontSize: 13,
                            color: textColor.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.file_download_outlined, color: textColor),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.filter_list, color: textColor),
                  ),
                ],
              ),
            ),

            // ── Contenido ──────────────────────────────────────
            Expanded(
              child: hasData
                  ? _buildContentWithData(isDark, cardColor, textColor, provider)
                  : _buildEmptyState(isDark, textColor),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.coffeeDeep : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            if (index == 0) {
              context.go(RouteNames.cooperativeDashboard);
            } else if (index == 1) {
              context.go(RouteNames.producers);
            } else if (index == 2) {
              context.go(RouteNames.acopio);
            } else if (index == 4) {
              context.go(RouteNames.cooperativeProfile);
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? AppTheme.coffeeDeep : Colors.white,
          selectedItemColor: isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen,
          unselectedItemColor: textColor.withOpacity(0.35),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Inicio'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Productores'),
            BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Acopio'),
            BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Reportes'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, Color textColor) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    (isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen).withOpacity(0.1),
                    (isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen).withOpacity(0.03),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.analytics_outlined,
                size: 50,
                color: (isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen).withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Sin reportes disponibles',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Los reportes se generarán automáticamente cuando haya datos de producción, acopio, visitas y diagnósticos.',
              style: TextStyle(
                fontSize: 14,
                color: textColor.withOpacity(0.6),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.refresh),
              label: const Text('Actualizar datos'),
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentWithData(
      bool isDark,
      Color cardColor,
      Color textColor,
      TechnicianReportsProvider provider,
      ) {
    final filteredVisits = _getFilteredVisits();
    final filteredDiagnoses = _getFilteredDiagnoses();
    final totalVisits = filteredVisits.length;
    final totalDiagnoses = filteredDiagnoses.length;
    final totalReports = totalVisits + totalDiagnoses;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // ── Filtros ──────────────────────────────────────────
          ReportFilter(
            selectedPeriod: _selectedPeriod,
            periods: _periods,
            selectedReportType: _selectedReportType,
            reportTypes: _reportTypes,
            onPeriodChanged: (value) => setState(() => _selectedPeriod = value),
            onReportTypeChanged: (value) => setState(() => _selectedReportType = value),
            isDark: isDark,
          ),

          const SizedBox(height: 16),

          // ── Filtro de técnico ──────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 4,
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedTechnician,
                isExpanded: true,
                icon: Icon(Icons.expand_more, color: AppTheme.primaryGreen),
                style: TextStyle(color: textColor, fontSize: 14),
                dropdownColor: isDark ? AppTheme.coffeeDeep : Colors.white,
                items: _technicians.map((tech) {
                  return DropdownMenuItem(
                    value: tech,
                    child: Row(
                      children: [
                        Icon(Icons.engineering, size: 16, color: AppTheme.primaryGreen),
                        const SizedBox(width: 8),
                        Text(tech),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedTechnician = value!),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ── Resumen de reportes técnicos ─────────────────────
          Row(
            children: [
              Expanded(
                child: ReportCard(
                  title: 'Reportes Totales',
                  value: '$totalReports',
                  subtitle: 'visitas + diagnósticos',
                  icon: Icons.analytics,
                  color: AppTheme.primaryGreen,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ReportCard(
                  title: 'Visitas',
                  value: '$totalVisits',
                  subtitle: 'realizadas',
                  icon: Icons.assignment,
                  color: Colors.blue,
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ReportCard(
                  title: 'Diagnósticos',
                  value: '$totalDiagnoses',
                  subtitle: 'realizados',
                  icon: Icons.science,
                  color: Colors.purple,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ReportCard(
                  title: 'Promedio Salud',
                  value: _getAverageHealthScore(filteredDiagnoses),
                  subtitle: 'puntuación',
                  icon: Icons.health_and_safety,
                  color: Colors.green,
                  isDark: isDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Gráfica ──────────────────────────────────────────
          ReportChart(
            isDark: isDark,
            title: _selectedReportType,
            period: _selectedPeriod,
          ),

          const SizedBox(height: 20),

          // ── Lista de visitas técnicas ──────────────────────
          if (filteredVisits.isNotEmpty) ...[
            _buildSectionTitle('Visitas técnicas recientes', isDark),
            const SizedBox(height: 12),
            ...filteredVisits.take(3).map((visit) => _buildVisitCard(visit, isDark, textColor, cardColor)),
            const SizedBox(height: 16),
          ],

          // ── Lista de diagnósticos ───────────────────────────
          if (filteredDiagnoses.isNotEmpty) ...[
            _buildSectionTitle('Diagnósticos recientes', isDark),
            const SizedBox(height: 12),
            ...filteredDiagnoses.take(3).map((diagnosis) => _buildDiagnosisCard(diagnosis, isDark, textColor, cardColor)),
            const SizedBox(height: 16),
          ],

          // ── Exportar reportes ──────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [AppTheme.coffeeDeep, AppTheme.coffeeDark]
                    : [AppTheme.goldCoffee.withOpacity(0.05), AppTheme.primaryGreen.withOpacity(0.02)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: (isDark ? AppTheme.coffeeGoldLight : AppTheme.goldCoffee).withOpacity(0.2),
              ),
            ),
            child: Column(
              children: [
                Text(
                  '📊 Exportar reportes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildExportButton('PDF', Icons.picture_as_pdf, isDark),
                    _buildExportButton('Excel', Icons.table_chart, isDark),
                    _buildExportButton('CSV', Icons.file_present, isDark),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 80),
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
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildVisitCard(TechnicianVisitModel visit, bool isDark, Color textColor, Color cardColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.assignment, size: 16, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      visit.objective,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    Text(
                      '👨‍🌾 ${visit.producerName} • 📍 ${visit.location}',
                      style: TextStyle(
                        fontSize: 11,
                        color: textColor.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  visit.status,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            visit.observations,
            style: TextStyle(
              fontSize: 12,
              color: textColor.withOpacity(0.7),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (visit.recommendations.isNotEmpty) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: visit.recommendations.map((rec) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    rec,
                    style: TextStyle(
                      fontSize: 10,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.person, size: 12, color: textColor.withOpacity(0.3)),
              const SizedBox(width: 4),
              Text(
                visit.technicianName,
                style: TextStyle(
                  fontSize: 10,
                  color: textColor.withOpacity(0.5),
                ),
              ),
              const Spacer(),
              Icon(Icons.calendar_today, size: 12, color: textColor.withOpacity(0.3)),
              const SizedBox(width: 4),
              Text(
                '${visit.visitDate.day}/${visit.visitDate.month}/${visit.visitDate.year}',
                style: TextStyle(
                  fontSize: 10,
                  color: textColor.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosisCard(TechnicianDiagnosisModel diagnosis, bool isDark, Color textColor, Color cardColor) {
    final statusColor = diagnosis.status == 'Excelente'
        ? Colors.green
        : diagnosis.status == 'Atención'
        ? Colors.orange
        : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
          ),
        ],
        border: Border.all(
          color: statusColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.science, size: 16, color: Colors.purple),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${diagnosis.producerName}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            diagnosis.status,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '📊 Puntuación: ${diagnosis.healthScore.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              if (diagnosis.certification != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.goldCoffee.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '✅ ${diagnosis.certification}',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.goldCoffee,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          // Categorías
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: diagnosis.categories.map((cat) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: cat.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: cat.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${cat.label}: ${cat.value}%',
                      style: TextStyle(
                        fontSize: 9,
                        color: cat.color,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          if (diagnosis.issues.isNotEmpty) ...[
            const SizedBox(height: 6),
            ...diagnosis.issues.map((issue) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: issue.priorityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      issue.priority == 'Alta' ? '⚠️' : 'ℹ️',
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        issue.title,
                        style: TextStyle(
                          fontSize: 11,
                          color: issue.priorityColor,
                        ),
                      ),
                    ),
                    Text(
                      issue.level,
                      style: TextStyle(
                        fontSize: 10,
                        color: textColor.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.person, size: 12, color: textColor.withOpacity(0.3)),
              const SizedBox(width: 4),
              Text(
                diagnosis.technicianName,
                style: TextStyle(
                  fontSize: 10,
                  color: textColor.withOpacity(0.5),
                ),
              ),
              const Spacer(),
              Icon(Icons.calendar_today, size: 12, color: textColor.withOpacity(0.3)),
              const SizedBox(width: 4),
              Text(
                '${diagnosis.diagnosisDate.day}/${diagnosis.diagnosisDate.month}/${diagnosis.diagnosisDate.year}',
                style: TextStyle(
                  fontSize: 10,
                  color: textColor.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getAverageHealthScore(List<TechnicianDiagnosisModel> diagnoses) {
    if (diagnoses.isEmpty) return '--';
    final avg = diagnoses.fold(0.0, (sum, d) => sum + d.healthScore) / diagnoses.length;
    return '${avg.toStringAsFixed(0)}%';
  }

  Widget _buildExportButton(String label, IconData icon, bool isDark) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}