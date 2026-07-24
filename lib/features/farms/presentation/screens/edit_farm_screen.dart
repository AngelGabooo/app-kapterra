// lib/features/farms/presentation/screens/edit_farm_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/farms/data/models/farm_details_model.dart';

class EditFarmScreen extends StatefulWidget {
  final FarmDetailsModel farm;

  const EditFarmScreen({super.key, required this.farm});

  @override
  State<EditFarmScreen> createState() => _EditFarmScreenState();
}

class _EditFarmScreenState extends State<EditFarmScreen> {
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _altitudeController;
  late TextEditingController _surfaceController;
  late TextEditingController _lotsController;
  late TextEditingController _yearController;

  String _selectedVariety = '';
  String _selectedProductionSystem = '';
  List<String> _selectedCertifications = [];
  bool _isSaving = false;
  bool _isLoadingImage = false;
  String? _farmImagePath;

  // ✅ ImagePicker correctamente inicializado
  final ImagePicker _picker = ImagePicker();

  final List<String> _varietyOptions = [
    'Arábica',
    'Bourbon',
    'Typica',
    'Catuaí',
    'Geisha',
    'Robusta',
    'Otra',
  ];

  final List<String> _productionSystemOptions = [
    'Convencional',
    'Orgánico',
    'Sostenible',
    'Agroforestal',
  ];

