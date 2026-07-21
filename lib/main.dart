// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/providers/farm_provider.dart';
import 'package:kaabcafe/core/providers/user_provider.dart';
import 'package:kaabcafe/core/routes/app_router.dart';
import 'package:kaabcafe/core/services/login_attempt_service.dart'; // ✅ NUEVO
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/session_timeout_widget.dart';
import 'package:kaabcafe/features/activities/presentation/providers/activities_provider.dart';

void main() {
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
        ChangeNotifierProvider(create: (_) => LoginAttemptService()), // ✅ NUEVO
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