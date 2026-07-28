// lib/core/providers/technician_contact_provider.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/features/dashboard/data/models/technician_contact_request_model.dart';

class TechnicianContactProvider extends ChangeNotifier {
  final List<TechnicianContactRequestModel> _requests = [];

  List<TechnicianContactRequestModel> get requests => List.unmodifiable(_requests);

  List<TechnicianContactRequestModel> get pendingRequests =>
      _requests.where((r) => r.status == 'pending').toList();

  List<TechnicianContactRequestModel> get acceptedRequests =>
      _requests.where((r) => r.status == 'accepted').toList();

  int get pendingCount => pendingRequests.length;

  void addRequest(TechnicianContactRequestModel request) {
    _requests.insert(0, request);
    notifyListeners();
  }

  void updateRequestStatus(String id, String status, {String? cooperativeName, String? technicianId}) {
    final index = _requests.indexWhere((r) => r.id == id);
    if (index != -1) {
      _requests[index] = _requests[index].copyWith(
        status: status,
        cooperativeName: cooperativeName,
        technicianId: technicianId,
      );
      notifyListeners();
    }
  }

  void clearAll() {
    _requests.clear();
    notifyListeners();
  }
}