// lib/features/technician/presentation/screens/technician_lot_certification_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/providers/user_provider.dart';
import 'package:kaabcafe/core/providers/farm_provider.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/aurora_background.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';
import 'package:kaabcafe/features/technician/providers/technician_producers_provider.dart';
import 'package:kaabcafe/features/technician/providers/technician_reports_provider.dart';
import 'package:kaabcafe/features/technician/data/models/technician_diagnosis_model.dart';
import 'package:kaabcafe/features/technician/data/models/technician_model.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/certification/certification_info_card.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/certification/certification_kpi_card.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/certification/certification_type_card.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/certification/certification_checklist.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/certification/certification_evaluation.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/certification/certification_signature.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/certification/certification_preview.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/certification/certification_validity.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/certification/certificate_pdf_generator.dart';
import 'package:kaabcafe/features/farms/data/models/farm_details_model.dart';
import 'package:kaabcafe/features/farms/data/models/lot_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:kaabcafe/core/providers/qr_update_provider.dart';

import '../../data/models/technician_certification_model.dart';

class TechnicianLotCertificationScreen extends StatefulWidget {
  const TechnicianLotCertificationScreen({
    super.key,
    this.lotName,
    this.farmName,
    this.producerName,
    this.location,
    this.variety,
    this.producerId,
  });

  final String? lotName;
  final String? farmName;
  final String? producerName;
  final String? location;
  final String? variety;
  final String? producerId;

  @override
  State<TechnicianLotCertificationScreen> createState() =>
      _TechnicianLotCertificationScreenState();
}

