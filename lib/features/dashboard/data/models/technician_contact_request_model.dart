// lib/features/dashboard/data/models/technician_contact_request_model.dart
class TechnicianContactRequestModel {
  final String id;
  final String technicianName;
  final String technicianEmail;
  final String technicianPhone;
  final String specialty;
  final String message;
  final DateTime requestDate;
  final String status; // 'pending', 'accepted', 'rejected'
  final String? cooperativeName;
  final String? technicianId;

  TechnicianContactRequestModel({
    required this.id,
    required this.technicianName,
    required this.technicianEmail,
    required this.technicianPhone,
    required this.specialty,
    required this.message,
    required this.requestDate,
    required this.status,
    this.cooperativeName,
    this.technicianId,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'technicianName': technicianName,
    'technicianEmail': technicianEmail,
    'technicianPhone': technicianPhone,
    'specialty': specialty,
    'message': message,
    'requestDate': requestDate.toIso8601String(),
    'status': status,
    'cooperativeName': cooperativeName,
    'technicianId': technicianId,
  };

  factory TechnicianContactRequestModel.fromJson(Map<String, dynamic> json) => TechnicianContactRequestModel(
    id: json['id'],
    technicianName: json['technicianName'],
    technicianEmail: json['technicianEmail'],
    technicianPhone: json['technicianPhone'],
    specialty: json['specialty'],
    message: json['message'],
    requestDate: DateTime.parse(json['requestDate']),
    status: json['status'],
    cooperativeName: json['cooperativeName'],
    technicianId: json['technicianId'],
  );

  TechnicianContactRequestModel copyWith({
    String? status,
    String? cooperativeName,
    String? technicianId,
  }) {
    return TechnicianContactRequestModel(
      id: id,
      technicianName: technicianName,
      technicianEmail: technicianEmail,
      technicianPhone: technicianPhone,
      specialty: specialty,
      message: message,
      requestDate: requestDate,
      status: status ?? this.status,
      cooperativeName: cooperativeName ?? this.cooperativeName,
      technicianId: technicianId ?? this.technicianId,
    );
  }
}