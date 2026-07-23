// lib/features/farms/presentation/qr/qr_scanner.dart
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class QRScannerWidget extends StatefulWidget {
  final Function(String) onScanResult;
  final VoidCallback? onClose;

  const QRScannerWidget({
    super.key,
    required this.onScanResult,
    this.onClose,
  });

  @override
  State<QRScannerWidget> createState() => _QRScannerWidgetState();
}

class _QRScannerWidgetState extends State<QRScannerWidget> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  bool _isScanning = true;
  bool _isInitialized = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Cámara con MobileScanner
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              if (!_isScanning) return;

              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                final String? code = barcode.rawValue;
                if (code != null && code.isNotEmpty) {
                  setState(() {
                    _isScanning = false;
                  });

                  // Vibrar o dar feedback (opcional)
                  // HapticFeedback.lightImpact();

                  widget.onScanResult(code);
                  break;
                }
              }
            },
          ),

          // Overlay con el recuadro de escaneo
          CustomPaint(
            painter: _ScannerOverlayPainter(
              borderColor: AppTheme.primaryGreen,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 4,
              cutOutSize: 250,
            ),
            size: MediaQuery.of(context).size,
          ),

          // Botón cerrar
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              onPressed: widget.onClose ?? () => Navigator.pop(context),
              icon: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ),

          // Texto inferior
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  'Coloca el código QR dentro del cuadro',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                // Botón para encender/apagar linterna
                IconButton(
                  onPressed: () {
                    _controller.toggleTorch();
                  },
                  icon: Icon(
                    Icons.flashlight_on,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Painter para el overlay del escáner
class _ScannerOverlayPainter extends CustomPainter {
  final Color borderColor;
  final double borderRadius;
  final double borderLength;
  final double borderWidth;
  final double cutOutSize;

  const _ScannerOverlayPainter({
    required this.borderColor,
    required this.borderRadius,
    required this.borderLength,
    required this.borderWidth,
    required this.cutOutSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    // Área central (recorte)
    final double left = (size.width - cutOutSize) / 2;
    final double top = (size.height - cutOutSize) / 2;
    final Rect cutOutRect = Rect.fromLTWH(left, top, cutOutSize, cutOutSize);

    // Dibujar fondo oscuro con recorte
    final Path path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRect(cutOutRect)
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, paint);

    // Dibujar bordes del recuadro
    final Paint borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    // Esquinas del recuadro
    final double cornerLength = borderLength;
    final double cornerRadius = borderRadius;

    // Esquina superior izquierda
    canvas.drawLine(
      Offset(left, top + cornerLength),
      Offset(left, top + cornerRadius),
      borderPaint,
    );
    canvas.drawLine(
      Offset(left, top),
      Offset(left + cornerLength, top),
      borderPaint,
    );
    // Redondear esquina
    canvas.drawArc(
      Rect.fromCircle(center: Offset(left + cornerRadius, top + cornerRadius), radius: cornerRadius),
      -3.14159,
      1.5708,
      false,
      borderPaint,
    );

    // Esquina superior derecha
    canvas.drawLine(
      Offset(left + cutOutSize - cornerLength, top),
      Offset(left + cutOutSize, top),
      borderPaint,
    );
    canvas.drawLine(
      Offset(left + cutOutSize, top + cornerLength),
      Offset(left + cutOutSize, top + cornerRadius),
      borderPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset(left + cutOutSize - cornerRadius, top + cornerRadius), radius: cornerRadius),
      -1.5708,
      1.5708,
      false,
      borderPaint,
    );

    // Esquina inferior izquierda
    canvas.drawLine(
      Offset(left, top + cutOutSize - cornerLength),
      Offset(left, top + cutOutSize),
      borderPaint,
    );
    canvas.drawLine(
      Offset(left + cornerLength, top + cutOutSize),
      Offset(left, top + cutOutSize),
      borderPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset(left + cornerRadius, top + cutOutSize - cornerRadius), radius: cornerRadius),
      1.5708,
      1.5708,
      false,
      borderPaint,
    );

    // Esquina inferior derecha
    canvas.drawLine(
      Offset(left + cutOutSize - cornerLength, top + cutOutSize),
      Offset(left + cutOutSize, top + cutOutSize),
      borderPaint,
    );
    canvas.drawLine(
      Offset(left + cutOutSize, top + cutOutSize - cornerLength),
      Offset(left + cutOutSize, top + cutOutSize),
      borderPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset(left + cutOutSize - cornerRadius, top + cutOutSize - cornerRadius), radius: cornerRadius),
      0,
      1.5708,
      false,
      borderPaint,
    );

    // Líneas guía sutiles en el centro
    final Paint guidePaint = Paint()
      ..color = borderColor.withOpacity(0.3)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Cruz en el centro
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double crossSize = 20;

    canvas.drawLine(
      Offset(centerX - crossSize, centerY),
      Offset(centerX + crossSize, centerY),
      guidePaint,
    );
    canvas.drawLine(
      Offset(centerX, centerY - crossSize),
      Offset(centerX, centerY + crossSize),
      guidePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}