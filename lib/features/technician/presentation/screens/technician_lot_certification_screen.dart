// lib/features/technician/presentation/screens/technician_lot_certification_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/aurora_background.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/certification/certification_info_card.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/certification/certification_kpi_card.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/certification/certification_type_card.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/certification/certification_checklist.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/certification/certification_documents.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/certification/certification_evaluation.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/certification/certification_signature.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/certification/certification_preview.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/certification/certification_validity.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/certification/certificate_pdf_generator.dart';
import 'package:share_plus/share_plus.dart';

class TechnicianLotCertificationScreen extends StatefulWidget {
  const TechnicianLotCertificationScreen({
    super.key,
    this.lotName,
    this.farmName,
    this.producerName,
    this.location,
    this.variety,
  });

  final String? lotName;
  final String? farmName;
  final String? producerName;
  final String? location;
  final String? variety;

  @override
  State<TechnicianLotCertificationScreen> createState() =>
      _TechnicianLotCertificationScreenState();
}

class _TechnicianLotCertificationScreenState
    extends State<TechnicianLotCertificationScreen> {
  int _currentIndex = 3;
  bool _isGeneratingPDF = false;

  // Estados
  int _selectedCertificationType = 0;
  int _evaluationResult = 0;
  final TextEditingController _observationsController = TextEditingController();

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

  final List<Map<String, dynamic>> _checklistItems = [
    {'label': 'Historial de actividades completo', 'checked': true},
    {'label': 'Evidencias fotográficas registradas', 'checked': true},
    {'label': 'Costos documentados', 'checked': true},
    {'label': 'Trazabilidad activa', 'checked': true},
    {'label': 'QR generado', 'checked': true},
    {'label': 'Diagnóstico técnico aprobado', 'checked': true},
    {'label': 'Documentos pendientes', 'checked': false},
  ];

  final List<Map<String, dynamic>> _corrections = [
    {'label': 'Completar evidencia fotográfica.', 'checked': false},
    {'label': 'Actualizar historial de actividades.', 'checked': false},
    {'label': 'Registrar análisis de humedad.', 'checked': false},
    {'label': 'Programar nueva inspección.', 'checked': false},
  ];

  final List<Map<String, dynamic>> _documents = [
    {'label': 'Reporte técnico', 'status': 'Subido', 'icon': Icons.description},
    {'label': 'Evidencias de campo', 'status': 'Pendiente', 'icon': Icons.photo_library},
    {'label': 'Resultados de laboratorio', 'status': 'Subido', 'icon': Icons.science},
    {'label': 'Constancia de productor', 'status': 'Pendiente', 'icon': Icons.assignment},
    {'label': 'Certificados previos', 'status': 'Subido', 'icon': Icons.verified},
  ];

  // ── Función para generar y abrir certificado ──────────────────
  Future<void> _generateAndOpenCertificate() async {
    setState(() {
      _isGeneratingPDF = true;
    });

    try {
      final certificationType = _certificationTypes[_selectedCertificationType]['label'] as String;
      final evaluationLabel = _evaluationOptions[_evaluationResult]['label'] as String;

      // Generar el PDF
      final file = await CertificatePDFGenerator.generateCertificate(
        lotName: widget.lotName ?? 'Lote Norte',
        farmName: widget.farmName ?? 'El Mirador',
        producerName: widget.producerName ?? 'Juan Pérez',
        location: widget.location ?? 'Motozintla, Chiapas',
        variety: widget.variety ?? 'Bourbon',
        certificationType: certificationType,
        evaluationResult: evaluationLabel,
        date: '15 junio 2026',
        expiryDate: '15 junio 2027',
        certificateCode: 'KAAB-2026-001',
      );

      if (mounted) {
        // ✅ Abrir y compartir el PDF
        try {
          await openAndShareCertificatePDF(file);
          // Si llegamos aquí, se abrió o compartió correctamente
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('✅ Certificado generado correctamente'),
              backgroundColor: AppTheme.primaryGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          );
        } catch (e) {
          // Si falla, mostrar diálogo con la ruta
          _showFileInfoDialog(file);
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGeneratingPDF = false;
        });
      }
    }
  }

  void _showFileInfoDialog(File file) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: isDark ? AppTheme.coffeeDeep : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.picture_as_pdf,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                '📄 Certificado generado',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppTheme.darkCoffee,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'El certificado se ha guardado en:',
                style: TextStyle(
                  fontSize: 14,
                  color: (isDark ? Colors.white : AppTheme.darkCoffee).withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : AppTheme.darkCoffee.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  file.path,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white : AppTheme.darkCoffee,
                  ),
                  textAlign: TextAlign.center,
                ),
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
                          color: (isDark ? Colors.white : AppTheme.darkCoffee).withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        'Cerrar',
                        style: TextStyle(
                          color: isDark ? Colors.white : AppTheme.darkCoffee,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        try {
                          await Share.shareXFiles(
                            [XFile(file.path)],
                            text: '📄 Certificado de Lote - Kaab Terra',
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('❌ No se pudo compartir el archivo'),
                              backgroundColor: AppTheme.berryRed,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          );
                        }
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
                      child: const Text('Compartir'),
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

  // ✅ Diálogo de error
  void _showErrorDialog(String error) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: isDark ? AppTheme.coffeeDeep : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                '❌ Error al generar el certificado',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppTheme.darkCoffee,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error,
                style: TextStyle(
                  fontSize: 14,
                  color: (isDark ? Colors.white : AppTheme.darkCoffee).withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('Entendido'),
                ),
              ),
            ],
          ),
        ),
      ),
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
                    CertificationInfoCard(
                      isDark: isDark,
                      lotName: widget.lotName ?? 'Lote Norte',
                      farmName: widget.farmName ?? 'El Mirador',
                      producerName: widget.producerName ?? 'Juan Pérez',
                      location: widget.location ?? 'Motozintla, Chiapas',
                      variety: widget.variety ?? 'Bourbon',
                    ),
                    const SizedBox(height: 20),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildKPIs(isDark),
                    const SizedBox(height: 20),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildSectionTitle('Tipo de certificación', isDark),
                    const SizedBox(height: 12),
                    _buildCertificationTypes(isDark),
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 20),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    CertificationDocuments(
                      isDark: isDark,
                      documents: _documents,
                      onUpload: (index) {},
                      onView: (index) {},
                      onDownload: (index) {},
                    ),
                    const SizedBox(height: 20),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildSectionTitle('Evaluación del técnico', isDark),
                    const SizedBox(height: 12),
                    CertificationEvaluation(
                      isDark: isDark,
                      value: _evaluationResult,
                      onChanged: (value) {
                        setState(() => _evaluationResult = value);
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
                    _buildObservationsField(isDark, textColor),
                    const SizedBox(height: 20),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildCorrections(isDark),
                    const SizedBox(height: 20),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    CertificationSignature(
                      isDark: isDark,
                      onSignTechnician: () {},
                      onSignProducer: () {},
                    ),
                    const SizedBox(height: 20),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    CertificationPreview(
                      isDark: isDark,
                      lotName: widget.lotName ?? 'Lote Norte',
                      producerName: widget.producerName ?? 'Juan Pérez',
                      certificationType: _certificationTypes[_selectedCertificationType]['label'] as String,
                    ),
                    const SizedBox(height: 20),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    CertificationValidity(isDark: isDark),
                    const SizedBox(height: 20),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildMarketplaceImpact(isDark),
                    const SizedBox(height: 20),
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
                    _buildMainButtons(),
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

  Widget _buildKPIs(bool isDark) {
    final kpis = [
      {'label': '📊 Diagnóstico', 'value': '82/100', 'color': AppTheme.primaryGreen},
      {'label': '🔎 Trazabilidad', 'value': '96%', 'color': AppTheme.goldCoffee},
      {'label': '☕ Calidad', 'value': '88/100', 'color': AppTheme.secondaryGreen},
      {'label': '🌱 Sostenibilidad', 'value': '91%', 'color': AppTheme.primaryGreen},
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
        boxShadow: const [],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Observaciones técnicas',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _observationsController,
            maxLines: 4,
            style: TextStyle(color: textColor, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Escribe las observaciones técnicas de la certificación...',
              hintStyle: TextStyle(color: textColor.withOpacity(0.4), fontSize: 14),
              border: InputBorder.none,
              counterText: '',
            ),
            maxLength: 500,
          ),
        ],
      ),
    );
  }

  Widget _buildCorrections(bool isDark) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

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
        boxShadow: const [],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Correcciones solicitadas',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),
          ..._corrections.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _corrections[index]['checked'] =
                    !_corrections[index]['checked'];
                  });
                },
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
                          color: textColor,
                          decoration: item['checked']
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationColor: textColor.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
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
        boxShadow: const [],
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

  Widget _buildQuickActions(bool isDark) {
    final actions = [
      {'icon': Icons.description, 'label': 'Ver diagnóstico', 'color': AppTheme.primaryGreen},
      {'icon': Icons.qr_code, 'label': 'Ver pasaporte', 'color': AppTheme.goldCoffee},
      {'icon': Icons.qr_code_scanner, 'label': 'Ver QR', 'color': AppTheme.alertOrange},
      {'icon': Icons.photo_library, 'label': 'Ver evidencias', 'color': AppTheme.secondaryGreen},
      {'icon': Icons.share, 'label': 'Compartir certificado', 'color': AppTheme.berryRed},
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
        boxShadow: const [],
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
              color: isDark ? Colors.white : AppTheme.darkCoffee,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: actions.map((action) {
              final color = action['color'] as Color;
              return GestureDetector(
                onTap: () {},
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
                      Icon(
                        action['icon'] as IconData,
                        size: 16,
                        color: color,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        action['label'] as String,
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

  Widget _buildMainButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              _showConfirmDialog();
            },
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
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.alertOrange,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              side: BorderSide(
                color: AppTheme.alertOrange.withOpacity(0.3),
                width: 1.5,
              ),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.edit_outlined, size: 16),
                SizedBox(width: 8),
                Text(
                  'Solicitar correcciones',
                  style: TextStyle(
                    fontSize: 14,
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

  void _showConfirmDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: isDark ? AppTheme.coffeeDeep : Colors.white,
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
                  Icons.verified_outlined,
                  size: 48,
                  color: AppTheme.primaryGreen,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '¿Emitir certificación?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppTheme.darkCoffee,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'La certificación quedará asociada al lote, al Pasaporte Digital y a la Vista Pública para compradores.',
                style: TextStyle(
                  fontSize: 14,
                  color: (isDark ? Colors.white : AppTheme.darkCoffee).withOpacity(0.6),
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
                          color: (isDark ? Colors.white : AppTheme.darkCoffee).withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          color: isDark ? Colors.white : AppTheme.darkCoffee,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showSuccessDialog();
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
                      child: const Text('Emitir'),
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

  void _showSuccessDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: isDark ? AppTheme.coffeeDeep : Colors.white,
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
                child: const Icon(
                  Icons.check_circle_outline,
                  size: 48,
                  color: AppTheme.primaryGreen,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '✅ Certificación emitida correctamente',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppTheme.darkCoffee,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'El lote ahora cuenta con una certificación verificable dentro de Kaab Terra.',
                style: TextStyle(
                  fontSize: 14,
                  color: (isDark ? Colors.white : AppTheme.darkCoffee).withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _isGeneratingPDF
                        ? Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                        : ElevatedButton.icon(
                      onPressed: _generateAndOpenCertificate,
                      icon: const Icon(Icons.visibility, size: 18),
                      label: const Text(
                        'Ver certificado',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.go(RouteNames.technicianDashboard);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isDark ? Colors.white : AppTheme.darkCoffee,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: (isDark ? Colors.white : AppTheme.darkCoffee).withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        'Volver al seguimiento',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : AppTheme.darkCoffee,
                        ),
                      ),
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
          // context.go(RouteNames.technicianProducers);
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