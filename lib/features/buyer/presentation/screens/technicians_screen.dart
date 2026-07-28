// lib/features/buyer/presentation/screens/technicians_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/providers/technician_contact_provider.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/buyer/providers/technicians_provider.dart';
import 'package:kaabcafe/features/buyer/presentation/widgets/register_technician_dialog.dart';
import 'package:kaabcafe/features/buyer/data/models/technician_model.dart';
import 'package:kaabcafe/features/buyer/data/models/producer_summary_model.dart';
import 'package:kaabcafe/features/buyer/providers/cooperative_producers_provider.dart';
import 'package:kaabcafe/core/providers/farm_provider.dart';
import 'package:kaabcafe/features/farms/data/models/lot_model.dart';

import '../../../farms/data/models/farm_details_model.dart';

class TechniciansScreen extends StatefulWidget {
  const TechniciansScreen({super.key});

  @override
  State<TechniciansScreen> createState() => _TechniciansScreenState();
}

class _TechniciansScreenState extends State<TechniciansScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'Todos';
  final List<String> _filters = ['Todos', 'Activos', 'Inactivos', 'Pendientes'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<TechniciansProvider>(context, listen: false);
      final contactProvider = Provider.of<TechnicianContactProvider>(context, listen: false);

      provider.init(contactProvider);
    });
  }

  List<TechnicianModel> get _filteredTechnicians {
    final provider = Provider.of<TechniciansProvider>(context);
    var list = provider.technicians;

    if (_searchQuery.isNotEmpty) {
      list = list.where((t) =>
      t.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t.phone.contains(_searchQuery) ||
          t.specialty.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    if (_selectedFilter != 'Todos') {
      final statusMap = {
        'Activos': 'Activo',
        'Inactivos': 'Inactivo',
        'Pendientes': 'Pendiente',
      };
      final status = statusMap[_selectedFilter];
      if (status != null) {
        list = list.where((t) => t.status == status).toList();
      }
    }

    return list;
  }

  void _showRegisterDialog() {
    showDialog(
      context: context,
      builder: (context) => RegisterTechnicianDialog(
        onSave: (technician) {
          Provider.of<TechniciansProvider>(context, listen: false).addTechnician(technician);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Técnico registrado correctamente'),
              backgroundColor: AppTheme.primaryGreen,
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(TechnicianModel technician) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Eliminar técnico'),
        content: Text('¿Estás seguro de eliminar a "${technician.fullName}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<TechniciansProvider>(context, listen: false).removeTechnician(technician.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('🗑️ Técnico "${technician.fullName}" eliminado'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _acceptTechnician(TechnicianModel technician) {
    final provider = Provider.of<TechniciansProvider>(context, listen: false);
    final contactProvider = Provider.of<TechnicianContactProvider>(context, listen: false);

    provider.acceptTechnician(technician.id);

    final request = contactProvider.pendingRequests.firstWhere(
          (r) => r.technicianEmail == technician.email,
      orElse: () => throw Exception('Solicitud no encontrada'),
    );
    contactProvider.updateRequestStatus(request.id, 'accepted');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Técnico "${technician.fullName}" aceptado'),
        backgroundColor: AppTheme.primaryGreen,
      ),
    );
  }

  void _rejectTechnician(TechnicianModel technician) {
    final provider = Provider.of<TechniciansProvider>(context, listen: false);
    final contactProvider = Provider.of<TechnicianContactProvider>(context, listen: false);

    final request = contactProvider.pendingRequests.firstWhere(
          (r) => r.technicianEmail == technician.email,
      orElse: () => throw Exception('Solicitud no encontrada'),
    );
    contactProvider.updateRequestStatus(request.id, 'rejected');

    provider.rejectTechnician(technician.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('❌ Técnico "${technician.fullName}" rechazado'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showTechnicianDetail(TechnicianModel technician) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TechnicianDetailSheet(
        technician: technician,
        isDark: Theme.of(context).brightness == Brightness.dark,
      ),
    );
  }

  void _showProducerDetail(ProducerSummaryModel producer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ProducerDetailSheet(
        producer: producer,
        isDark: Theme.of(context).brightness == Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final cardColor = isDark ? AppTheme.coffeeDeep : Colors.white;

    final provider = Provider.of<TechniciansProvider>(context);
    final filtered = _filteredTechnicians;
    final activeCount = provider.activeCount;
    final pendingCount = provider.pendingCount;
    final totalAssignments = provider.technicians.fold(0, (sum, t) => sum + t.assignedProducers.length);

    final totalVisits = provider.technicians.fold(0, (sum, t) => sum + t.totalVisits);
    final totalPendingVisits = provider.technicians.fold(0, (sum, t) => sum + t.pendingVisits);
    final totalRecommendations = provider.technicians.fold(0, (sum, t) => sum + t.recommendations);
    final totalCertifications = provider.technicians.fold(0, (sum, t) => sum + t.certifications);

    return Scaffold(
      backgroundColor: isDark ? AppTheme.coffeeDark : AppTheme.lightBeige,
      appBar: AppBar(
        backgroundColor: isDark ? AppTheme.coffeeDeep : Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.go(RouteNames.cooperativeDashboard),
          icon: Icon(Icons.arrow_back, color: textColor),
        ),
        title: Text(
          'Técnicos Agrícolas',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search, color: textColor),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: _showRegisterDialog,
              icon: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
      body: filtered.isEmpty
          ? _buildEmptyState(isDark, textColor)
          : Column(
        children: [
          _buildKPIs(
            isDark: isDark,
            textColor: textColor,
            activeCount: activeCount,
            pendingCount: pendingCount,
            totalAssignments: totalAssignments,
            totalVisits: totalVisits,
            totalPendingVisits: totalPendingVisits,
            totalRecommendations: totalRecommendations,
            totalCertifications: totalCertifications,
          ),
          _buildFilters(isDark, textColor, cardColor),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final tech = filtered[index];
                return _buildTechnicianCard(tech, isDark, textColor);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPIs({
    required bool isDark,
    required Color textColor,
    required int activeCount,
    required int pendingCount,
    required int totalAssignments,
    required int totalVisits,
    required int totalPendingVisits,
    required int totalRecommendations,
    required int totalCertifications,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              _buildKPIItem(
                isDark: isDark,
                label: 'Activos',
                value: '$activeCount',
                icon: Icons.engineering,
                color: Colors.green,
              ),
              const SizedBox(width: 12),
              _buildKPIItem(
                isDark: isDark,
                label: 'Pendientes',
                value: '$pendingCount',
                icon: Icons.pending,
                color: Colors.orange,
              ),
              const SizedBox(width: 12),
              _buildKPIItem(
                isDark: isDark,
                label: 'Asignaciones',
                value: '$totalAssignments',
                icon: Icons.people,
                color: AppTheme.primaryGreen,
              ),
              const SizedBox(width: 12),
              _buildKPIItem(
                isDark: isDark,
                label: 'Visitas',
                value: '$totalVisits',
                icon: Icons.assignment,
                color: Colors.blue,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildKPIItem(
                isDark: isDark,
                label: 'Pendientes',
                value: '$totalPendingVisits',
                icon: Icons.pending,
                color: Colors.orange,
              ),
              const SizedBox(width: 12),
              _buildKPIItem(
                isDark: isDark,
                label: 'Recomendaciones',
                value: '$totalRecommendations',
                icon: Icons.lightbulb,
                color: Colors.purple,
              ),
              const SizedBox(width: 12),
              _buildKPIItem(
                isDark: isDark,
                label: 'Certificaciones',
                value: '$totalCertifications',
                icon: Icons.verified,
                color: AppTheme.goldCoffee,
              ),
              const SizedBox(width: 12),
              _buildKPIItem(
                isDark: isDark,
                label: 'Calificación',
                value: '4.5⭐',
                icon: Icons.star,
                color: Colors.amber,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKPIItem({
    required bool isDark,
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.coffeeDeep : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 14, color: color),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 8,
                color: textColor.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(bool isDark, Color textColor, Color cardColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _filters.length,
          itemBuilder: (context, index) {
            final filter = _filters[index];
            final isSelected = _selectedFilter == filter;
            return GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryGreen : Colors.grey.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? Colors.white : textColor.withOpacity(0.6),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTechnicianCard(TechnicianModel technician, bool isDark, Color textColor) {
    final isPending = technician.status == 'Pendiente';

    return GestureDetector(
      onTap: () => _showTechnicianDetail(technician),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.coffeeDeep : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPending
                ? Colors.orange.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: isPending
                        ? LinearGradient(
                      colors: [Colors.orange, Colors.orange.shade700],
                    )
                        : LinearGradient(
                      colors: [AppTheme.primaryGreen, AppTheme.secondaryGreen],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      technician.fullName.split(' ').map((e) => e[0]).take(2).join(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        technician.fullName,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.science, size: 12, color: textColor.withOpacity(0.3)),
                          const SizedBox(width: 4),
                          Text(
                            technician.specialty,
                            style: TextStyle(
                              fontSize: 12,
                              color: textColor.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.people, size: 12, color: textColor.withOpacity(0.3)),
                          const SizedBox(width: 4),
                          Text(
                            '${technician.assignedProducers.length} productores',
                            style: TextStyle(
                              fontSize: 12,
                              color: textColor.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: technician.statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    technician.statusText,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: technician.statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (isPending) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _acceptTechnician(technician),
                    icon: Icon(Icons.check, size: 16, color: Colors.green),
                    label: const Text('Aceptar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      side: BorderSide(color: Colors.green.withOpacity(0.3)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () => _rejectTechnician(technician),
                    icon: Icon(Icons.close, size: 16, color: Colors.red),
                    label: const Text('Rechazar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      side: BorderSide(color: Colors.red.withOpacity(0.3)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.orange.withOpacity(0.1),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Esperando aprobación de la cooperativa',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Row(
                children: [
                  _buildMetricChip(
                    icon: Icons.assignment,
                    label: '${technician.totalVisits} visitas',
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  _buildMetricChip(
                    icon: Icons.pending,
                    label: '${technician.pendingVisits} pendientes',
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  _buildMetricChip(
                    icon: Icons.lightbulb,
                    label: '${technician.recommendations} rec.',
                    color: Colors.purple,
                  ),
                  const SizedBox(width: 8),
                  _buildMetricChip(
                    icon: Icons.verified,
                    label: '${technician.certifications} cert.',
                    color: AppTheme.goldCoffee,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Rendimiento',
                              style: TextStyle(
                                fontSize: 10,
                                color: textColor.withOpacity(0.5),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${technician.performance.toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: technician.performance > 80 ? Colors.green : Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: (technician.performance / 100).clamp(0.0, 1.0),
                            backgroundColor: Colors.grey.withOpacity(0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              technician.performance > 80 ? Colors.green : Colors.orange,
                            ),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.chevron_right,
                    color: textColor.withOpacity(0.3),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetricChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
            ),
          ),
        ],
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
                Icons.engineering_outlined,
                size: 50,
                color: (isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen).withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No hay técnicos registrados',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Los técnicos que soliciten unirse aparecerán aquí.\n'
                  'También puedes registrarlos manualmente.',
              style: TextStyle(
                fontSize: 14,
                color: textColor.withOpacity(0.6),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _showRegisterDialog,
              icon: const Icon(Icons.add),
              label: const Text('Registrar técnico'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppTheme.coffeeMedium : AppTheme.primaryGreen,
                foregroundColor: Colors.white,
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
}

// ============================================================
// ✅ BOTTOM SHEET PARA DETALLE DEL TÉCNICO
// ============================================================
class _TechnicianDetailSheet extends StatelessWidget {
  final TechnicianModel technician;
  final bool isDark;

  const _TechnicianDetailSheet({
    required this.technician,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final cardColor = isDark ? AppTheme.coffeeDeep : Colors.white;

    final producersProvider = Provider.of<CooperativeProducersProvider>(context);
    final assignedProducers = technician.assignedProducers
        .map((id) => producersProvider.getProducerById(id))
        .where((p) => p != null)
        .cast<ProducerSummaryModel>()
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.coffeeDark : AppTheme.lightBeige,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: textColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.primaryGreen, AppTheme.secondaryGreen],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          technician.fullName.split(' ').map((e) => e[0]).take(2).join(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            technician.fullName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            technician.specialty,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.primaryGreen,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 14, color: textColor.withOpacity(0.5)),
                              const SizedBox(width: 4),
                              Text(
                                technician.location ?? 'Sin ubicación',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: textColor.withOpacity(0.5),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: technician.statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  technician.statusText,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: technician.statusColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                _buildDetailKPI(
                  icon: Icons.people,
                  label: 'Productores asignados',
                  value: '${assignedProducers.length}',
                  color: AppTheme.primaryGreen,
                  textColor: textColor,
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _buildSmallKPI(
                        icon: Icons.assignment,
                        label: 'Visitas realizadas',
                        value: '${technician.totalVisits}',
                        color: Colors.blue,
                        textColor: textColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSmallKPI(
                        icon: Icons.pending,
                        label: 'Visitas pendientes',
                        value: '${technician.pendingVisits}',
                        color: Colors.orange,
                        textColor: textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildSmallKPI(
                        icon: Icons.lightbulb,
                        label: 'Recomendaciones',
                        value: '${technician.recommendations}',
                        color: Colors.purple,
                        textColor: textColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSmallKPI(
                        icon: Icons.verified,
                        label: 'Certificaciones',
                        value: '${technician.certifications}',
                        color: AppTheme.goldCoffee,
                        textColor: textColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Container(
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
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Rendimiento del técnico',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${technician.performance.toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: technician.performance > 80 ? Colors.green : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: (technician.performance / 100).clamp(0.0, 1.0),
                          backgroundColor: Colors.grey.withOpacity(0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            technician.performance > 80 ? Colors.green : Colors.orange,
                          ),
                          minHeight: 10,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Productividad',
                            style: TextStyle(
                              fontSize: 12,
                              color: textColor.withOpacity(0.5),
                            ),
                          ),
                          Text(
                            'Meta: 80%',
                            style: TextStyle(
                              fontSize: 12,
                              color: textColor.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Container(
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
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Productores asignados',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (assignedProducers.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Sin productores asignados',
                              style: TextStyle(
                                fontSize: 13,
                                color: textColor.withOpacity(0.5),
                              ),
                            ),
                          ),
                        )
                      else
                        ...assignedProducers.map((producer) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => _ProducerDetailSheet(
                                  producer: producer,
                                  isDark: isDark,
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.withOpacity(0.1),
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [AppTheme.primaryGreen, AppTheme.secondaryGreen],
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        producer.name.isNotEmpty
                                            ? producer.name.split(' ').map((e) => e[0]).take(2).join()
                                            : '?',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          producer.name,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: textColor,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${producer.farmsCount} fincas • ${producer.lotsCount} lotes',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: textColor.withOpacity(0.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: producer.status == 'Activo'
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.orange.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      producer.status,
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                        color: producer.status == 'Activo'
                                            ? Colors.green
                                            : Colors.orange,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.chevron_right,
                                    size: 18,
                                    color: textColor.withOpacity(0.3),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailKPI({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor.withOpacity(0.5),
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallKPI({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: textColor.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// ✅ BOTTOM SHEET PARA DETALLE DEL PRODUCTOR CON DATOS DINÁMICOS
// ============================================================
// ============================================================
// ✅ BOTTOM SHEET PARA DETALLE DEL PRODUCTOR CON DATOS REALES
// ============================================================
class _ProducerDetailSheet extends StatelessWidget {
  final ProducerSummaryModel producer;
  final bool isDark;

  const _ProducerDetailSheet({
    required this.producer,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final cardColor = isDark ? AppTheme.coffeeDeep : Colors.white;

    // ✅ OBTENER FINCAS Y LOTES DEL PRODUCTOR DESDE EL PROVIDER
    final farmProvider = Provider.of<FarmProvider>(context);

    // ✅ Obtener las fincas del productor usando el ID del productor
    final producerFarms = farmProvider.getFarmsByProducer(producer.id);

    // ✅ Obtener todos los lotes de las fincas del productor
    final List<Map<String, dynamic>> lots = [];
    for (final farm in producerFarms) {
      final farmLots = farmProvider.getLotsForFarm(farm.id);
      for (final lot in farmLots) {
        lots.add({
          'id': lot.id,
          'name': lot.name,
          'variety': lot.variety,
          'area': lot.area,
          'production': lot.estimatedProduction,
          'status': lot.statusText,
          'farmName': farm.name,
        });
      }
    }

    final hasLots = lots.isNotEmpty;
    final hasFarms = producerFarms.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.coffeeDark : AppTheme.lightBeige,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: textColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Encabezado del productor
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.primaryGreen, AppTheme.secondaryGreen],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          producer.name.split(' ').map((e) => e[0]).take(2).join(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            producer.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            producer.email,
                            style: TextStyle(
                              fontSize: 13,
                              color: textColor.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: producer.status == 'Activo'
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  producer.status,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: producer.status == 'Activo'
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${hasFarms ? producerFarms.length : 0} fincas',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: textColor.withOpacity(0.5),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '• ${hasLots ? lots.length : 0} lotes',
                                style: TextStyle(
                                  fontSize: 12,
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

                const SizedBox(height: 24),

                // KPIs del productor
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.primaryGreen.withOpacity(0.1),
                        AppTheme.goldCoffee.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.primaryGreen.withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '${producer.totalProduction.toStringAsFixed(0)} kg',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                            Text(
                              'Producción total',
                              style: TextStyle(
                                fontSize: 10,
                                color: textColor.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '${producer.averageQuality.toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.goldCoffee,
                              ),
                            ),
                            Text(
                              'Calidad promedio',
                              style: TextStyle(
                                fontSize: 10,
                                color: textColor.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '${hasFarms ? producerFarms.length : 0}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown,
                              ),
                            ),
                            Text(
                              'Fincas activas',
                              style: TextStyle(
                                fontSize: 10,
                                color: textColor.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ✅ LISTA DE FINCAS DEL PRODUCTOR
                Row(
                  children: [
                    Text(
                      'Fincas del productor',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${hasFarms ? producerFarms.length : 0} fincas',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                if (!hasFarms)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.1),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.landscape_outlined,
                            size: 40,
                            color: textColor.withOpacity(0.3),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Este productor no tiene fincas registradas',
                            style: TextStyle(
                              fontSize: 13,
                              color: textColor.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...producerFarms.map((farm) => _buildFarmCard(
                    farm: farm,
                    isDark: isDark,
                    textColor: textColor,
                    context: context, // ✅ PASAR EL CONTEXT
                  )),

                const SizedBox(height: 20),

                // ✅ LISTA DE LOTES DEL PRODUCTOR
                Row(
                  children: [
                    Text(
                      'Lotes del productor',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${lots.length} lotes',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                if (!hasLots)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.1),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 40,
                            color: textColor.withOpacity(0.3),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Este productor no tiene lotes registrados',
                            style: TextStyle(
                              fontSize: 13,
                              color: textColor.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Los lotes aparecerán aquí cuando el productor los registre.',
                            style: TextStyle(
                              fontSize: 11,
                              color: textColor.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...lots.map((lot) => _buildLotCard(lot, isDark, textColor)),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  // ✅ TARJETA DE FINCA - CON CONTEXT COMO PARÁMETRO
  Widget _buildFarmCard({
    required FarmDetailsModel farm,
    required bool isDark,
    required Color textColor,
    required BuildContext context, // ✅ CONTEXT PASADO COMO PARÁMETRO
  }) {
    final farmLots = Provider.of<FarmProvider>(context, listen: false).getLotsForFarm(farm.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.coffeeDeep : Colors.white,
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
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: farm.statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  farm.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: farm.statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  farm.statusText,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: farm.statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.landscape, size: 14, color: textColor.withOpacity(0.4)),
              const SizedBox(width: 4),
              Text(
                '${farm.hectares} ha',
                style: TextStyle(
                  fontSize: 12,
                  color: textColor.withOpacity(0.6),
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.view_module, size: 14, color: textColor.withOpacity(0.4)),
              const SizedBox(width: 4),
              Text(
                '${farmLots.length} lotes',
                style: TextStyle(
                  fontSize: 12,
                  color: textColor.withOpacity(0.6),
                ),
              ),
              if (farm.mainVariety != null) ...[
                const SizedBox(width: 16),
                Icon(Icons.emoji_nature, size: 14, color: textColor.withOpacity(0.4)),
                const SizedBox(width: 4),
                Text(
                  farm.mainVariety!,
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor.withOpacity(0.6),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on, size: 12, color: textColor.withOpacity(0.3)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  farm.location,
                  style: TextStyle(
                    fontSize: 11,
                    color: textColor.withOpacity(0.5),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLotCard(Map<String, dynamic> lot, bool isDark, Color textColor) {
    final statusColor = lot['status'] == 'Saludable'
        ? Colors.green
        : lot['status'] == 'Atención'
        ? Colors.orange
        : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.coffeeDeep : Colors.white,
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
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  lot['name'],
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  lot['status'],
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.emoji_nature, size: 14, color: textColor.withOpacity(0.4)),
              const SizedBox(width: 4),
              Text(
                lot['variety'],
                style: TextStyle(
                  fontSize: 12,
                  color: textColor.withOpacity(0.6),
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.landscape, size: 14, color: textColor.withOpacity(0.4)),
              const SizedBox(width: 4),
              Text(
                '${lot['area']} ha',
                style: TextStyle(
                  fontSize: 12,
                  color: textColor.withOpacity(0.6),
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.eco, size: 14, color: textColor.withOpacity(0.4)),
              const SizedBox(width: 4),
              Text(
                '${lot['production']} kg',
                style: TextStyle(
                  fontSize: 12,
                  color: textColor.withOpacity(0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.agriculture, size: 12, color: textColor.withOpacity(0.3)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  lot['farmName'],
                  style: TextStyle(
                    fontSize: 11,
                    color: textColor.withOpacity(0.5),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}