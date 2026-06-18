import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/farm/data/models/farm_model.dart';

class FarmForm extends StatefulWidget {
  final Function(FarmModel) onSave;

  const FarmForm({super.key, required this.onSave});

  @override
  State<FarmForm> createState() => FarmFormState();
}

// ✅ Exportar el State para poder llamar métodos desde fuera
class FarmFormState extends State<FarmForm> {
  final _formKey = GlobalKey<FormState>();
  late FarmModel _farm;

  final _coffeeVarietyOptions = [
    'Arábica',
    'Robusta',
    'Bourbon',
    'Typica',
    'Catuaí',
    'Geisha',
    'Otra',
  ];

  @override
  void initState() {
    super.initState();
    _farm = FarmModel();
  }

  // ✅ Método público para submit del formulario
  void submitForm() {
    if (_formKey.currentState!.validate()) {
      _farm.createdAt = DateTime.now();
      widget.onSave(_farm);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nombre de la finca
          const Text(
            'Nombre de la finca',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkCoffee,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            onChanged: (value) => _farm.name = value,
            decoration: _buildInputDecoration(
              icon: Icons.agriculture,
              hintText: 'Ej. Finca El Mirador',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa el nombre de la finca';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Ubicación
          const Text(
            'Ubicación',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkCoffee,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            onChanged: (value) => _farm.location = value,
            decoration: _buildInputDecoration(
              icon: Icons.location_on_outlined,
              hintText: 'Seleccionar ubicación',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa la ubicación';
              }
              return null;
            },
          ),

          const SizedBox(height: 12),

          // Botón ubicación actual
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: Implementar obtener ubicación actual
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Funcionalidad de ubicación próximamente'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: Icon(Icons.my_location, color: AppTheme.primaryGreen),
              label: const Text('Usar ubicación actual'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryGreen,
                side: BorderSide(color: AppTheme.primaryGreen.withOpacity(0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Altitud
          const Text(
            'Altitud (msnm)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkCoffee,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            onChanged: (value) => _farm.altitude = int.tryParse(value) ?? 0,
            keyboardType: TextInputType.number,
            decoration: _buildInputDecoration(
              icon: Icons.height,
              hintText: 'Ej: 1200',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa la altitud';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Superficie total
          const Text(
            'Superficie total',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkCoffee,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            onChanged: (value) => _farm.surface = double.tryParse(value) ?? 0,
            keyboardType: TextInputType.number,
            decoration: _buildInputDecoration(
              icon: Icons.landscape,
              hintText: 'Ej: 5.5',
              suffixText: 'hectáreas',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa la superficie';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Número de lotes
          const Text(
            'Número aproximado de lotes',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkCoffee,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            onChanged: (value) => _farm.numberOfLots = int.tryParse(value) ?? 0,
            keyboardType: TextInputType.number,
            decoration: _buildInputDecoration(
              icon: Icons.view_module,
              hintText: 'Ej: 10',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa el número de lotes';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Variedad principal
          const Text(
            'Variedad principal cultivada',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkCoffee,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _farm.mainVariety.isEmpty ? null : _farm.mainVariety,
            hint: const Text('Selecciona una variedad'),
            decoration: _buildInputDecoration(
              icon: Icons.emoji_nature,
              hintText: 'Selecciona una variedad',
            ),
            items: _coffeeVarietyOptions.map((option) {
              return DropdownMenuItem(
                value: option,
                child: Text(option),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _farm.mainVariety = value ?? '';
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor selecciona una variedad';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Año de establecimiento
          const Text(
            'Año de establecimiento',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkCoffee,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<int>(
            value: _farm.establishmentYear,
            decoration: _buildInputDecoration(
              icon: Icons.date_range,
              hintText: 'Selecciona un año',
            ),
            items: List.generate(100, (index) {
              final year = DateTime.now().year - index;
              return DropdownMenuItem(
                value: year,
                child: Text(year.toString()),
              );
            }),
            onChanged: (value) {
              setState(() {
                _farm.establishmentYear = value ?? DateTime.now().year;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Por favor selecciona un año';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required IconData icon,
    required String hintText,
    String? suffixText,
  }) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: AppTheme.primaryGreen),
      hintText: hintText,
      suffixText: suffixText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: AppTheme.primaryGreen, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }
}