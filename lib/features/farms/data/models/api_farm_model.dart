// lib/features/farms/data/models/api_farm_model.dart
class ApiFarmModel {
  final int id;
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

  ApiFarmModel({
    required this.id,
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

  factory ApiFarmModel.fromJson(Map<String, dynamic> json) {
    return ApiFarmModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      hectares: (json['hectares'] ?? 0).toDouble(),
      lots: json['lots'] ?? 0,
      productivity: (json['productivity'] ?? 0).toDouble(),
      status: json['status'] ?? 'healthy',
      imageUrl: json['imageUrl'] ?? 'assets/img/default_farm.png',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      altitude: json['altitude'] ?? 0,
      establishmentYear: json['establishmentYear'],
      mainVariety: json['mainVariety'],
      productionSystem: json['productionSystem'],
      certifications: json['certifications'] != null
          ? List<String>.from(json['certifications'])
          : null,
      producerEmail: json['producerEmail'] ?? '',
    );
  }

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
