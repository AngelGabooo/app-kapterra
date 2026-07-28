// lib/features/dashboard/data/models/cooperative_contact_request_model.dart
class CooperativeContactRequestModel {
  final String id;
  final String producerName;
  final String producerEmail;
  final String producerPhone;
  final String farmName;
  final String location;
  final String message;
  final DateTime requestDate;
  final String status; // 'pending', 'accepted', 'rejected'
  final String? cooperativeName;

  CooperativeContactRequestModel({
    required this.id,
    required this.producerName,
    required this.producerEmail,
    required this.producerPhone,
    required this.farmName,
    required this.location,
    required this.message,
    required this.requestDate,
    required this.status,
    this.cooperativeName,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'producerName': producerName,
    'producerEmail': producerEmail,
    'producerPhone': producerPhone,
    'farmName': farmName,
    'location': location,
    'message': message,
    'requestDate': requestDate.toIso8601String(),
    'status': status,
    'cooperativeName': cooperativeName,
  };

  factory CooperativeContactRequestModel.fromJson(Map<String, dynamic> json) => CooperativeContactRequestModel(
    id: json['id'],
    producerName: json['producerName'],
    producerEmail: json['producerEmail'],
    producerPhone: json['producerPhone'],
    farmName: json['farmName'],
    location: json['location'],
    message: json['message'],
    requestDate: DateTime.parse(json['requestDate']),
    status: json['status'],
    cooperativeName: json['cooperativeName'],
  );

  CooperativeContactRequestModel copyWith({
    String? status,
    String? cooperativeName,
  }) {
    return CooperativeContactRequestModel(
      id: id,
      producerName: producerName,
      producerEmail: producerEmail,
      producerPhone: producerPhone,
      farmName: farmName,
      location: location,
      message: message,
      requestDate: requestDate,
      status: status ?? this.status,
      cooperativeName: cooperativeName ?? this.cooperativeName,
    );
  }
}