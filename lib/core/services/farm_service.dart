// lib/core/services/farm_service.dart
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:kaabcafe/core/services/api_service.dart';
import 'package:kaabcafe/features/farms/data/models/api_farm_model.dart';
import 'package:kaabcafe/features/farms/data/models/create_farm_request.dart';

class FarmService {
  final ApiService _apiService = ApiService();

  // Crear una finca
  Future<ApiFarmModel> createFarm(CreateFarmRequest request) async {
    try {
      debugPrint('📤 Creando finca: ${request.name}');
      final response = await _apiService.post(
        '/api/farms',
        body: request.toJson(),
      );

      debugPrint('📥 Código de respuesta: ${response.statusCode}');
      debugPrint('📥 Cuerpo de respuesta: ${response.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return ApiFarmModel.fromJson(data);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Error al crear la finca');
      }
    } catch (e) {
      debugPrint('❌ Error al crear finca: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener todas las fincas de un productor
  Future<List<ApiFarmModel>> getFarmsByProducer(String producerEmail) async {
    try {
      debugPrint('📤 Obteniendo fincas de: $producerEmail');
      final response = await _apiService.get(
        '/api/farms/producer/$producerEmail',
      );

      debugPrint('📥 Código de respuesta: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map((json) => ApiFarmModel.fromJson(json)).toList();
        }
        return [];
      } else {
        return [];
      }
    } catch (e) {
      debugPrint('❌ Error al obtener fincas: $e');
      return [];
    }
  }

  // Actualizar una finca
  Future<ApiFarmModel> updateFarm(int farmId, CreateFarmRequest request) async {
    try {
      debugPrint('📤 Actualizando finca: $farmId');
      final response = await _apiService.put(
        '/api/farms/$farmId',
        body: request.toJson(),
      );

      debugPrint('📥 Código de respuesta: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiFarmModel.fromJson(data);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Error al actualizar la finca');
      }
    } catch (e) {
      debugPrint('❌ Error al actualizar finca: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  // Eliminar una finca
  Future<void> deleteFarm(int farmId) async {
    try {
      debugPrint('📤 Eliminando finca: $farmId');
      final response = await _apiService.delete(
        '/api/farms/$farmId',
      );

      debugPrint('📥 Código de respuesta: ${response.statusCode}');

      if (response.statusCode != 200 && response.statusCode != 204) {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Error al eliminar la finca');
      }
    } catch (e) {
      debugPrint('❌ Error al eliminar finca: $e');
      throw Exception('Error de conexión: $e');
    }
  }
}