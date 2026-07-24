// lib/features/farms/presentation/screens/edit_lot_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/farms/data/models/lot_model.dart';
import 'package:kaabcafe/features/farms/data/models/farm_details_model.dart';

class EditLotScreen extends StatefulWidget {
  final LotModel lot;
  final FarmDetailsModel farm;

  const EditLotScreen({super.key, required this.lot, required this.farm});

  @override
  State<EditLotScreen> createState() => _EditLotScreenState();
}

class _EditLotScreenState extends State<EditLotScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _areaController;
  late TextEditingController _altitudeController;
  late TextEditingController _ageController;
  late TextEditingController _densityController;

  String _selectedVariety = '';
  String _selectedStatus = '';
  List<String> _images = [];
  bool _isSaving = false;
  bool _isLoadingImages = false;

  final List<String> _varietyOptions = [
    'Arábica',
    'Bourbon',
    'Typica',
    'Catuaí',
    'Geisha',
    'Robusta',
    'Otra',
  ];

  final List<String> _statusOptions = [
    'Saludable',
    'Atención',
    'Riesgo',
  ];

  final Map<String, IconData> _statusIcons = {
    'Saludable': Icons.emoji_events,
    'Atención': Icons.warning,
    'Riesgo': Icons.error,
  };

  final Map<String, Color> _statusColors = {
    'Saludable': const Color(0xFF2E7D32),
    'Atención': const Color(0xFFF57C00),
    'Riesgo': const Color(0xFFD32F2F),
  };

  @override
  void initState() {
    super.initState();
    // ✅ CARGAR DATOS REALES DEL LOTE
    _nameController = TextEditingController(text: widget.lot.name);
    _descriptionController = TextEditingController(text: widget.lot.description ?? '');
    _areaController = TextEditingController(text: widget.lot.area.toString());
    _altitudeController = TextEditingController(text: widget.lot.altitude?.toString() ?? '');
    _ageController = TextEditingController(text: widget.lot.age?.toString() ?? '');
    _densityController = TextEditingController(text: widget.lot.density?.toString() ?? '');
    _selectedVariety = widget.lot.variety;
    _images = List.from(widget.lot.imageUrls ?? []);

    // ✅ MAPEAR ESTADO REAL
    switch (widget.lot.status) {
      case LotStatus.healthy:
        _selectedStatus = 'Saludable';
        break;
      case LotStatus.attention:
        _selectedStatus = 'Atención';
        break;
      case LotStatus.risk:
        _selectedStatus = 'Riesgo';
        break;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _areaController.dispose();
    _altitudeController.dispose();
    _ageController.dispose();
    _densityController.dispose();
    super.dispose();
  }

  // ✅ MÉTODO PARA AGREGAR IMAGEN (SIMULADO - SIN image_picker)
  void _addImage() {
    // En una implementación real, aquí usarías image_picker
    // Por ahora, agregamos una imagen de ejemplo
    setState(() {
      _images.add('assets/img/default_farm.png');
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Imagen agregada (demo)'),
        backgroundColor: AppTheme.primaryGreen,
      ),
    );
  }

  // ✅ MÉTODO PARA ELIMINAR IMAGEN
  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _saveChanges() async {
    setState(() {
      _isSaving = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isSaving = false;
      });
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppTheme.primaryGreen,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '¡Lote actualizado!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkCoffee,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'La información del lote ha sido actualizada correctamente.',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.darkCoffee,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Ver detalle'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Continuar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _archiveLot() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: const Text('¿Archivar este lote?'),
        content: const Text(
          'El lote será movido al archivo y no aparecerá en el listado activo. Puedes restaurarlo más tarde.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Lote archivado'),
                  backgroundColor: AppTheme.goldCoffee,
                ),
              );
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.orange,
            ),
            child: const Text('Archivar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightBeige,
              AppTheme.primaryGreen.withOpacity(0.03),
              AppTheme.lightBeige,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Barra superior
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back),
                      color: AppTheme.darkCoffee,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Editar Lote',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkCoffee,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Actualiza la información de tu lote.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.darkCoffee.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.primaryGreen, AppTheme.secondaryGreen],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryGreen.withOpacity(0.3),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: TextButton(
                        onPressed: _isSaving ? null : _saveChanges,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        child: _isSaving
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : const Row(
                          children: [
                            Icon(Icons.save, size: 18),
                            SizedBox(width: 4),
                            Text('Guardar'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Contenido principal
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // Encabezado con información del lote
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppTheme.primaryGreen, AppTheme.secondaryGreen],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _nameController.text.isEmpty ? 'Nuevo Lote' : _nameController.text,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.farm.name,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.location_on, size: 14, color: Colors.white70),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    widget.farm.location,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Sección de imágenes
                      _buildImageSection(),

                      const SizedBox(height: 16),

                      // Información general
                      _buildSection(
                        'Información general',
                        Column(
                          children: [
                            _buildTextField('Nombre del lote', _nameController, Icons.agriculture),
                            const SizedBox(height: 16),
                            _buildTextField('Descripción', _descriptionController, Icons.description, maxLines: 3),
                            const SizedBox(height: 16),
                            _buildReadOnlyField('Finca asociada', widget.farm.name, Icons.landscape),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Información agrícola
                      _buildSection(
                        'Información agrícola',
                        Column(
                          children: [
                            _buildDropdown('Variedad de café', _selectedVariety, _varietyOptions, (value) {
                              setState(() => _selectedVariety = value!);
                            }),
                            const SizedBox(height: 16),
                            _buildTextField('Área cultivada', _areaController, Icons.landscape,
                                suffix: 'hectáreas', keyboardType: TextInputType.number),
                            const SizedBox(height: 16),
                            _buildTextField('Altitud', _altitudeController, Icons.height,
                                suffix: 'msnm', keyboardType: TextInputType.number),
                            const SizedBox(height: 16),
                            _buildTextField('Edad del cultivo', _ageController, Icons.timer,
                                suffix: 'años', keyboardType: TextInputType.number),
                            const SizedBox(height: 16),
                            _buildTextField('Densidad de siembra', _densityController, Icons.grid_on,
                                suffix: 'plantas/ha', keyboardType: TextInputType.number),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Estado del lote
                      _buildSection(
                        'Estado del lote',
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: _statusOptions.map((status) {
                            final isSelected = _selectedStatus == status;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedStatus = status),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected ? _statusColors[status]?.withOpacity(0.1) : Colors.grey.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: isSelected ? _statusColors[status]! : Colors.grey.withOpacity(0.2),
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(_statusIcons[status], size: 18,
                                        color: isSelected ? _statusColors[status] : AppTheme.darkCoffee.withOpacity(0.5)),
                                    const SizedBox(width: 8),
                                    Text(status, style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                      color: isSelected ? _statusColors[status] : AppTheme.darkCoffee,
                                    )),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Botones de acción
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _saveChanges,
                          icon: const Icon(Icons.save_rounded),
                          label: const Text('Guardar Cambios', style: TextStyle(fontSize: 16)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _archiveLot,
                          icon: const Icon(Icons.archive_outlined),
                          label: const Text('Archivar Lote'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: Colors.orange.withOpacity(0.3)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ SECCIÓN DE IMÁGENES
  Widget _buildImageSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Imágenes del lote',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkCoffee,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: _addImage,
                icon: const Icon(Icons.add_photo_alternate, color: AppTheme.primaryGreen),
                label: const Text(
                  'Agregar',
                  style: TextStyle(color: AppTheme.primaryGreen),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_images.isEmpty)
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.2),
                  // ✅ CORREGIDO: usar BorderStyle.solid en lugar de dashed
                  style: BorderStyle.solid,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_outlined, size: 32, color: Colors.grey.withOpacity(0.5)),
                    const SizedBox(height: 8),
                    Text(
                      'No hay imágenes',
                      style: TextStyle(
                        color: Colors.grey.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: _images[index].startsWith('assets/')
                              ? Image.asset(
                            _images[index],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey.withOpacity(0.1),
                                child: Icon(Icons.broken_image, color: Colors.grey.withOpacity(0.5)),
                              );
                            },
                          )
                              : Image.file(
                            File(_images[index]),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey.withOpacity(0.1),
                                child: Icon(Icons.broken_image, color: Colors.grey.withOpacity(0.5)),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 14,
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
        ],
      ),
    );
  }

  // Widgets auxiliares
  Widget _buildSection(String title, Widget content) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkCoffee,
            ),
          ),
          const SizedBox(height: 20),
          content,
        ],
      ),
    );
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller,
      IconData icon, {
        String? hintText,
        String? suffix,
        int maxLines = 1,
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkCoffee,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: AppTheme.primaryGreen),
            hintText: hintText,
            suffixText: suffix,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppTheme.primaryGreen),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildReadOnlyField(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkCoffee,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
            color: Colors.grey.withOpacity(0.05),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppTheme.primaryGreen),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.darkCoffee,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String value, List<String> options, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkCoffee,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value.isNotEmpty ? value : null,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.emoji_nature, size: 20, color: AppTheme.primaryGreen),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppTheme.primaryGreen),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          items: options.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}