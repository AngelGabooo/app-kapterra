// lib/core/providers/cooperative_contact_provider.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/features/dashboard/data/models/cooperative_contact_request_model.dart';

class CooperativeContactProvider extends ChangeNotifier {
  final List<CooperativeContactRequestModel> _requests = [];

  List<CooperativeContactRequestModel> get requests => List.unmodifiable(_requests);

  List<CooperativeContactRequestModel> get pendingRequests =>
      _requests.where((r) => r.status == 'pending').toList();

  List<CooperativeContactRequestModel> get acceptedRequests =>
      _requests.where((r) => r.status == 'accepted').toList();

  int get pendingCount => pendingRequests.length;

  void addRequest(CooperativeContactRequestModel request) {
    _requests.insert(0, request);

    // ✅ Cuando se agrega una solicitud, automáticamente se crea un productor en la cooperativa
    _onNewContactRequest(request);

    notifyListeners();
  }

  // ✅ Método que se ejecuta cuando llega una nueva solicitud
  void _onNewContactRequest(CooperativeContactRequestModel request) {
    // Aquí notificamos a quien esté escuchando que hay un nuevo productor
    // El CooperativeProducersProvider escuchará este evento
  }

  void updateRequestStatus(String id, String status, {String? cooperativeName}) {
    final index = _requests.indexWhere((r) => r.id == id);
    if (index != -1) {
      final updated = _requests[index].copyWith(
        status: status,
        cooperativeName: cooperativeName,
      );
      _requests[index] = updated;

      // ✅ Si se acepta, notificar que el productor ha sido aceptado
      if (status == 'accepted') {
        _onRequestAccepted(updated);
      }

      notifyListeners();
    }
  }

  // ✅ Cuando se acepta una solicitud
  void _onRequestAccepted(CooperativeContactRequestModel request) {
    // Notificar que el productor fue aceptado
    // El CooperativeProducersProvider escuchará este evento
  }

  void clearAll() {
    _requests.clear();
    notifyListeners();
  }
}