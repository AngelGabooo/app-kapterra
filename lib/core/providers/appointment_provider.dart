// lib/core/providers/appointment_provider.dart
import 'package:flutter/material.dart';
import '../models/appointment_model.dart';

class AppointmentProvider extends ChangeNotifier {
  List<AppointmentModel> _pendingAppointments = [];

  List<AppointmentModel> get pendingAppointments => _pendingAppointments;

  void addAppointment(AppointmentModel appointment) {
    _pendingAppointments.add(appointment);
    notifyListeners();
  }

  void confirmAppointment(String id) {
    final index = _pendingAppointments.indexWhere((a) => a.id == id);
    if (index != -1) {
      _pendingAppointments[index] = _pendingAppointments[index].copyWith(
        status: 'confirmed',
      );
      notifyListeners();
    }
  }

  void removeAppointment(String id) {
    _pendingAppointments.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  void clearAll() {
    _pendingAppointments.clear();
    notifyListeners();
  }
}