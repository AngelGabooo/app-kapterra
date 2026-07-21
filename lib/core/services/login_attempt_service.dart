// lib/core/services/login_attempt_service.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

// ✅ NOTA: No es necesario importar local_auth_android por separado
// local_auth ya lo incluye automáticamente

class LoginAttemptService extends ChangeNotifier {
  static const String _attemptsKey = 'login_attempts';
  static const String _blockedUntilKey = 'login_blocked_until';
  static const String _isPermanentlyBlockedKey = 'login_permanently_blocked';

  static const int _maxAttemptsBeforeShortBlock = 3;
  static const int _maxAttemptsBeforePermanentBlock = 6;
  static const Duration _shortBlockDuration = Duration(seconds: 30);

  final LocalAuthentication _localAuth = LocalAuthentication();

  int _attempts = 0;
  DateTime? _blockedUntil;
  bool _isPermanentlyBlocked = false;
  Timer? _countdownTimer;
  int _remainingSeconds = 0;

  // Getters
  int get attempts => _attempts;
  DateTime? get blockedUntil => _blockedUntil;
  bool get isPermanentlyBlocked => _isPermanentlyBlocked;
  int get remainingSeconds => _remainingSeconds;
  bool get isBlocked => _blockedUntil != null && DateTime.now().isBefore(_blockedUntil!);
  bool get isShortBlocked => isBlocked && !_isPermanentlyBlocked;

  LoginAttemptService() {
    _loadState();
  }

  // ============================================================
  // ✅ CARGA Y GUARDADO DE ESTADO
  // ============================================================

  Future<void> _loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _attempts = prefs.getInt(_attemptsKey) ?? 0;
      _isPermanentlyBlocked = prefs.getBool(_isPermanentlyBlockedKey) ?? false;

      final blockedUntilMillis = prefs.getInt(_blockedUntilKey);
      if (blockedUntilMillis != null) {
        _blockedUntil = DateTime.fromMillisecondsSinceEpoch(blockedUntilMillis);
        if (isBlocked) {
          _startCountdown();
        } else {
          _blockedUntil = null;
          await _saveState();
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error cargando estado de login: $e');
    }
  }

