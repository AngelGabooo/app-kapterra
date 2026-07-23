// lib/core/models/appointment_model.dart
class AppointmentModel {
  final String id;
  final String clientName;
  final String clientPhone;
  final String clientEmail;
  final String producerId;
  final String producerName;
  final DateTime date;
  final String reason;
  final String status; // 'pending', 'confirmed', 'cancelled', 'completed'
  final String? notes;
  final DateTime createdAt;

  AppointmentModel({
    required this.id,
    required this.clientName,
    required this.clientPhone,
    required this.clientEmail,
    required this.producerId,
    required this.producerName,
    required this.date,
    required this.reason,
    this.status = 'pending',
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'clientName': clientName,
    'clientPhone': clientPhone,
    'clientEmail': clientEmail,
    'producerId': producerId,
    'producerName': producerName,
    'date': date.toIso8601String(),
    'reason': reason,
    'status': status,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
  };

  factory AppointmentModel.fromJson(Map<String, dynamic> json) => AppointmentModel(
    id: json['id'],
    clientName: json['clientName'],
    clientPhone: json['clientPhone'],
    clientEmail: json['clientEmail'],
    producerId: json['producerId'],
    producerName: json['producerName'],
    date: DateTime.parse(json['date']),
    reason: json['reason'],
    status: json['status'] ?? 'pending',
    notes: json['notes'],
    createdAt: DateTime.parse(json['createdAt']),
  );

  AppointmentModel copyWith({
    String? status,
    String? notes,
  }) => AppointmentModel(
    id: id,
    clientName: clientName,
    clientPhone: clientPhone,
    clientEmail: clientEmail,
    producerId: producerId,
    producerName: producerName,
    date: date,
    reason: reason,
    status: status ?? this.status,
    notes: notes ?? this.notes,
    createdAt: createdAt,
  );
}