// lib/features/buyer/presentation/widgets/cooperative_map_preview.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/buyer/providers/cooperative_producers_provider.dart';
import 'package:kaabcafe/features/buyer/data/models/producer_summary_model.dart';

class CooperativeMapPreview extends StatelessWidget {
  final bool isDark;
  final bool hasData;

  const CooperativeMapPreview({
    super.key,
    required this.isDark,
    required this.hasData,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    // ✅ OBTENER PRODUCTORES DEL PROVIDER
    final producersProvider = Provider.of<CooperativeProducersProvider>(context);
    final producers = producersProvider.producers;

    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Mapa simulado
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    isDark ? AppTheme.coffeeMedium.withOpacity(0.3) : AppTheme.primaryGreen.withOpacity(0.2),
                    isDark ? AppTheme.coffeeWarm.withOpacity(0.2) : AppTheme.secondaryGreen.withOpacity(0.1),
                  ],
                ),
              ),
              child: producers.isNotEmpty
                  ? _buildMapWithData(producers)
                  : _buildEmptyMap(isDark, textColor),
            ),
            // Leyenda
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildLegendDot(Colors.green, 'Normal'),
                    const SizedBox(width: 8),
                    _buildLegendDot(Colors.orange, 'Atención'),
                    const SizedBox(width: 8),
                    _buildLegendDot(Colors.red, 'Riesgo'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ MAPA CON DATOS REALES DE PRODUCTORES
  Widget _buildMapWithData(List<ProducerSummaryModel> producers) {
    // ✅ Agrupar productores por ubicación y calcular estadísticas
    final Map<String, Map<String, dynamic>> locations = {};

    for (final producer in producers) {
      final location = producer.location ?? 'Sin ubicación';

      if (!locations.containsKey(location)) {
        locations[location] = {
          'count': 0,
          'status': _getProducerStatus(producer),
          'emoji': _getStatusEmoji(producer),
        };
      }

      locations[location]!['count'] = (locations[location]!['count'] as int) + 1;

      // ✅ Actualizar el estado si hay algún productor con estado más crítico
      final currentStatus = locations[location]!['status'] as String;
      final producerStatus = _getProducerStatus(producer);

      if (producerStatus == 'Riesgo' || (producerStatus == 'Atención' && currentStatus != 'Riesgo')) {
        locations[location]!['status'] = producerStatus;
        locations[location]!['emoji'] = _getStatusEmojiByStatus(producerStatus);
      }
    }

    // ✅ Tomar las ubicaciones más relevantes (hasta 5)
    final topLocations = locations.entries
        .sorted((a, b) => (b.value['count'] as int).compareTo(a.value['count'] as int))
        .take(5)
        .toList();

    // ✅ Calcular total de productores
    final totalProducers = producers.length;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ✅ Mostrar ubicaciones con productores
        Wrap(
          spacing: 16,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: topLocations.map((entry) {
            final location = entry.key;
            final data = entry.value;
            final count = data['count'] as int;
            final emoji = data['emoji'] as String;
            final status = data['status'] as String;

            return _buildMarker(
              emoji,
              location.length > 12 ? '${location.substring(0, 12)}...' : location,
              count,
              status,
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        // ✅ Mostrar total de productores
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '👨‍🌾 $totalProducers productores',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '📍 ${topLocations.length} ubicaciones',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ✅ OBTENER ESTADO DEL PRODUCTOR
  String _getProducerStatus(ProducerSummaryModel producer) {
    // Si el productor tiene campos de estado de salud, usarlos
    if (producer.averageQuality > 80) {
      return 'Normal';
    } else if (producer.averageQuality > 60) {
      return 'Atención';
    } else {
      return 'Riesgo';
    }
  }

  // ✅ OBTENER EMOJI SEGÚN ESTADO DEL PRODUCTOR
  String _getStatusEmoji(ProducerSummaryModel producer) {
    final status = _getProducerStatus(producer);
    return _getStatusEmojiByStatus(status);
  }

  String _getStatusEmojiByStatus(String status) {
    switch (status) {
      case 'Normal':
        return '🟢';
      case 'Atención':
        return '🟠';
      case 'Riesgo':
        return '🔴';
      default:
        return '🟢';
    }
  }

  // ✅ MAPA VACÍO
  Widget _buildEmptyMap(bool isDark, Color textColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.map_outlined,
            size: 40,
            color: textColor.withOpacity(0.2),
          ),
          const SizedBox(height: 8),
          Text(
            'Sin productores registrados',
            style: TextStyle(
              fontSize: 13,
              color: textColor.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Los productores aparecerán en el mapa cuando se registren',
            style: TextStyle(
              fontSize: 11,
              color: textColor.withOpacity(0.25),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ MARCADOR DE UBICACIÓN
  Widget _buildMarker(String emoji, String label, int count, String status) {
    final color = status == 'Normal'
        ? Colors.green
        : status == 'Atención'
        ? Colors.orange
        : Colors.red;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            if (count > 1)
              Positioned(
                top: -4,
                right: -8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  // ✅ LEYENDA
  Widget _buildLegendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 8,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

// ✅ EXTENSIÓN PARA SORTEAR MAPAS
extension MapEntrySort<K, V> on Iterable<MapEntry<K, V>> {
  List<MapEntry<K, V>> sorted(int Function(MapEntry<K, V>, MapEntry<K, V>) compare) {
    return toList()..sort(compare);
  }
}