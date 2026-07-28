// lib/features/farms/data/models/create_farm_request.dart
class CreateFarmRequest {
  final String name;
  final String location;
  final double hectares;
  final int lots;
  final double productivity;
  final String status;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final int altitude;
  final int? establishmentYear;
  final String? mainVariety;
  final String? productionSystem;
  final List<String>? certifications;
  final String producerEmail;

  CreateFarmRequest({
    required this.name,
    required this.location,
    required this.hectares,
    required this.lots,
    required this.productivity,
    required this.status,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.altitude,
    this.establishmentYear,
    this.mainVariety,
    this.productionSystem,
    this.certifications,
    required this.producerEmail,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'hectares': hectares,
      'lots': lots,
      'productivity': productivity,
      'status': status,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'establishmentYear': establishmentYear,
      'mainVariety': mainVariety,
      'productionSystem': productionSystem,
      'certifications': certifications,
      'producerEmail': producerEmail,
    };
  }
}