  Future<void> _saveState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_attemptsKey, _attempts);
      await prefs.setBool(_isPermanentlyBlockedKey, _isPermanentlyBlocked);

      if (_blockedUntil != null) {
        await prefs.setInt(_blockedUntilKey, _blockedUntil!.millisecondsSinceEpoch);
      } else {
        await prefs.remove(_blockedUntilKey);
      }
    } catch (e) {
      debugPrint('Error guardando estado de login: $e');
    }
  }

  // ============================================================
  // ✅ REGISTRO DE INTENTO
  // ============================================================

  Future<(bool, bool, int?)> registerFailedAttempt() async {
    if (_isPermanentlyBlocked) {
      return (true, true, null);
    }

    if (isBlocked) {
      return (true, false, _remainingSeconds);
    }

    _attempts++;
    await _saveState();
    notifyListeners();

    debugPrint('🔐 Intentos fallidos: $_attempts de $_maxAttemptsBeforePermanentBlock');

    if (_attempts >= _maxAttemptsBeforePermanentBlock) {
      await _setPermanentBlock();
      return (true, true, null);
    }

    if (_attempts >= _maxAttemptsBeforeShortBlock) {
      await _setTemporaryBlock();
      return (true, false, _remainingSeconds);
    }

    return (false, false, null);
  }

  // ============================================================
  // ✅ BLOQUEOS
  // ============================================================

  Future<void> _setTemporaryBlock() async {
    _blockedUntil = DateTime.now().add(_shortBlockDuration);
    await _saveState();
    _startCountdown();
    notifyListeners();
    debugPrint('🔒 Bloqueo temporal de 30 segundos activado (intentos: $_attempts)');
  }

  Future<void> _setPermanentBlock() async {
    _isPermanentlyBlocked = true;
    _blockedUntil = null;
    _countdownTimer?.cancel();
    _remainingSeconds = 0;
    await _saveState();
    notifyListeners();
    debugPrint('🔒 Bloqueo permanente activado - Se requiere PIN del dispositivo');
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _remainingSeconds = _shortBlockDuration.inSeconds;

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_blockedUntil == null) {
        timer.cancel();
        return;
      }

      final now = DateTime.now();
      if (now.isAfter(_blockedUntil!)) {
        _blockedUntil = null;
        _remainingSeconds = 0;
        _saveState();
        timer.cancel();
        notifyListeners();
        debugPrint('🔓 Bloqueo temporal terminado. Intentos actuales: $_attempts');
      } else {
        _remainingSeconds = _blockedUntil!.difference(now).inSeconds;
        if (_remainingSeconds < 0) _remainingSeconds = 0;
        notifyListeners();
      }
    });
  }

  // ============================================================
  // ✅ AUTENTICACIÓN CON PIN DEL DISPOSITIVO
  // ============================================================

  Future<bool> canCheckBiometric() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return canCheck || isDeviceSupported;
    } catch (e) {
      debugPrint('Error verificando soporte biométrico: $e');
      return false;
    }
  }

  Future<Map<String, bool>> getAvailableAuthMethods() async {
    try {
      final isSupported = await _localAuth.isDeviceSupported();
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final availableBiometrics = await _localAuth.getAvailableBiometrics();

      return {
        'isSupported': isSupported,
        'canCheckBiometrics': canCheckBiometrics,
        'hasFingerprint': availableBiometrics.contains(BiometricType.fingerprint),
        'hasFace': availableBiometrics.contains(BiometricType.face),
        'hasIris': availableBiometrics.contains(BiometricType.iris),
        'hasPin': true,
      };
    } catch (e) {
      debugPrint('Error obteniendo métodos de autenticación: $e');
      return {
        'isSupported': false,
        'canCheckBiometrics': false,
        'hasFingerprint': false,
        'hasFace': false,
        'hasIris': false,
        'hasPin': false,
      };
    }
  }

  /// ✅ Autenticación solo con PIN (FORZADO - sin biometría)
  Future<bool> authenticateWithPinOnly() async {
    try {
      debugPrint('🔐 Intentando autenticación solo con PIN...');

      // ✅ Versión simplificada - sin androidOptions para evitar errores
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Ingresa tu PIN de seguridad (1-6)',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
          sensitiveTransaction: true,
        ),
      );

      if (authenticated) {
        await resetBlock();
        debugPrint('✅ Autenticación con PIN exitosa');
        return true;
      }

      debugPrint('❌ Autenticación con PIN fallida');
      return false;
    } catch (e) {
      debugPrint('❌ Error en autenticación con PIN: $e');

      if (e.toString().contains('canceled') ||
          e.toString().contains('cancelled') ||
          e.toString().contains('user_cancel')) {
        debugPrint('ℹ️ Usuario canceló la autenticación');
        return false;
      }

      return false;
    }
  }

  /// ✅ Autenticación con PIN del dispositivo (intenta PIN primero, luego biometría)
  Future<bool> authenticateWithDevicePin() async {
    try {
      // Verificar si el dispositivo soporta autenticación
      final isSupported = await _localAuth.isDeviceSupported();
      if (!isSupported) {
        debugPrint('❌ Dispositivo no soporta autenticación');
        return false;
      }

      // ✅ PRIMERO: Intentar con PIN (sin biometría)
      debugPrint('🔐 Intentando autenticación con PIN...');

      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Ingresa tu PIN de seguridad (1-6)',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
          sensitiveTransaction: true,
        ),
      );

      if (authenticated) {
        await resetBlock();
        debugPrint('✅ Autenticación con PIN exitosa');
        return true;
      }

      // ✅ SEGUNDO: Si falla el PIN, intentar con biometría como respaldo
      debugPrint('🔐 Intentando autenticación con biometría (respaldo)...');

      final biometricAuth = await _localAuth.authenticate(
        localizedReason: 'Usa tu huella o Face ID',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          sensitiveTransaction: true,
        ),
      );

      if (biometricAuth) {
        await resetBlock();
        debugPrint('✅ Autenticación biométrica exitosa');
        return true;
      }

      debugPrint('❌ Todas las autenticaciones fallaron');
      return false;
    } catch (e) {
      debugPrint('❌ Error en autenticación: $e');

      if (e.toString().contains('canceled') ||
          e.toString().contains('cancelled') ||
          e.toString().contains('user_cancel')) {
        debugPrint('ℹ️ Usuario canceló la autenticación');
        return false;
      }

      return false;
    }
  }

  // ============================================================
  // ✅ RESETEO
  // ============================================================

  Future<void> resetBlock() async {
    _attempts = 0;
    _isPermanentlyBlocked = false;
    _blockedUntil = null;
    _remainingSeconds = 0;
    _countdownTimer?.cancel();
    await _saveState();
    notifyListeners();
    debugPrint('✅ Bloqueo reseteado exitosamente');
  }

  Future<void> manualReset() async {
    await resetBlock();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }
}