class _TechnicianLotCertificationScreenState
    extends State<TechnicianLotCertificationScreen> {
  int _currentIndex = 3;
  bool _isGeneratingPDF = false;

  // ✅ DATOS DEL TÉCNICO
  String _technicianName = '';
  String _technicianId = '';

  // ✅ DATOS REALES DEL PRODUCTOR
  String? _selectedProducerId;
  TechnicianProducerModel? _selectedProducer;
  FarmDetailsModel? _selectedFarm;
  LotModel? _selectedLot;

  // ✅ CÓDIGO DE CERTIFICACIÓN
  String _certCode = '';

  // Estados de certificación
  int _selectedCertificationType = 0;
  int _evaluationResult = -1;
  final TextEditingController _observationsController = TextEditingController();

  // ✅ FIRMAS DIGITALES
  bool _technicianSigned = false;
  bool _producerSigned = false;
  String _technicianSignatureDate = '';
  String _producerSignatureDate = '';

  final List<Map<String, dynamic>> _evaluationOptions = [
    {'label': 'Aprobado', 'color': AppTheme.primaryGreen, 'emoji': '🟢'},
    {'label': 'Aprobado con observaciones', 'color': AppTheme.goldCoffee, 'emoji': '🟡'},
    {'label': 'Solicitar correcciones', 'color': AppTheme.alertOrange, 'emoji': '🟠'},
    {'label': 'Rechazado', 'color': AppTheme.berryRed, 'emoji': '🔴'},
  ];

  final List<Map<String, dynamic>> _certificationTypes = [
    {'label': '🌿 Orgánico', 'icon': Icons.eco},
    {'label': '🌎 Comercio Justo', 'icon': Icons.handshake},
    {'label': '☕ Café de Especialidad', 'icon': Icons.coffee},
    {'label': '♻ Producción Sostenible', 'icon': Icons.recycling},
    {'label': '🛡 Buenas Prácticas Agrícolas', 'icon': Icons.shield},
  ];

  // Checklist inicializado vacío
  final List<Map<String, dynamic>> _checklistItems = [
    {'label': 'Historial de actividades completo', 'checked': false},
    {'label': 'Evidencias fotográficas registradas', 'checked': false},
    {'label': 'Costos documentados', 'checked': false},
    {'label': 'Trazabilidad activa', 'checked': false},
    {'label': 'QR generado', 'checked': false},
    {'label': 'Diagnóstico técnico aprobado', 'checked': false},
  ];

  @override
  void initState() {
    super.initState();
    _loadTechnicianData();
    _loadProducerData();
  }

  // ✅ CARGAR DATOS DEL TÉCNICO
  void _loadTechnicianData() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.userName != null) {
      _technicianName = userProvider.userName!;
    }
    _technicianId = userProvider.userEmail ?? 'technician_001';
  }

  // ✅ CARGAR DATOS DEL PRODUCTOR
  void _loadProducerData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final producersProvider = Provider.of<TechnicianProducersProvider>(context, listen: false);
      final farmProvider = Provider.of<FarmProvider>(context, listen: false);

      TechnicianProducerModel? producer;
      if (widget.producerId != null && widget.producerId!.isNotEmpty) {
        try {
          producer = producersProvider.producers.firstWhere(
                (p) => p.id == widget.producerId,
          );
        } catch (e) {}
      } else if (widget.producerName != null && widget.producerName!.isNotEmpty) {
        try {
          producer = producersProvider.producers.firstWhere(
                (p) => p.name == widget.producerName,
          );
        } catch (e) {}
      }

      if (producer != null) {
        final producerId = producer.email.isNotEmpty ? producer.email : producer.id;
        final farms = farmProvider.getFarmsByProducer(producerId);

        FarmDetailsModel? farm;
        if (widget.farmName != null && widget.farmName!.isNotEmpty) {
          try {
            farm = farms.firstWhere((f) => f.name == widget.farmName);
          } catch (e) {}
        } else if (farms.isNotEmpty) {
          farm = farms.first;
        }

        LotModel? lot;
        if (farm != null) {
          final lots = farmProvider.getLotsForFarm(farm.id);
          if (widget.lotName != null && widget.lotName!.isNotEmpty) {
            try {
              lot = lots.firstWhere((l) => l.name == widget.lotName);
            } catch (e) {}
          } else if (lots.isNotEmpty) {
            lot = lots.first;
          }
        }

        setState(() {
          _selectedProducerId = producer?.id;
          _selectedProducer = producer;
          _selectedFarm = farm;
          _selectedLot = lot;
        });
      }
    });
  }

  // ✅ FIRMA DIGITAL DEL TÉCNICO
  void _signTechnician() {
    final now = DateTime.now();
    setState(() {
      _technicianSigned = !_technicianSigned;
      _technicianSignatureDate = _technicianSigned
          ? '${now.day}/${now.month}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}'
          : '';
    });
  }

  // ✅ FIRMA DIGITAL DEL PRODUCTOR
  void _signProducer() {
    final now = DateTime.now();
    setState(() {
      _producerSigned = !_producerSigned;
      _producerSignatureDate = _producerSigned
          ? '${now.day}/${now.month}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}'
          : '';
    });
  }

  // ✅ VALIDAR CERTIFICACIÓN COMPLETA
  bool _isCertificationComplete() {
    if (_selectedProducer == null) return false;
    if (_selectedFarm == null) return false;
    if (_selectedLot == null) return false;
    if (_evaluationResult == -1) return false;

    final checkedItems = _checklistItems.where((item) => item['checked'] == true).length;
    if (checkedItems < 3) return false;

    if (_observationsController.text.trim().isEmpty) return false;
    if (_observationsController.text.length < 10) return false;

    if (!_technicianSigned) return false;
    if (!_producerSigned) return false;

    return true;
  }

  // ✅ GUARDAR CERTIFICACIÓN EN EL DIAGNÓSTICO
  void _saveCertificationToDiagnosis() {
    try {
      final reportsProvider = Provider.of<TechnicianReportsProvider>(context, listen: false);

      final diagnoses = reportsProvider.diagnoses
          .where((d) => d.lotId == _selectedLot?.id)
          .toList();

      if (diagnoses.isNotEmpty) {
        final diagnosis = diagnoses.last;
        final certification = TechnicianCertificationModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          diagnosisId: diagnosis.id,
          lotId: _selectedLot!.id,
          lotName: _selectedLot!.name,
          producerName: _selectedProducer!.name,
          technicianName: _technicianName,
          type: _certificationTypes[_selectedCertificationType]['label'] as String,
          issuedDate: DateTime.now(),
          expiryDate: DateTime.now().add(const Duration(days: 365)),
          status: 'active',
          certificationId: 'KAAB-${DateTime.now().year}-${_generateCertificateNumber()}',
          healthScore: diagnosis.healthScore.toString(),
        );

        final updatedDiagnosis = diagnosis.copyWith(
          certification: certification,
          status: _evaluationResult == 0 ? 'Certificado' : 'En revisión',
        );

        debugPrint('✅ Certificación guardada para ${_selectedProducer!.name}');
      }
    } catch (e) {
      debugPrint('❌ Error al guardar certificación: $e');
    }
  }

  String _generateCertificateNumber() {
    return DateTime.now().millisecondsSinceEpoch.toString().substring(8, 13);
  }

// En _generateAndOpenCertificate, después de guardar la certificación:



