// lib/features/dashboard/data/models/notification_model.dart
class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type; // 'visit_scheduled', 'visit_reminder', 'diagnosis_completed'
  final DateTime date;
  final bool isRead;
  final Map<String, dynamic>? data;
  final String? senderName;
  final String? senderId;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.date,
    this.isRead = false,
    this.data,
    this.senderName,
    this.senderId,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? type,
    DateTime? date,
    bool? isRead,
    Map<String, dynamic>? data,
    String? senderName,
    String? senderId,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      date: date ?? this.date,
      isRead: isRead ?? this.isRead,
      data: data ?? this.data,
      senderName: senderName ?? this.senderName,
      senderId: senderId ?? this.senderId,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'message': message,
    'type': type,
    'date': date.toIso8601String(),
    'isRead': isRead,
    'data': data,
    'senderName': senderName,
    'senderId': senderId,
  };

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    id: json['id'],
    title: json['title'],
    message: json['message'],
    type: json['type'],
    date: DateTime.parse(json['date']),
    isRead: json['isRead'] ?? false,
    data: json['data'],
    senderName: json['senderName'],
    senderId: json['senderId'],
  );
}