  final List<String> _certificationOptions = [
    'Orgánico',
    'Comercio Justo',
    'Rainforest Alliance',
    'UTZ',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.farm.name);
    _locationController = TextEditingController(text: widget.farm.location);
    _altitudeController = TextEditingController(text: widget.farm.altitude.toString());
    _surfaceController = TextEditingController(text: widget.farm.hectares.toString());
    _lotsController = TextEditingController(text: widget.farm.lots.toString());
    _yearController = TextEditingController(text: widget.farm.establishmentYear?.toString() ?? '');
    _selectedVariety = widget.farm.mainVariety ?? 'Arábica';
    _selectedProductionSystem = widget.farm.productionSystem ?? 'Orgánico';
    _selectedCertifications = List.from(widget.farm.certifications ?? []);
    _farmImagePath = widget.farm.imageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _altitudeController.dispose();
    _surfaceController.dispose();
    _lotsController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  // ✅ MÉTODO PARA TOMAR FOTO CON CÁMARA
  Future<void> _takePhoto() async {
    try {
      setState(() => _isLoadingImage = true);

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _farmImagePath = image.path;
          _isLoadingImage = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Foto tomada correctamente'),
            backgroundColor: AppTheme.primaryGreen,
          ),
        );
      } else {
        setState(() => _isLoadingImage = false);
      }
    } catch (e) {
      setState(() => _isLoadingImage = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al tomar foto: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ✅ MÉTODO PARA SELECCIONAR DE GALERÍA
  Future<void> _pickFromGallery() async {
    try {
      setState(() => _isLoadingImage = true);

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _farmImagePath = image.path;
          _isLoadingImage = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Imagen seleccionada correctamente'),
            backgroundColor: AppTheme.primaryGreen,
          ),
        );
      } else {
        setState(() => _isLoadingImage = false);
      }
    } catch (e) {
      setState(() => _isLoadingImage = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al seleccionar imagen: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showImagePickerDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Cambiar imagen de portada',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkCoffee,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImagePickerOption(
                  icon: Icons.photo_library,
                  label: 'Galería',
                  onTap: () {
                    Navigator.pop(context);
                    _pickFromGallery();
                  },
                ),
                _buildImagePickerOption(
                  icon: Icons.camera_alt,
                  label: 'Cámara',
                  onTap: () {
                    Navigator.pop(context);
                    _takePhoto();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 28, color: AppTheme.primaryGreen),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.darkCoffee,
            ),
          ),
        ],
      ),
    );
  }

  void _saveChanges() async {
    setState(() {
      _isSaving = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isSaving = false;
    });

    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
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
              '¡Cambios guardados!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkCoffee,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'La información de la finca ha sido actualizada correctamente.',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.darkCoffee,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Volver al detalle de finca'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: const Text('¿Deseas eliminar esta finca?'),
        content: const Text(
          'Esta acción puede afectar lotes, actividades e indicadores asociados. Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Finca eliminada'),
                  backgroundColor: Colors.red,
                ),
              );
              context.go(RouteNames.myFarms);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Eliminar'),
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
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      color: AppTheme.darkCoffee,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Editar Finca',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkCoffee,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Actualiza la información de tu finca.',
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
                            : const Text('Guardar'),
                      ),
                    ),
                  ],
                ),
              ),

              // Contenido
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // Imagen de portada
                      Stack(
                        children: [
                          Container(
                            height: 180,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.primaryGreen.withOpacity(0.3),
                                  AppTheme.secondaryGreen.withOpacity(0.2),
                                ],
                              ),
                            ),
                            child: _farmImagePath != null && _farmImagePath!.startsWith('assets/')
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                _farmImagePath!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 180,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Icon(
                                      Icons.landscape,
                                      size: 60,
                                      color: AppTheme.primaryGreen.withOpacity(0.5),
                                    ),
                                  );
                                },
                              ),
                            )
                                : _farmImagePath != null && _farmImagePath!.isNotEmpty
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(
                                File(_farmImagePath!),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 180,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Icon(
                                      Icons.landscape,
                                      size: 60,
                                      color: AppTheme.primaryGreen.withOpacity(0.5),
                                    ),
                                  );
                                },
                              ),
                            )
                                : Center(
                              child: Icon(
                                Icons.landscape,
                                size: 60,
                                color: AppTheme.primaryGreen.withOpacity(0.5),
                              ),
                            ),
                          ),
                          if (_isLoadingImage)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.black.withOpacity(0.3),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: IconButton(
                                onPressed: _isLoadingImage ? null : _showImagePickerDialog,
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: _isLoadingImage ? Colors.grey : AppTheme.primaryGreen,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _farmImagePath != null ? '📷 Portada' : 'Sin imagen',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Información general
                      Container(
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
                            const Text(
                              'Información general',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.darkCoffee,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildTextField('Nombre de la finca', _nameController, Icons.agriculture),
                            const SizedBox(height: 16),
                            _buildTextField('Ubicación', _locationController, Icons.location_on),
                            const SizedBox(height: 16),
                            _buildTextField('Altitud (msnm)', _altitudeController, Icons.height, isNumber: true),
                            const SizedBox(height: 16),
                            _buildTextField('Superficie total', _surfaceController, Icons.landscape, suffix: 'ha', isNumber: true),
                            const SizedBox(height: 16),
                            _buildTextField('Número de lotes', _lotsController, Icons.view_module, isNumber: true),
                            const SizedBox(height: 16),
                            _buildTextField('Año de establecimiento', _yearController, Icons.date_range, isNumber: true),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Ubicación geográfica
                      Container(
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
                            const Text(
                              'Ubicación geográfica',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.darkCoffee,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: AppTheme.primaryGreen.withOpacity(0.1),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.map, size: 40, color: AppTheme.primaryGreen),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${widget.farm.latitude.toStringAsFixed(4)}, ${widget.farm.longitude.toStringAsFixed(4)}',
                                      style: TextStyle(color: AppTheme.darkCoffee),
                                    ),
                                    Text(
                                      widget.farm.location,
                                      style: TextStyle(
                                        color: AppTheme.darkCoffee.withOpacity(0.5),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.my_location, size: 18),
                                    label: const Text('Usar ubicación'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppTheme.primaryGreen,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.edit_location, size: 18),
                                    label: const Text('Editar ubicación'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppTheme.goldCoffee,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Información productiva
                      Container(
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
                            const Text(
                              'Información productiva',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.darkCoffee,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildDropdown('Variedad principal', _selectedVariety, _varietyOptions, (value) {
                              setState(() {
                                _selectedVariety = value!;
                              });
                            }),
                            const SizedBox(height: 16),
                            _buildDropdown('Sistema de producción', _selectedProductionSystem, _productionSystemOptions, (value) {
                              setState(() {
                                _selectedProductionSystem = value!;
                              });
                            }),
                            const SizedBox(height: 16),
                            const Text(
                              'Certificaciones',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.darkCoffee,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 12,
                              children: _certificationOptions.map((cert) {
                                return FilterChip(
                                  label: Text(cert, style: const TextStyle(fontSize: 13)),
                                  selected: _selectedCertifications.contains(cert),
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        _selectedCertifications.add(cert);
                                      } else {
                                        _selectedCertifications.remove(cert);
                                      }
                                    });
                                  },
                                  selectedColor: AppTheme.primaryGreen.withOpacity(0.1),
                                  checkmarkColor: AppTheme.primaryGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Resumen actual
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme.primaryGreen.withOpacity(0.05),
                              AppTheme.goldCoffee.withOpacity(0.02),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppTheme.primaryGreen.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Resumen actual',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.darkCoffee,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildSummaryItem(
                                    Icons.view_module,
                                    'Lotes activos',
                                    '${widget.farm.lots}',
                                  ),
                                ),
                                Expanded(
                                  child: _buildSummaryItem(
                                    Icons.eco,
                                    'Producción anual',
                                    '${widget.farm.productivity.toStringAsFixed(0)} kg',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildSummaryItem(
                                    Icons.attach_money,
                                    'Costos acumulados',
                                    '\$0.00',
                                  ),
                                ),
                                Expanded(
                                  child: _buildSummaryItem(
                                    Icons.trending_up,
                                    'Rentabilidad',
                                    '0%',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Botones de acción
                      Column(
                        children: [
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
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.close_rounded),
                              label: const Text('Cancelar'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.darkCoffee,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                side: BorderSide(color: AppTheme.darkCoffee.withOpacity(0.15)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: _confirmDelete,
                              icon: const Icon(Icons.delete_outline_rounded),
                              label: const Text('Eliminar Finca'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red.shade600,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                side: BorderSide(color: Colors.red.withOpacity(0.3)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                            ),
                          ),
                        ],
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

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {String? suffix, bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkCoffee,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 18, color: AppTheme.primaryGreen),
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

  Widget _buildDropdown(String label, String value, List<String> options, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkCoffee,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value.isNotEmpty ? value : null,
          decoration: InputDecoration(
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

  Widget _buildSummaryItem(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryGreen),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkCoffee,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: AppTheme.darkCoffee.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}