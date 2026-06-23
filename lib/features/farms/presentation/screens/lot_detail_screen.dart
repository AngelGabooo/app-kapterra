import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/providers/farm_provider.dart';
import 'package:kaabcafe/features/farms/data/models/lot_model.dart';
import 'package:kaabcafe/features/farms/data/models/farm_details_model.dart';
import 'package:kaabcafe/features/farms/data/models/lot_cost_model.dart';
import 'package:kaabcafe/features/farms/data/models/farm_activity_model.dart';

class LotDetailScreen extends StatefulWidget {
  final LotModel lot;
  final FarmDetailsModel farm;

  const LotDetailScreen({
    super.key,
    required this.lot,
    required this.farm,
  });

  @override
  State<LotDetailScreen> createState() => _LotDetailScreenState();
}

class _LotDetailScreenState extends State<LotDetailScreen> {
  int _currentIndex = 1;

  // ✅ CORREGIDO: Usando LotCostModel correctamente
  final List<LotCostModel> _costs = [
    LotCostModel(category: 'Mano de obra', amount: 5800, icon: Icons.people),
    LotCostModel(category: 'Insumos', amount: 4200, icon: Icons.agriculture),
    LotCostModel(category: 'Transporte', amount: 2500, icon: Icons.local_shipping),
  ];

  // ✅ CORREGIDO: Usando FarmActivityModel correctamente
  final List<FarmActivityModel> _activities = [
    FarmActivityModel(
      id: '1',
      title: 'Fertilización',
      description: 'Aplicación de fertilizante orgánico - Responsable: Juan Pérez',
      date: DateTime.now().subtract(const Duration(days: 2)),
      icon: Icons.agriculture,
    ),
    FarmActivityModel(
      id: '2',
      title: 'Poda',
      description: 'Poda de mantenimiento - Responsable: Pedro López',
      date: DateTime.now().subtract(const Duration(days: 7)),
      icon: Icons.content_cut,
    ),
    FarmActivityModel(
      id: '3',
      title: 'Aplicación fitosanitaria',
      description: 'Control preventivo de plagas - Responsable: María Gómez',
      date: DateTime.now().subtract(const Duration(days: 12)),
      icon: Icons.bug_report,
    ),
    FarmActivityModel(
      id: '4',
      title: 'Cosecha',
      description: 'Primera cosecha del año - 250 kg - Responsable: Equipo de cosecha',
      date: DateTime.now().subtract(const Duration(days: 20)),
      icon: Icons.agriculture,
    ),
  ];

  final List<Map<String, dynamic>> _quickActions = [
    {'title': 'Registrar actividad', 'icon': Icons.add_task},
    {'title': 'Registrar costo', 'icon': Icons.attach_money},
    {'title': 'Subir evidencia', 'icon': Icons.camera_alt},
    {'title': 'Consultar IA', 'icon': Icons.psychology},
    {'title': 'Ver indicadores', 'icon': Icons.analytics},
    {'title': 'Ver trazabilidad', 'icon': Icons.qr_code},
  ];

  int get _healthScore {
    switch (widget.lot.status) {
      case LotStatus.healthy:
        return 94;
      case LotStatus.attention:
        return 65;
      case LotStatus.risk:
        return 35;
    }
  }

  double get _totalCost {
    return _costs.fold(0.0, (sum, cost) => sum + cost.amount);
  }

  double get _averageProduction {
    return 450.0; // Valor de ejemplo
  }

  double get _yieldPerHectare {
    if (widget.lot.area == 0) return 0;
    return _averageProduction / widget.lot.area;
  }

  void _onQuickActionTap(String action) {
    switch (action) {
      case 'Registrar actividad':
        context.push(
          RouteNames.registerActivity,
          extra: {'lot': widget.lot, 'farm': widget.farm},
        );
        break;
      case 'Registrar costo':
        context.push(RouteNames.costs, extra: {'lot': widget.lot, 'farm': widget.farm});
        break;
      case 'Subir evidencia':
        _showUploadEvidenceDialog();
        break;
      case 'Consultar IA':
        _showAIAnalysisDialog();
        break;
      case 'Ver indicadores':
        _showIndicatorsDialog();
        break;
      case 'Ver trazabilidad':
        context.push(
          RouteNames.lotHistory,
          extra: {'lot': widget.lot, 'farm': widget.farm},
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Acción: $action'), backgroundColor: AppTheme.primaryGreen),
        );
    }
  }

