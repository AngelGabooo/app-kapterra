import 'package:flutter/material.dart';

enum MessageType {
  text,
  offer,
  document,
  system,
}

class MessageModel {
  final String id;
  final String senderName;
  final String senderRole;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  final bool isFromBuyer;
  final bool isRead;
  final Map<String, dynamic>? metadata;

  MessageModel({
    required this.id,
    required this.senderName,
    required this.senderRole,
    required this.content,
    required this.timestamp,
    required this.type,
    required this.isFromBuyer,
    this.isRead = false,
    this.metadata,
  });
}