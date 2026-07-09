// lib/features/technician/presentation/widgets/certification/certificate_pdf_generator.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class CertificatePDFGenerator {
  static Future<File> generateCertificate({
    required String lotName,
    required String farmName,
    required String producerName,
    required String location,
    required String variety,
    required String certificationType,
    required String evaluationResult,
    required String date,
    required String expiryDate,
    required String certificateCode,
  }) async {
    final pdf = pw.Document();

    // Cargar logo
    Uint8List? logoImage;
    try {
      final data = await rootBundle.load('assets/img/logo_kaab_terra.png');
      logoImage = data.buffer.asUint8List();
    } catch (_) {}

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          PdfColor _opacity(PdfColor color, double opacity) {
            return PdfColor(
              color.red,
              color.green,
              color.blue,
              opacity,
            );
          }

          return pw.Container(
            padding: const pw.EdgeInsets.all(40),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                color: PdfColors.green900,
                width: 2,
              ),
              borderRadius: pw.BorderRadius.circular(10),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                if (logoImage != null)
                  pw.Image(
                    pw.MemoryImage(logoImage),
                    width: 80,
                    height: 80,
                  ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'KAAB TERRA',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.green900,
                    letterSpacing: 4,
                  ),
                ),
                pw.Text(
                  'AGRICULTURA CONECTADA',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.green900,
                    letterSpacing: 2,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  decoration: pw.BoxDecoration(
                    color: _opacity(PdfColors.green900, 0.1),
                    borderRadius: pw.BorderRadius.circular(5),
                  ),
                  child: pw.Text(
                    'CERTIFICADO DE LOTE',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.green900,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                pw.SizedBox(height: 30),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('☕ Lote', lotName),
                          pw.SizedBox(height: 6),
                          _buildInfoRow('🌱 Finca', farmName),
                          pw.SizedBox(height: 6),
                          _buildInfoRow('👨‍🌾 Productor', producerName),
                          pw.SizedBox(height: 6),
                          _buildInfoRow('📍 Ubicación', location),
                          pw.SizedBox(height: 6),
                          _buildInfoRow('🌿 Variedad', variety),
                        ],
                      ),
                    ),
                    pw.SizedBox(width: 30),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('🏷 Tipo', certificationType),
                          pw.SizedBox(height: 6),
                          _buildInfoRow('📊 Evaluación', evaluationResult),
                          pw.SizedBox(height: 6),
                          _buildInfoRow('📅 Emisión', date),
                          pw.SizedBox(height: 6),
                          _buildInfoRow('⏳ Vigencia', expiryDate),
                          pw.SizedBox(height: 6),
                          _buildInfoRow('🔑 Código', certificateCode),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 30),
                pw.Divider(
                  color: _opacity(PdfColors.green900, 0.3),
                  thickness: 1,
                ),
                pw.SizedBox(height: 20),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  children: [
                    pw.Column(
                      children: [
                        pw.Container(
                          width: 150,
                          height: 1,
                          color: PdfColors.green900,
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          'Firma del Técnico',
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: _opacity(PdfColors.brown, 0.6),
                          ),
                        ),
                      ],
                    ),
                    pw.Column(
                      children: [
                        pw.Container(
                          width: 150,
                          height: 1,
                          color: PdfColors.green900,
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          'Firma del Productor',
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: _opacity(PdfColors.brown, 0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    color: _opacity(PdfColors.orange, 0.1),
                    borderRadius: pw.BorderRadius.circular(5),
                    border: pw.Border.all(
                      color: _opacity(PdfColors.orange, 0.3),
                      width: 1,
                    ),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Icon(
                        pw.IconData(0xe613),
                        size: 16,
                        color: PdfColors.orange,
                      ),
                      pw.SizedBox(width: 8),
                      pw.Text(
                        'Firmado digitalmente por Kaab Terra',
                        style: pw.TextStyle(
                          fontSize: 10,
                          color: _opacity(PdfColors.brown, 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey200,
                    borderRadius: pw.BorderRadius.circular(5),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Icon(
                        pw.IconData(0xeb3a),
                        size: 30,
                        color: PdfColors.green900,
                      ),
                      pw.SizedBox(width: 10),
                      pw.Text(
                        'Verificar en: kaabterra.com/verify/$certificateCode',
                        style: pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.green900,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Este certificado es propiedad de Kaab Terra y garantiza la trazabilidad del lote.',
                  style: pw.TextStyle(
                    fontSize: 8,
                    color: _opacity(PdfColors.brown, 0.4),
                    fontStyle: pw.FontStyle.italic,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.Text(
                  'www.kaabterra.com',
                  style: pw.TextStyle(
                    fontSize: 8,
                    color: _opacity(PdfColors.brown, 0.3),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    // ✅ Guardar en un directorio accesible
    Directory output;

    try {
      if (Platform.isAndroid) {
        output = Directory('/storage/emulated/0/Download');
        if (!await output.exists()) {
          output = await getExternalStorageDirectory() ?? await getApplicationDocumentsDirectory();
        }
      } else if (Platform.isIOS) {
        output = await getApplicationDocumentsDirectory();
      } else {
        output = await getTemporaryDirectory();
      }
    } catch (_) {
      output = await getApplicationDocumentsDirectory();
    }

    final fileName = 'certificado_$certificateCode.pdf';
    final file = File('${output.path}/$fileName');

    if (await file.exists()) {
      await file.delete();
    }

    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Row(
      children: [
        pw.Text(
          '$label: ',
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.green900,
          ),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 12,
            color: PdfColors.brown,
          ),
        ),
      ],
    );
  }
}

// ── Función mejorada para abrir y compartir PDF ──────────────
Future<void> openAndShareCertificatePDF(File file) async {
  // ✅ Primero verificar que el archivo existe
  if (!await file.exists()) {
    throw Exception('El certificado no se pudo generar correctamente.');
  }

  // ✅ Obtener la ruta del archivo
  final filePath = file.path;
  final fileName = filePath.split('/').last;

  // ✅ Intentar abrir con OpenFile
  try {
    final openResult = await OpenFile.open(filePath);
    if (openResult.type == ResultType.done) {
      print('✅ PDF abierto correctamente');
      return;
    }
  } catch (e) {
    print('⚠️ Error al abrir con OpenFile: $e');
  }

  // ✅ Si OpenFile falla, usar Share para compartir el archivo
  try {
    await Share.shareXFiles(
      [XFile(filePath)],
      text: '📄 Certificado de Lote - Kaab Terra\n\nArchivo: $fileName',
    );
    print('✅ PDF compartido correctamente');
    return;
  } catch (e) {
    print('⚠️ Error al compartir: $e');
  }

  // ✅ Si todo falla, mostrar mensaje con la ruta
  throw Exception(
      'El certificado se ha guardado en:\n$filePath\n\n'
          'Puedes abrirlo manualmente desde la carpeta de Descargas.'
  );
}