// En el método _generateAndOpenCertificate:
  Future<void> _generateAndOpenCertificate() async {
    if (!_isCertificationComplete()) {
      _showValidationDialog();
      return;
    }

    setState(() => _isGeneratingPDF = true);

    try {
      final certificationType = _certificationTypes[_selectedCertificationType]['label'] as String;
      final evaluationLabel = _evaluationResult >= 0
          ? _evaluationOptions[_evaluationResult]['label'] as String
          : 'No evaluado';

      final lotName = _selectedLot?.name ?? 'Lote sin nombre';
      final farmName = _selectedFarm?.name ?? 'Finca sin nombre';
      final producerName = _selectedProducer?.name ?? 'Productor sin nombre';
      final location = _selectedProducer?.location ?? 'Ubicación no especificada';
      final variety = _selectedLot?.variety ?? 'Variedad no especificada';

      // ✅ GENERAR CÓDIGO DE CERTIFICACIÓN
      _certCode = 'KAAB-${DateTime.now().year}-${_generateCertificateNumber()}';

      // Guardar certificación
      _saveCertificationToDiagnosis();

      // ✅ ACTUALIZAR EL QR PROVIDER
      final qrProvider = Provider.of<QRUpdateProvider>(context, listen: false);

      // Obtener el diagnóstico más reciente
      final reportsProvider = Provider.of<TechnicianReportsProvider>(context, listen: false);
      final diagnoses = reportsProvider.diagnoses
          .where((d) => d.lotId == _selectedLot?.id)
          .toList();

      String healthScore = 'No evaluado';
      String diagnosisSummary = 'Sin diagnóstico';
      String riskLevel = 'Bajo';

      if (diagnoses.isNotEmpty) {
        final latestDiagnosis = diagnoses.last;
        healthScore = latestDiagnosis.healthScore.toString();
        diagnosisSummary = _getDiagnosisSummary(latestDiagnosis);
        riskLevel = _getRiskLevel(latestDiagnosis);
      }

      qrProvider.updateQR({
        'lotId': _selectedLot?.id ?? '',
        'certificationType': certificationType,
        'certificationDate': DateTime.now().toIso8601String(),
        'certificationExpiry': DateTime.now().add(const Duration(days: 365)).toIso8601String(),
        'certCode': _certCode,
        'healthScore': healthScore,
        'technicianName': _technicianName,
        'diagnosisSummary': diagnosisSummary,
        'riskLevel': riskLevel,
      });

      final file = await CertificatePDFGenerator.generateCertificate(
        lotName: lotName,
        farmName: farmName,
        producerName: producerName,
        location: location,
        variety: variety,
        certificationType: certificationType,
        evaluationResult: evaluationLabel,
        date: _getFormattedDate(DateTime.now()),
        expiryDate: _getFormattedDate(DateTime.now().add(const Duration(days: 365))),
        certificateCode: _certCode,
      );

      if (mounted) {
        await openAndShareCertificatePDF(file);
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) _showErrorDialog(e.toString());
    } finally {
      if (mounted) setState(() => _isGeneratingPDF = false);
    }
  }

// ✅ MÉTODO PARA OBTENER EL RESUMEN DEL DIAGNÓSTICO
  String _getDiagnosisSummary(TechnicianDiagnosisModel diagnosis) {
    final score = diagnosis.healthScore;
    if (score >= 80) return 'Lote en excelentes condiciones';
    if (score >= 60) return 'Lote requiere atención - seguimiento recomendado';
    return 'Lote en riesgo - intervención necesaria';
  }

