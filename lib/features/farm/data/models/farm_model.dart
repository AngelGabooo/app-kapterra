class FarmModel {
  String name;
  String location;
  double? latitude;
  double? longitude;
  int altitude;
  double surface;
  int numberOfLots;
  String mainVariety;
  int establishmentYear;
  DateTime? createdAt;

  FarmModel({
    this.name = '',
    this.location = '',
    this.latitude,
    this.longitude,
    this.altitude = 0,
    this.surface = 0,
    this.numberOfLots = 0,
    this.mainVariety = '',
    this.establishmentYear = 2024, // ✅ Valor constante, no DateTime.now()
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'surface': surface,
      'numberOfLots': numberOfLots,
      'mainVariety': mainVariety,
      'establishmentYear': establishmentYear,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  FarmModel copyWith({
    String? name,
    String? location,
    double? latitude,
    double? longitude,
    int? altitude,
    double? surface,
    int? numberOfLots,
    String? mainVariety,
    int? establishmentYear,
    DateTime? createdAt,
  }) {
    return FarmModel(
      name: name ?? this.name,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitude: altitude ?? this.altitude,
      surface: surface ?? this.surface,
      numberOfLots: numberOfLots ?? this.numberOfLots,
      mainVariety: mainVariety ?? this.mainVariety,
      establishmentYear: establishmentYear ?? this.establishmentYear,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}