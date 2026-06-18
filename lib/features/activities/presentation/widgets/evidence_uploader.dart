// lib/features/activities/presentation/widgets/evidence_uploader.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class EvidenceUploader extends StatefulWidget {
  final Function(List<String>) onImagesAdded;
  final List<String> initialImages;

  const EvidenceUploader({
    super.key,
    required this.onImagesAdded,
    this.initialImages = const [],
  });

  @override
  State<EvidenceUploader> createState() => _EvidenceUploaderState();
}

class _EvidenceUploaderState extends State<EvidenceUploader> {
  late List<String> _images;

  @override
  void initState() {
    super.initState();
    _images = List.from(widget.initialImages);
  }

  void _addImage() {
    // TODO: Implementar selección de imagen real
    setState(() {
      _images.add('placeholder_${DateTime.now().millisecondsSinceEpoch}');
    });
    widget.onImagesAdded(_images);
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
    widget.onImagesAdded(_images);
  }

  void _viewImage(int index) {
    // TODO: Implementar vista de imagen en grande
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Icon(Icons.image, size: 64, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.download),
                    label: const Text('Descargar'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    label: const Text('Cerrar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Evidencias',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkCoffee,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildUploadButton(Icons.camera_alt, 'Tomar fotografía'),
            const SizedBox(width: 12),
            _buildUploadButton(Icons.image, 'Subir imagen'),
            const SizedBox(width: 12),
            _buildUploadButton(Icons.attach_file, 'Adjuntar'),
          ],
        ),
        if (_images.isNotEmpty) ...[
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: const Center(
                          child: Icon(Icons.image, size: 40, color: Colors.grey),
                        ),
                      ),
                      // Botón Ver
                      Positioned(
                        bottom: 4,
                        left: 4,
                        child: GestureDetector(
                          onTap: () => _viewImage(index),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGreen,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.visibility, size: 14, color: Colors.white),
                          ),
                        ),
                      ),
                      // Botón Descargar
                      Positioned(
                        bottom: 4,
                        left: 36,
                        child: GestureDetector(
                          onTap: () {
                            // TODO: Implementar descarga
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Descargando...'), backgroundColor: AppTheme.primaryGreen),
                            );
                          },
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppTheme.goldCoffee,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.download, size: 14, color: Colors.white),
                          ),
                        ),
                      ),
                      // Botón Eliminar
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, size: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildUploadButton(IconData icon, String label) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: _addImage,
        icon: Icon(icon, size: 18),
        label: Text(label, style: const TextStyle(fontSize: 12)),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.primaryGreen,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}