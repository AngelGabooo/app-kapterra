// lib/features/farm/presentation/widgets/farm_form.dart

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/services/elevation_service.dart';
import 'package:kaabcafe/features/farm/data/models/farm_model.dart';
import '../../../../core/widgets/neumorphic_widgets.dart';

class FarmForm extends StatefulWidget {
  final Function(FarmModel) onSave;
  final FarmModel? initialFarm;
  final Function(double lat, double lng)? onLocationChanged; // ✅ CORREGIDO: hacer opcional

  const FarmForm({
    super.key,
    required this.onSave,
    this.initialFarm,
    this.onLocationChanged,
  });

  @override
  State<FarmForm> createState() => FarmFormState();
}

class FarmFormState extends State<FarmForm> {
  final _formKey = GlobalKey<FormState>();
  late FarmModel _farm;
  bool _isLoadingLocation = false;
  bool _isLoadingElevation = false;

  final TextEditingController _altitudeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController(); // ✅ AGREGADO

  final _coffeeVarietyOptions = ['Arábica', 'Robusta', 'Bourbon', 'Typica', 'Catuaí', 'Geisha', 'Otra'];

  @override
  void initState() {
    super.initState();
    _farm = widget.initialFarm ?? FarmModel();

    if (_farm.altitude > 0) {
      _altitudeController.text = _farm.altitude.toString();
    }
    if (_farm.location.isNotEmpty) {
      _locationController.text = _farm.location;
    }
  }