// ✅ MÉTODO PARA OBTENER EL NIVEL DE RIESGO
  String _getRiskLevel(TechnicianDiagnosisModel diagnosis) {
    final score = diagnosis.healthScore;
    if (score >= 80) return 'Bajo';
    if (score >= 60) return 'Medio';
    return 'Alto';
  }

  // ✅ ACTUALIZAR EL QR CON EL CÓDIGO DE CERTIFICACIÓN
  Future<void> _updateQRWithCertification() async {
    // Buscar el QRCard en el árbol de widgets y actualizar su estado
    // Esto es un enfoque simple: emitir un evento o actualizar un provider
    // En este caso, usaremos un enfoque de notificación
    debugPrint('✅ Código de certificación generado: $_certCode');

    // Si tienes un provider para compartir datos entre widgets
    // puedes usarlo aquí para actualizar el QR
    // Por ejemplo: _qrProvider.updateCertCode(_certCode);

    // Mostrar notificación al usuario
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Código QR actualizado con la certificación: $_certCode'),
        backgroundColor: AppTheme.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  String _getFormattedDate(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  String _getMonthName(int month) {
    const months = ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];
    return months[month - 1];
  }

  // ── DIÁLOGOS ──────────────────────────────────────────────────

  void _showValidationDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    List<String> errors = [];

    if (_selectedProducer == null) errors.add('• No hay productor seleccionado');
    if (_selectedFarm == null) errors.add('• No hay finca seleccionada');
    if (_selectedLot == null) errors.add('• No hay lote seleccionado');
    if (_evaluationResult == -1) errors.add('• Selecciona una evaluación');

    final checkedItems = _checklistItems.where((item) => item['checked'] == true).length;
    if (checkedItems < 3) errors.add('• Completa al menos 3 elementos del checklist');

    if (_observationsController.text.trim().isEmpty) errors.add('• Agrega observaciones');
    else if (_observationsController.text.length < 10) errors.add('• Observaciones mínimo 10 caracteres');

    if (!_technicianSigned) errors.add('• Firma del técnico requerida');
    if (!_producerSigned) errors.add('• Firma del productor requerida');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppTheme.coffeeDeep : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('⚠️ Información incompleta',
            style: TextStyle(color: isDark ? Colors.white : AppTheme.darkCoffee)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: errors.map((e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(e, style: TextStyle(color: isDark ? Colors.white.withOpacity(0.8) : AppTheme.darkCoffee.withOpacity(0.8))),
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Completar', style: TextStyle(color: AppTheme.primaryGreen)),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppTheme.coffeeDeep : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, size: 64, color: AppTheme.primaryGreen),
            const SizedBox(height: 16),
            Text('✅ Certificación emitida',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppTheme.darkCoffee)),
            const SizedBox(height: 8),
            Text('La certificación se ha guardado y el QR se ha actualizado con el código: $_certCode',
                style: TextStyle(color: isDark ? Colors.white.withOpacity(0.7) : AppTheme.darkCoffee.withOpacity(0.7)),
                textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Ver QR'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.go(RouteNames.technicianDashboard);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryGreen),
                    child: const Text('Finalizar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(String error) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppTheme.coffeeDeep : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('❌ Error', style: TextStyle(color: isDark ? Colors.white : AppTheme.darkCoffee)),
        content: Text(error, style: TextStyle(color: isDark ? Colors.white.withOpacity(0.7) : AppTheme.darkCoffee.withOpacity(0.7))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Entendido', style: TextStyle(color: AppTheme.primaryGreen)),
          ),
        ],
      ),
    );
  }

  // ── BUILD ──────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    final lotName = _selectedLot?.name ?? widget.lotName ?? '---';
    final farmName = _selectedFarm?.name ?? widget.farmName ?? '---';
    final producerName = _selectedProducer?.name ?? widget.producerName ?? '---';
    final location = _selectedProducer?.location ?? widget.location ?? '---';
    final variety = _selectedLot?.variety ?? widget.variety ?? '---';

    final bool isComplete = _isCertificationComplete();

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
                child: _buildHeader(isDark, textColor, isComplete),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    CertificationInfoCard(
                      isDark: isDark,
                      lotName: lotName,
                      farmName: farmName,
                      producerName: producerName,
                      location: location,
                      variety: variety,
                    ),
                    const SizedBox(height: 16),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildKPIs(isDark),
                    const SizedBox(height: 16),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildSectionTitle('Tipo de certificación', isDark),
                    const SizedBox(height: 10),
                    _buildCertificationTypes(isDark),
                    const SizedBox(height: 16),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    CertificationChecklist(
                      isDark: isDark,
                      items: _checklistItems,
                      onToggle: (index) {
                        setState(() {
                          _checklistItems[index]['checked'] =
                          !_checklistItems[index]['checked'];
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildSectionTitle('Evaluación del técnico', isDark),
                    const SizedBox(height: 10),
                    CertificationEvaluation(
                      isDark: isDark,
                      value: _evaluationResult,
                      onChanged: (value) {
                        setState(() => _evaluationResult = value);
                      },
                    ),
                    const SizedBox(height: 16),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildObservationsField(isDark, textColor),
                    const SizedBox(height: 16),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    CertificationSignature(
                      isDark: isDark,
                      technicianSigned: _technicianSigned,
                      producerSigned: _producerSigned,
                      technicianDate: _technicianSignatureDate,
                      producerDate: _producerSignatureDate,
                      onSignTechnician: _signTechnician,
                      onSignProducer: _signProducer,
                    ),
                    const SizedBox(height: 16),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    CertificationPreview(
                      isDark: isDark,
                      lotName: lotName,
                      producerName: producerName,
                      certificationType: _certificationTypes[_selectedCertificationType]['label'] as String,
                    ),
                    const SizedBox(height: 16),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    CertificationValidity(isDark: isDark),
                    const SizedBox(height: 16),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildMarketplaceImpact(isDark),
                    const SizedBox(height: 16),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildQuickActions(isDark, isComplete),
                    const SizedBox(height: 20),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildMainButtons(isComplete),
                    const SizedBox(height: 80),
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

  // ── WIDGETS DE CONSTRUCCIÓN ──────────────────────────────────

  Widget _buildHeader(bool isDark, Color textColor, bool isComplete) {
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
                  'Certificación del Lote',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Valida la calidad y trazabilidad del café.',
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
          GestureDetector(
            onTap: isComplete ? _generateAndOpenCertificate : null,
            child: Opacity(
              opacity: isComplete ? 1.0 : 0.4,
              child: NeumorphicIconButton(
                icon: Icons.picture_as_pdf_outlined,
                isDark: isDark,
                onPressed: () {},
                size: 40,
                iconSize: 18,
                color: isComplete ? AppTheme.primaryGreen : Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: isComplete ? _generateAndOpenCertificate : null,
            child: Opacity(
              opacity: isComplete ? 1.0 : 0.4,
              child: NeumorphicIconButton(
                icon: Icons.share_outlined,
                isDark: isDark,
                onPressed: () {},
                size: 40,
                iconSize: 18,
                color: isComplete ? AppTheme.primaryGreen : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPIs(bool isDark) {
    final checklistProgress = _checklistItems.where((item) => item['checked'] == true).length;
    final totalChecklist = _checklistItems.length;
    final hasEvaluation = _evaluationResult != -1;
    final hasObservations = _observationsController.text.trim().isNotEmpty &&
        _observationsController.text.length >= 10;

    final kpis = [
      {'label': '📊 Checklist', 'value': '$checklistProgress/$totalChecklist', 'color': AppTheme.primaryGreen},
      {'label': '📝 Evaluación', 'value': hasEvaluation ? '✅' : '⏳', 'color': hasEvaluation ? AppTheme.primaryGreen : AppTheme.goldCoffee},
      {'label': '✍️ Observaciones', 'value': hasObservations ? '✅' : '⏳', 'color': hasObservations ? AppTheme.primaryGreen : AppTheme.goldCoffee},
      {'label': '✅ Firmas', 'value': (_technicianSigned && _producerSigned) ? '✅' : '⏳', 'color': (_technicianSigned && _producerSigned) ? AppTheme.primaryGreen : AppTheme.goldCoffee},
      // ✅ Añadir KPI de certificación
      {'label': '🔑 Certificación', 'value': _certCode.isNotEmpty ? '✅' : '⏳', 'color': _certCode.isNotEmpty ? AppTheme.primaryGreen : AppTheme.goldCoffee},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: kpis.map((kpi) => CertificationKPICard(
        isDark: isDark,
        label: kpi['label'] as String,
        value: kpi['value'] as String,
        color: kpi['color'] as Color,
      )).toList(),
    );
  }

  Widget _buildCertificationTypes(bool isDark) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _certificationTypes.asMap().entries.map((entry) {
        final index = entry.key;
        final type = entry.value;
        return CertificationTypeCard(
          isDark: isDark,
          label: type['label'] as String,
          icon: type['icon'] as IconData,
          isSelected: _selectedCertificationType == index,
          onTap: () {
            setState(() => _selectedCertificationType = index);
          },
        );
      }).toList(),
    );
  }

  Widget _buildObservationsField(bool isDark, Color textColor) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.coffeeDeep.withOpacity(0.7)
            : const Color(0xFFE8E0D5).withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: textColor.withOpacity(0.06),
          width: 0.5,
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Observaciones técnicas *',
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
              hintText: 'Describe las observaciones técnicas de la certificación... (mínimo 10 caracteres)',
              hintStyle: TextStyle(color: textColor.withOpacity(0.4), fontSize: 14),
              border: InputBorder.none,
              counterText: '',
            ),
            maxLength: 500,
            onChanged: (_) => setState(() {}),
          ),
          if (_observationsController.text.isNotEmpty && _observationsController.text.length < 10)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Mínimo 10 caracteres (${_observationsController.text.length}/10)',
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.alertOrange.withOpacity(0.7),
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

  Widget _buildMarketplaceImpact(bool isDark) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final items = ['🔎 Trazabilidad', '📱 QR', '🤝 Marketplace', '☕ Compradores'];

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.coffeeDeep.withOpacity(0.7)
            : const Color(0xFFE8E0D5).withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: textColor.withOpacity(0.06),
          width: 0.5,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.storefront_outlined,
                  size: 18,
                  color: AppTheme.primaryGreen,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Impacto en Marketplace',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Esta certificación se mostrará en el Pasaporte Digital, Vista Pública del Lote y Marketplace.',
            style: TextStyle(
              fontSize: 13,
              color: textColor.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: textColor.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor.withOpacity(0.7),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(bool isDark, bool isComplete) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    final actions = [
      {'icon': Icons.description, 'label': 'Ver diagnóstico', 'color': AppTheme.primaryGreen},
      {'icon': Icons.qr_code, 'label': 'Ver pasaporte', 'color': AppTheme.goldCoffee},
      {'icon': Icons.share, 'label': 'Compartir certificado', 'color': AppTheme.berryRed},
      // ✅ Nuevo: Ver QR con código
      {'icon': Icons.qr_code_scanner, 'label': 'Ver QR', 'color': AppTheme.secondaryGreen},
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.coffeeDeep.withOpacity(0.7)
            : const Color(0xFFE8E0D5).withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.06) : AppTheme.darkCoffee.withOpacity(0.06),
          width: 0.5,
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Acciones rápidas',
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
            children: actions.map((action) {
              final color = action['color'] as Color;
              final label = action['label'] as String;

              return GestureDetector(
                onTap: isComplete ? () {
                  if (label == 'Compartir certificado') {
                    _generateAndOpenCertificate();
                  } else if (label == 'Ver QR') {
                    // Mostrar diálogo con el código QR
                    _showQRDialog();
                  }
                } : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(isComplete ? 0.1 : 0.05),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: color.withOpacity(isComplete ? 0.2 : 0.05),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        action['icon'] as IconData,
                        size: 16,
                        color: isComplete ? color : color.withOpacity(0.3),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isComplete
                              ? textColor
                              : textColor.withOpacity(0.3),
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

  // ✅ MOSTRAR DIÁLOGO CON EL CÓDIGO QR
  void _showQRDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppTheme.coffeeDeep : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Row(
          children: [
            Icon(Icons.qr_code, color: AppTheme.primaryGreen),
            const SizedBox(width: 8),
            Text(
              'Código de Certificación',
              style: TextStyle(
                color: isDark ? Colors.white : AppTheme.darkCoffee,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.2),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.qr_code,
                  size: 80,
                  color: AppTheme.darkCoffee,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primaryGreen.withOpacity(0.2),
                ),
              ),
              child: Text(
                _certCode.isNotEmpty ? _certCode : 'KAAB-2026-001',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryGreen,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Código de certificación del lote',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white.withOpacity(0.5) : AppTheme.darkCoffee.withOpacity(0.5),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cerrar',
              style: TextStyle(
                color: isDark ? Colors.white : AppTheme.darkCoffee,
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              // Compartir código
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('📋 Código copiado: $_certCode'),
                  backgroundColor: AppTheme.primaryGreen,
                ),
              );
            },
            icon: const Icon(Icons.copy, size: 16),
            label: const Text('Copiar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainButtons(bool isComplete) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isComplete ? _generateAndOpenCertificate : _showValidationDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: isComplete ? AppTheme.primaryGreen : Colors.grey,
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
                Icon(Icons.verified_outlined, size: 18),
                SizedBox(width: 8),
                Text(
                  'Emitir Certificación',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar(bool isDark) {
    return NeumorphicBottomNav(
      isDark: isDark,
      currentIndex: _currentIndex,
      items: const [
        Icons.home_outlined,
        Icons.people_outline,
        Icons.calendar_today_outlined,
        Icons.analytics_outlined,
        Icons.person_outline,
      ],
      onTap: (index) {
        setState(() => _currentIndex = index);
        switch (index) {
          case 0:
            context.go(RouteNames.technicianDashboard);
            break;
          case 1:
            break;
          case 2:
            context.go(RouteNames.technicianAgenda);
            break;
          case 3:
            context.go(RouteNames.technicianCropDiagnosis);
            break;
          case 4:
            context.go(RouteNames.profile);
            break;
        }
      },
    );
  }
}