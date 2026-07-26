import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/providers/farm_provider.dart';
import 'package:kaabcafe/core/providers/user_provider.dart';
import 'package:kaabcafe/core/providers/appointment_provider.dart';
import 'package:kaabcafe/core/routes/app_router.dart';
import 'package:kaabcafe/core/services/login_attempt_service.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/session_timeout_widget.dart';
import 'package:kaabcafe/features/activities/presentation/providers/activities_provider.dart';
import 'package:kaabcafe/core/services/notification_service.dart';
import 'package:kaabcafe/features/buyer/providers/cooperative_producers_provider.dart'; // ✅ AGREGAR
import 'package:kaabcafe/features/buyer/providers/technicians_provider.dart';
import 'package:kaabcafe/features/technician/providers/technician_producers_provider.dart';
import 'package:kaabcafe/features/technician/providers/technician_reports_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  debugPrint('✅ Firebase inicializado correctamente');

  final notificationService = NotificationService();
  await notificationService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ActivitiesProviderFactory.create()),
        ChangeNotifierProvider(create: (_) => FarmProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => LoginAttemptService()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
        ChangeNotifierProvider(create: (_) => CooperativeProducersProvider()), // ✅ AGREGAR
        ChangeNotifierProvider(create: (_) => TechniciansProvider()), // ✅ AGREGAR ESTA LÍNEA
        ChangeNotifierProvider(create: (_) => TechnicianProducersProvider()),
        ChangeNotifierProvider(create: (_) => TechnicianReportsProvider()),

      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        title: 'Kaab Terra',
        builder: (context, child) {
          return SessionTimeoutWidget(
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}