  @override
  void dispose() {
    _altitudeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      _farm.createdAt = DateTime.now();
      widget.onSave(_farm);
    }
  }

  // ✅ Método para actualizar la ubicación desde el mapa
  void updateLocationFromMap(double lat, double lng) {
    setState(() {
      _farm.latitude = lat;
      _farm.longitude = lng;
      _farm.location = 'Ubicación seleccionada (${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)})';
      _locationController.text = _farm.location; // ✅ ACTUALIZAR controlador
    });
    _fetchElevation(lat, lng);
  }

  // ✅ Método para obtener la ubicación actual
  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      final status = await Permission.location.request();

      if (status.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Se necesita permiso de ubicación para continuar'),
            backgroundColor: Colors.orange,
          ),
        );
        setState(() => _isLoadingLocation = false);
        return;
      }

      if (status.isPermanentlyDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor habilita la ubicación desde ajustes'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isLoadingLocation = false);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _farm.latitude = position.latitude;
        _farm.longitude = position.longitude;
        _farm.location = 'Ubicación actual (${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)})';
        _locationController.text = _farm.location; // ✅ ACTUALIZAR controlador
        _isLoadingLocation = false;
      });

      // ✅ Obtener altitud desde las coordenadas
      await _fetchElevation(position.latitude, position.longitude);

      // ✅ NOTIFICAR AL PADRE PARA ACTUALIZAR EL MAPA
      widget.onLocationChanged?.call(position.latitude, position.longitude);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('📍 Ubicación obtenida: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}'),
          backgroundColor: AppTheme.primaryGreen,
        ),
      );

    } catch (e) {
      setState(() => _isLoadingLocation = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al obtener ubicación: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ✅ Método para obtener altitud desde coordenadas
  Future<void> _fetchElevation(double lat, double lng) async {
    setState(() => _isLoadingElevation = true);

    try {
      final elevation = await ElevationService.getElevation(lat, lng);

      if (elevation != null) {
        setState(() {
          _farm.altitude = elevation.round();
          _altitudeController.text = elevation.round().toString();
          _isLoadingElevation = false;
        });
        debugPrint('✅ Altitud obtenida: ${elevation.round()} msnm');
      } else {
        setState(() => _isLoadingElevation = false);
        debugPrint('⚠️ No se pudo obtener la altitud');
      }
    } catch (e) {
      setState(() => _isLoadingElevation = false);
      debugPrint('Error obteniendo altitud: $e');
    }
  }

  InputDecoration _buildInputDecoration({
    required IconData icon,
    required String hintText,
    String? suffixText,
    required ThemeData theme,
    bool isDark = false,
  }) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    return InputDecoration(
      prefixIcon: Icon(icon, color: AppTheme.primaryGreen),
      hintText: hintText,
      suffixText: suffixText,
      suffixStyle: TextStyle(color: textColor.withOpacity(0.6)),
      hintStyle: TextStyle(color: textColor.withOpacity(0.4)),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: theme.colorScheme.error, width: 1.4),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: theme.colorScheme.error, width: 1.4),
      ),
      filled: false,
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
    );
  }

  Widget _sectionHeader(ThemeData theme, String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryGreen, AppTheme.goldCoffee],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final labelStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: textColor.withOpacity(0.9),
    );

    final cardColor = isDark
        ? AppTheme.coffeeDeep.withOpacity(0.7)
        : const Color(0xFFE8E0D5).withOpacity(0.9);

    final insetCardColor = isDark
        ? AppTheme.coffeeDark.withOpacity(0.5)
        : const Color(0xFFE8E0D5).withOpacity(0.7);

    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : AppTheme.darkCoffee.withOpacity(0.06),
            width: 0.5,
          ),
          boxShadow: const [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(theme, 'Datos de la finca'),
            const SizedBox(height: 24),

            Text('Nombre de la finca', style: labelStyle),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: insetCardColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.06)
                      : AppTheme.darkCoffee.withOpacity(0.06),
                  width: 0.5,
                ),
                boxShadow: const [],
              ),
              child: TextFormField(
                initialValue: _farm.name,
                onChanged: (value) => _farm.name = value,
                style: TextStyle(color: textColor),
                decoration: _buildInputDecoration(
                  icon: Icons.agriculture,
                  hintText: 'Ej. Finca El Mirador',
                  theme: theme,
                  isDark: isDark,
                ),
                validator: (value) =>
                (value == null || value.isEmpty) ? 'Por favor ingresa el nombre de la finca' : null,
              ),
            ),

            const SizedBox(height: 20),

            Text('Ubicación', style: labelStyle),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: insetCardColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.06)
                      : AppTheme.darkCoffee.withOpacity(0.06),
                  width: 0.5,
                ),
                boxShadow: const [],
              ),
              child: TextFormField(
                controller: _locationController, // ✅ USAR CONTROLLER
                onChanged: (value) => _farm.location = value,
                style: TextStyle(color: textColor),
                decoration: _buildInputDecoration(
                  icon: Icons.location_on_outlined,
                  hintText: 'Ej. Motozintla, Chiapas',
                  theme: theme,
                  isDark: isDark,
                ),
                validator: (value) =>
                (value == null || value.isEmpty) ? 'Por favor ingresa la ubicación' : null,
              ),
            ),

            const SizedBox(height: 12),

            // ✅ Botón de ubicación actual
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: _isLoadingLocation ? null : _getCurrentLocation,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppTheme.coffeeDark.withOpacity(0.5)
                        : const Color(0xFFE8E0D5).withOpacity(0.7),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.06)
                          : AppTheme.darkCoffee.withOpacity(0.06),
                      width: 0.5,
                    ),
                    boxShadow: const [],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isLoadingLocation)
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.primaryGreen,
                          ),
                        )
                      else
                        Icon(
                          Icons.my_location,
                          color: AppTheme.primaryGreen,
                          size: 20,
                        ),
                      const SizedBox(width: 10),
                      Text(
                        _isLoadingLocation ? 'Obteniendo ubicación...' : 'Usar ubicación actual',
                        style: TextStyle(
                          color: AppTheme.primaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Campo de Altitud con carga automática
            Text('Altitud (msnm)', style: labelStyle),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: insetCardColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.06)
                      : AppTheme.darkCoffee.withOpacity(0.06),
                  width: 0.5,
                ),
                boxShadow: const [],
              ),
              child: Stack(
                children: [
                  TextFormField(
                    controller: _altitudeController,
                    onChanged: (value) {
                      _farm.altitude = int.tryParse(value) ?? 0;
                    },
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: textColor),
                    decoration: _buildInputDecoration(
                      icon: Icons.height,
                      hintText: 'Ej: 1200',
                      theme: theme,
                      isDark: isDark,
                    ),
                    validator: (value) =>
                    (value == null || value.isEmpty) ? 'Por favor ingresa la altitud' : null,
                  ),
                  if (_isLoadingElevation)
                    Positioned(
                      right: 16,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text('Superficie total', style: labelStyle),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: insetCardColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.06)
                      : AppTheme.darkCoffee.withOpacity(0.06),
                  width: 0.5,
                ),
                boxShadow: const [],
              ),
              child: TextFormField(
                initialValue: _farm.surface > 0 ? _farm.surface.toString() : '',
                onChanged: (value) => _farm.surface = double.tryParse(value) ?? 0,
                keyboardType: TextInputType.number,
                style: TextStyle(color: textColor),
                decoration: _buildInputDecoration(
                  icon: Icons.landscape,
                  hintText: 'Ej: 5.5',
                  suffixText: 'hectáreas',
                  theme: theme,
                  isDark: isDark,
                ),
                validator: (value) =>
                (value == null || value.isEmpty) ? 'Por favor ingresa la superficie' : null,
              ),
            ),

            const SizedBox(height: 20),

            Text('Número aproximado de lotes', style: labelStyle),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: insetCardColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.06)
                      : AppTheme.darkCoffee.withOpacity(0.06),
                  width: 0.5,
                ),
                boxShadow: const [],
              ),
              child: TextFormField(
                initialValue: _farm.numberOfLots > 0 ? _farm.numberOfLots.toString() : '',
                onChanged: (value) => _farm.numberOfLots = int.tryParse(value) ?? 0,
                keyboardType: TextInputType.number,
                style: TextStyle(color: textColor),
                decoration: _buildInputDecoration(
                  icon: Icons.view_module,
                  hintText: 'Ej: 10',
                  theme: theme,
                  isDark: isDark,
                ),
                validator: (value) =>
                (value == null || value.isEmpty) ? 'Por favor ingresa el número de lotes' : null,
              ),
            ),

            const SizedBox(height: 20),

            Text('Variedad principal cultivada', style: labelStyle),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: insetCardColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.06)
                      : AppTheme.darkCoffee.withOpacity(0.06),
                  width: 0.5,
                ),
                boxShadow: const [],
              ),
              child: DropdownButtonFormField<String>(
                value: _farm.mainVariety.isEmpty ? null : _farm.mainVariety,
                dropdownColor: isDark ? AppTheme.coffeeDeep : const Color(0xFFF0E8D8),
                style: TextStyle(color: textColor),
                hint: Text(
                  'Selecciona una variedad',
                  style: TextStyle(color: textColor.withOpacity(0.4)),
                ),
                decoration: _buildInputDecoration(
                  icon: Icons.emoji_nature,
                  hintText: 'Selecciona una variedad',
                  theme: theme,
                  isDark: isDark,
                ),
                items: _coffeeVarietyOptions.map((option) {
                  return DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _farm.mainVariety = value ?? ''),
                validator: (value) =>
                (value == null || value.isEmpty) ? 'Por favor selecciona una variedad' : null,
              ),
            ),

            const SizedBox(height: 20),

            Text('Año de establecimiento', style: labelStyle),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: insetCardColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.06)
                      : AppTheme.darkCoffee.withOpacity(0.06),
                  width: 0.5,
                ),
                boxShadow: const [],
              ),
              child: DropdownButtonFormField<int>(
                value: _farm.establishmentYear > 0 ? _farm.establishmentYear : null,
                dropdownColor: isDark ? AppTheme.coffeeDeep : const Color(0xFFF0E8D8),
                style: TextStyle(color: textColor),
                hint: Text(
                  'Selecciona un año',
                  style: TextStyle(color: textColor.withOpacity(0.4)),
                ),
                decoration: _buildInputDecoration(
                  icon: Icons.date_range,
                  hintText: 'Selecciona un año',
                  theme: theme,
                  isDark: isDark,
                ),
                items: List.generate(100, (index) {
                  final year = DateTime.now().year - index;
                  return DropdownMenuItem(
                    value: year,
                    child: Text(year.toString()),
                  );
                }),
                onChanged: (value) => setState(() => _farm.establishmentYear = value ?? DateTime.now().year),
                validator: (value) =>
                (value == null) ? 'Por favor selecciona un año' : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}