  void _showUploadEvidenceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Subir evidencia'),
        content: const Text('Selecciona el tipo de evidencia que deseas subir:'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('📸 Cámara abierta'), backgroundColor: AppTheme.primaryGreen),
              );
            },
            icon: const Icon(Icons.camera_alt),
            label: const Text('Tomar foto'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('📁 Galería abierta'), backgroundColor: AppTheme.primaryGreen),
              );
            },
            icon: const Icon(Icons.image),
            label: const Text('Subir imagen'),
          ),
        ],
      ),
    );
  }

  void _showAIAnalysisDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Icon(Icons.psychology, color: AppTheme.primaryGreen),
            const SizedBox(width: 8),
            const Text('Análisis IA'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Recomendaciones para tu lote:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: AppTheme.primaryGreen, size: 18),
                  SizedBox(width: 8),
                  Expanded(child: Text('El lote está en buen estado. Continuar con el plan actual.')),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: const Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange, size: 18),
                  SizedBox(width: 8),
                  Expanded(child: Text('Se recomienda fertilización en los próximos 15 días.')),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
        ],
      ),
    );
  }

  void _showIndicatorsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Indicadores del lote'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIndicatorRow('Producción estimada', '${widget.lot.estimatedProduction.toStringAsFixed(0)} kg', Icons.eco),
            _buildIndicatorRow('Rendimiento', '${_yieldPerHectare.toStringAsFixed(0)} kg/ha', Icons.agriculture),
            _buildIndicatorRow('Costos totales', '\$${_totalCost.toStringAsFixed(0)} MXN', Icons.attach_money),
            _buildIndicatorRow('Árboles', '${widget.lot.treesCount}', Icons.nature),
            _buildIndicatorRow('Superficie', '${widget.lot.area} ha', Icons.landscape),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
        ],
      ),
    );
  }

  Widget _buildIndicatorRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryGreen),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCoffee)),
        ],
      ),
    );
  }

  void _onViewCostDetails() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Detalle de Costos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.darkCoffee)),
            const SizedBox(height: 16),
            ..._costs.map((cost) => ListTile(
              leading: Icon(cost.icon, color: AppTheme.primaryGreen),
              title: Text(cost.category),
              trailing: Text('\$${cost.amount.toStringAsFixed(0)} MXN', style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.darkCoffee)),
            )),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('\$${_totalCost.toStringAsFixed(0)} MXN', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onViewPassport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Pasaporte Digital'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Información del lote:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('• Nombre: ${widget.lot.name}'),
            Text('• Variedad: ${widget.lot.variety}'),
            Text('• Área: ${widget.lot.area} ha'),
            Text('• Estado: ${widget.lot.statusText}'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppTheme.primaryGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: const Row(
                children: [
                  Icon(Icons.verified, color: AppTheme.primaryGreen),
                  SizedBox(width: 8),
                  Expanded(child: Text('Certificado por trazabilidad digital', style: TextStyle(fontWeight: FontWeight.w500))),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pasaporte descargado'), backgroundColor: AppTheme.primaryGreen),
              );
            },
            icon: const Icon(Icons.download),
            label: const Text('Descargar'),
          ),
        ],
      ),
    );
  }

  void _onShareQR() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('📤 Compartiendo código QR...'), backgroundColor: AppTheme.primaryGreen),
    );
  }

  void _onDownloadQR() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('📥 Descargando código QR...'), backgroundColor: AppTheme.primaryGreen),
    );
  }

  void _onViewPublicQR() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Vista Pública'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.qr_code, size: 100, color: AppTheme.darkCoffee.withOpacity(0.3)),
                    const SizedBox(height: 8),
                    Text('${widget.lot.name}', style: TextStyle(fontSize: 12, color: AppTheme.darkCoffee.withOpacity(0.5))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Escanea el código QR para ver la información pública del lote', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
        ],
      ),
    );
  }

  void _goToEditLot() {
    context.push(RouteNames.editLot, extra: {'lot': widget.lot, 'farm': widget.farm});
  }

  void _goToLotHistory() {
    context.push(RouteNames.lotHistory, extra: {'lot': widget.lot, 'farm': widget.farm});
  }

  void _showArchiveDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Archivar Lote'),
        content: const Text('¿Estás seguro de que deseas archivar este lote? Podrás restaurarlo más tarde.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('📦 Lote archivado'), backgroundColor: Colors.orange),
              );
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Archivar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Column(
        children: [
          // HEADER
          Container(
            height: 220,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppTheme.primaryGreen, AppTheme.secondaryGreen],
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(Icons.agriculture, size: 60, color: Colors.white.withOpacity(0.2)),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 8,
                  right: 8,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: _goToLotHistory,
                        icon: const Icon(Icons.history, color: Colors.white),
                      ),
                      IconButton(
                        onPressed: _goToEditLot,
                        icon: const Icon(Icons.edit, color: Colors.white),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        onSelected: (value) {
                          if (value == 'archive') {
                            _showArchiveDialog();
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'share', child: Text('Compartir lote')),
                          const PopupMenuItem(value: 'duplicate', child: Text('Duplicar lote')),
                          const PopupMenuItem(value: 'archive', child: Text('Archivar lote')),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 50,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.lot.name,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.farm.name,
                        style: const TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          _buildChip(Icons.emoji_nature, widget.lot.variety),
                          _buildChip(Icons.landscape, '${widget.lot.area} ha'),
                          _buildChip(Icons.nature, '${widget.lot.treesCount} árboles'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // CONTENIDO
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Estado
                  _buildStatusCard(colorScheme),
                  const SizedBox(height: 16),

                  // KPIs
                  _buildKPIs(),
                  const SizedBox(height: 16),

                  // Actividades
                  _buildActivitiesSection(colorScheme),
                  const SizedBox(height: 16),

                  // Costos
                  _buildCostsSection(colorScheme),
                  const SizedBox(height: 16),

                  // Alertas
                  _buildAlertsSection(colorScheme),
                  const SizedBox(height: 16),

                  // QR
                  _buildQRCard(),
                  const SizedBox(height: 16),

                  // Acciones rápidas
                  _buildQuickActions(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          switch (index) {
            case 0:
              context.go(RouteNames.dashboard);
              break;
            case 1:
              context.go(RouteNames.myFarms);
              break;
            case 2:
              context.go(RouteNames.dashboard);
              break;
            case 3:
              context.go(RouteNames.dashboard);
              break;
            case 4:
              context.go(RouteNames.profile);
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: colorScheme.surface,
        selectedItemColor: AppTheme.primaryGreen,
        unselectedItemColor: colorScheme.onSurface.withOpacity(0.5),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.landscape), label: 'Fincas'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Indicadores'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Marketplace'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _buildChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white70),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildStatusCard(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.lot.statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.lot.statusColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: widget.lot.statusColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                widget.lot.statusText,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: widget.lot.statusColor,
                ),
              ),
              const Spacer(),
              Text(
                '$_healthScore/100',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.lot.status == LotStatus.healthy
                ? 'El lote presenta condiciones óptimas de producción.'
                : widget.lot.status == LotStatus.attention
                ? 'Se recomienda atención en este lote.'
                : '¡Alerta! Este lote requiere intervención inmediata.',
            style: TextStyle(fontSize: 13, color: colorScheme.onSurface.withOpacity(0.7)),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: _healthScore / 100,
            backgroundColor: Colors.grey.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(widget.lot.statusColor),
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildKPIs() {
    return Row(
      children: [
        Expanded(
          child: _kpiCard(
            title: 'Producción',
            value: '${widget.lot.estimatedProduction.toStringAsFixed(0)} kg',
            icon: Icons.eco,
            color: AppTheme.primaryGreen,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _kpiCard(
            title: 'Costos',
            value: '\$${_totalCost.toStringAsFixed(0)}',
            icon: Icons.attach_money,
            color: AppTheme.goldCoffee,
          ),
        ),
      ],
    );
  }

  Widget _kpiCard({required String title, required String value, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 11, color: AppTheme.darkCoffee, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.darkCoffee)),
        ],
      ),
    );
  }

  Widget _buildActivitiesSection(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Actividades', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
          ),
          child: Column(
            children: _activities.map((activity) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(activity.icon, size: 16, color: AppTheme.primaryGreen),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity.title,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.darkCoffee),
                          ),
                          Text(
                            activity.description,
                            style: TextStyle(fontSize: 12, color: AppTheme.darkCoffee.withOpacity(0.6)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCostsSection(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Costos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
          ),
          child: Column(
            children: [
              ..._costs.map((cost) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(cost.icon, size: 14, color: AppTheme.primaryGreen),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          cost.category,
                          style: const TextStyle(fontSize: 13, color: AppTheme.darkCoffee),
                        ),
                      ),
                      Text(
                        '\$${cost.amount.toStringAsFixed(0)} MXN',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.darkCoffee),
                      ),
                    ],
                  ),
                );
              }).toList(),
              const Divider(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCoffee)),
                  Text(
                    '\$${_totalCost.toStringAsFixed(0)} MXN',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAlertsSection(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning, color: Colors.orange, size: 18),
              const SizedBox(width: 8),
              Text('Alertas', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
            ],
          ),
          const SizedBox(height: 8),
          const Text('⚠ Riesgo leve de roya detectado', style: TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          const Text('💡 Se recomienda fertilización en 15 días', style: TextStyle(fontSize: 12)),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _showAIAnalysisDialog,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Ver recomendaciones', style: TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
      ),
      child: Column(
        children: [
          const Text('Código QR', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.darkCoffee)),
          const SizedBox(height: 12),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Icon(Icons.qr_code, size: 50, color: AppTheme.darkCoffee.withOpacity(0.5)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _onShareQR,
                  child: const Text('Compartir'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: _onDownloadQR,
                  child: const Text('Descargar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Acciones rápidas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.darkCoffee)),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0,
          ),
          itemCount: _quickActions.length,
          itemBuilder: (context, index) {
            final action = _quickActions[index];
            return GestureDetector(
              onTap: () => _onQuickActionTap(action['title']),
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
                    ),
                    child: Icon(action['icon'], size: 24, color: AppTheme.primaryGreen),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    action['title'],
                    style: TextStyle(fontSize: 10, color: AppTheme.darkCoffee.withOpacity(0.7)),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}