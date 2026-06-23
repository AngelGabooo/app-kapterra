import 'package:flutter/material.dart';
import 'package:kaabcafe/features/farm/data/models/farm_model.dart';

class FarmForm extends StatefulWidget {
  final Function(FarmModel) onSave;

  const FarmForm({super.key, required this.onSave});

  @override
  State<FarmForm> createState() => FarmFormState();
}

class FarmFormState extends State<FarmForm> {
  final _formKey = GlobalKey<FormState>();
  late FarmModel _farm;

  final _coffeeVarietyOptions = ['Arábica', 'Robusta', 'Bourbon', 'Typica', 'Catuaí', 'Geisha', 'Otra'];

  @override
  void initState() {
    super.initState();
    _farm = FarmModel();
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      _farm.createdAt = DateTime.now();
      widget.onSave(_farm);
    }
  }

  InputDecoration _buildInputDecoration({required IconData icon, required String hintText, String? suffixText, required ThemeData theme}) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: theme.colorScheme.secondary),
      hintText: hintText,
      suffixText: suffixText,
      suffixStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
      hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.4)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.15))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.15))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: theme.colorScheme.secondary, width: 2)),
      filled: true,
      fillColor: theme.colorScheme.surface,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface.withOpacity(0.9));

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nombre de la finca', style: labelStyle),
          const SizedBox(height: 8),
          TextFormField(
            onChanged: (value) => _farm.name = value,
            style: TextStyle(color: theme.colorScheme.onSurface),
            decoration: _buildInputDecoration(icon: Icons.agriculture, hintText: 'Ej. Finca El Mirador', theme: theme),
            validator: (value) => (value == null || value.isEmpty) ? 'Por favor ingresa el nombre de la finca' : null,
          ),

          const SizedBox(height: 20),

          Text('Ubicación', style: labelStyle),
          const SizedBox(height: 8),
          TextFormField(
            onChanged: (value) => _farm.location = value,
            style: TextStyle(color: theme.colorScheme.onSurface),
            decoration: _buildInputDecoration(icon: Icons.location_on_outlined, hintText: 'Seleccionar ubicación', theme: theme),
            validator: (value) => (value == null || value.isEmpty) ? 'Por favor ingresa la ubicación' : null,
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Funcionalidad de ubicación próximamente'), duration: Duration(seconds: 2)),
                );
              },
              icon: Icon(Icons.my_location, color: theme.colorScheme.secondary),
              label: const Text('Usar ubicación actual'),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.secondary,
                side: BorderSide(color: theme.colorScheme.secondary.withOpacity(0.5)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text('Altitud (msnm)', style: labelStyle),
          const SizedBox(height: 8),
          TextFormField(
            onChanged: (value) => _farm.altitude = int.tryParse(value) ?? 0,
            keyboardType: TextInputType.number,
            style: TextStyle(color: theme.colorScheme.onSurface),
            decoration: _buildInputDecoration(icon: Icons.height, hintText: 'Ej: 1200', theme: theme),
            validator: (value) => (value == null || value.isEmpty) ? 'Por favor ingresa la altitud' : null,
          ),

          const SizedBox(height: 20),

          Text('Superficie total', style: labelStyle),
          const SizedBox(height: 8),
          TextFormField(
            onChanged: (value) => _farm.surface = double.tryParse(value) ?? 0,
            keyboardType: TextInputType.number,
            style: TextStyle(color: theme.colorScheme.onSurface),
            decoration: _buildInputDecoration(icon: Icons.landscape, hintText: 'Ej: 5.5', suffixText: 'hectáreas', theme: theme),
            validator: (value) => (value == null || value.isEmpty) ? 'Por favor ingresa la superficie' : null,
          ),

          const SizedBox(height: 20),

          Text('Número aproximado de lotes', style: labelStyle),
          const SizedBox(height: 8),
          TextFormField(
            onChanged: (value) => _farm.numberOfLots = int.tryParse(value) ?? 0,
            keyboardType: TextInputType.number,
            style: TextStyle(color: theme.colorScheme.onSurface),
            decoration: _buildInputDecoration(icon: Icons.view_module, hintText: 'Ej: 10', theme: theme),
            validator: (value) => (value == null || value.isEmpty) ? 'Por favor ingresa el número de lotes' : null,
          ),

          const SizedBox(height: 20),

          Text('Variedad principal cultivada', style: labelStyle),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _farm.mainVariety.isEmpty ? null : _farm.mainVariety,
            dropdownColor: theme.colorScheme.surface,
            style: TextStyle(color: theme.colorScheme.onSurface),
            hint: const Text('Selecciona una variedad'),
            decoration: _buildInputDecoration(icon: Icons.emoji_nature, hintText: 'Selecciona una variedad', theme: theme),
            items: _coffeeVarietyOptions.map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
            onChanged: (value) => setState(() => _farm.mainVariety = value ?? ''),
            validator: (value) => (value == null || value.isEmpty) ? 'Por favor selecciona una variedad' : null,
          ),

          const SizedBox(height: 20),

          Text('Año de establecimiento', style: labelStyle),
          const SizedBox(height: 8),
          DropdownButtonFormField<int>(
            value: _farm.establishmentYear,
            dropdownColor: theme.colorScheme.surface,
            style: TextStyle(color: theme.colorScheme.onSurface),
            decoration: _buildInputDecoration(icon: Icons.date_range, hintText: 'Selecciona un año', theme: theme),
            items: List.generate(100, (index) {
              final year = DateTime.now().year - index;
              return DropdownMenuItem(value: year, child: Text(year.toString()));
            }),
            onChanged: (value) => setState(() => _farm.establishmentYear = value ?? DateTime.now().year),
            validator: (value) => (value == null) ? 'Por favor selecciona un año' : null,
          ),
        ],
      ),
    );
  }
}