// lib/features/technician/presentation/widgets/lot_inspection/environmental_conditions.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';

class EnvironmentalConditions extends StatelessWidget {
  final bool isDark;
  final double temperature;
  final double humidity;
  final int weatherCondition;
  final int shadeLevel;
  final int irrigationStatus;
  final Function(double) onTemperatureChanged;
  final Function(double) onHumidityChanged;
  final Function(int) onWeatherChanged;
  final Function(int) onShadeChanged;
  final Function(int) onIrrigationChanged;

  const EnvironmentalConditions({
    super.key,
    required this.isDark,
    required this.temperature,
    required this.humidity,
    required this.weatherCondition,
    required this.shadeLevel,
    required this.irrigationStatus,
    required this.onTemperatureChanged,
    required this.onHumidityChanged,
    required this.onWeatherChanged,
    required this.onShadeChanged,
    required this.onIrrigationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final weatherOptions = ['Soleado', 'Nublado', 'Lluvioso', 'Ventoso'];
    final shadeOptions = ['Bajo', 'Medio', 'Alto'];
    final irrigationOptions = ['Correcto', 'Excesivo', 'Deficiente'];

    return NeumorphicBox(
      isDark: isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          _buildSliderRow('🌡 Temperatura', temperature, 15, 40, onTemperatureChanged, '°C', textColor),
          const SizedBox(height: 12),
          _buildSliderRow('💧 Humedad', humidity, 20, 100, onHumidityChanged, '%', textColor),
          const SizedBox(height: 12),
          _buildDropdownRow('🌦 Condiciones', weatherCondition, weatherOptions, onWeatherChanged, textColor),
          const SizedBox(height: 12),
          _buildDropdownRow('🌳 Nivel de sombra', shadeLevel, shadeOptions, onShadeChanged, textColor),
          const SizedBox(height: 12),
          _buildDropdownRow('💦 Estado del riego', irrigationStatus, irrigationOptions, onIrrigationChanged, textColor),
        ],
      ),
    );
  }

  Widget _buildSliderRow(
      String label,
      double value,
      double min,
      double max,
      Function(double) onChanged,
      String unit,
      Color textColor,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: textColor.withOpacity(0.7),
              ),
            ),
            const Spacer(),
            Text(
              '${value.toInt()}$unit',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryGreen,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          activeColor: AppTheme.primaryGreen,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDropdownRow(
      String label,
      int value,
      List<String> options,
      Function(int) onChanged,
      Color textColor,
      ) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: textColor.withOpacity(0.7),
            ),
          ),
        ),
        Expanded(
          child: DropdownButtonFormField<int>(
            value: value,
            isExpanded: true,
            dropdownColor: isDark ? AppTheme.coffeeDeep : Colors.white,
            style: TextStyle(color: textColor, fontSize: 12),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: textColor.withOpacity(0.1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: textColor.withOpacity(0.1)),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              isDense: true,
            ),
            items: options.asMap().entries.map((e) {
              return DropdownMenuItem(
                value: e.key,
                child: Text(e.value),
              );
            }).toList(),
            onChanged: (v) => onChanged(v ?? 0),
          ),
        ),
      ],
    );
  }
}