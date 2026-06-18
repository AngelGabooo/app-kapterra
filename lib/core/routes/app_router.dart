import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ==================== SCREENS ====================
import 'package:kaabcafe/features/splash/presentation/screens/splash_screen.dart';
import 'package:kaabcafe/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:kaabcafe/features/auth/presentation/screens/login_screen.dart';
import 'package:kaabcafe/features/auth/presentation/screens/register_screen.dart';
import 'package:kaabcafe/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:kaabcafe/features/auth/presentation/screens/select_user_type_screen.dart';
import 'package:kaabcafe/features/auth/presentation/screens/setup_profile_screen.dart';

import 'package:kaabcafe/features/farm/presentation/screens/register_farm_screen.dart';
import 'package:kaabcafe/features/farm/presentation/screens/farm_success_screen.dart';

import 'package:kaabcafe/features/dashboard/presentation/screens/dashboard_screen.dart';

import 'package:kaabcafe/features/farms/presentation/screens/my_farms_screen.dart';
import 'package:kaabcafe/features/farms/presentation/screens/farm_detail_screen.dart';
import 'package:kaabcafe/features/farms/presentation/screens/edit_farm_screen.dart';
import 'package:kaabcafe/features/farms/presentation/screens/lot_detail_screen.dart';
import 'package:kaabcafe/features/farms/presentation/screens/edit_lot_screen.dart';
import 'package:kaabcafe/features/farms/presentation/screens/create_lot_screen.dart';
import 'package:kaabcafe/features/farms/presentation/screens/lot_history_screen.dart';

import 'package:kaabcafe/features/activities/presentation/screens/register_activity_screen.dart';
import 'package:kaabcafe/features/activities/presentation/screens/activities_list_screen.dart';

import 'package:kaabcafe/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:kaabcafe/features/profile/presentation/screens/profile_screen.dart';
import 'package:kaabcafe/features/costs/presentation/screens/costs_list_screen.dart';

// ==================== MODELS ====================
import 'package:kaabcafe/features/farms/data/models/farm_details_model.dart';
import 'package:kaabcafe/features/farms/data/models/lot_model.dart';

// ==================== CORE ====================
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

import '../../features/activities/data/models/activity_model.dart';
import '../../features/activities/presentation/screens/edit_activity_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        name: RouteNames.splash,
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        name: RouteNames.onboarding,
        path: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        name: RouteNames.login,
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: RouteNames.register,
        path: RouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        name: RouteNames.forgotPassword,
        path: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        name: RouteNames.selectUserType,
        path: RouteNames.selectUserType,
        builder: (context, state) => const SelectUserTypeScreen(),
      ),
      GoRoute(
        name: RouteNames.setupProfile,
        path: RouteNames.setupProfile,
        builder: (context, state) => const SetupProfileScreen(),
      ),
      GoRoute(
        name: RouteNames.registerFarm,
        path: RouteNames.registerFarm,
        builder: (context, state) => const RegisterFarmScreen(),
      ),
      GoRoute(
        name: RouteNames.farmSuccess,
        path: RouteNames.farmSuccess,
        builder: (context, state) {
          final farmName = state.extra as String? ?? 'tu finca';
          return FarmSuccessScreen(farmName: farmName);
        },
      ),
      GoRoute(
        name: RouteNames.dashboard,
        path: RouteNames.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        name: RouteNames.myFarms,
        path: RouteNames.myFarms,
        builder: (context, state) => const MyFarmsScreen(),
      ),

      // ==================== RUTAS ====================
      GoRoute(
        name: RouteNames.farmDetail,
        path: RouteNames.farmDetail,
        builder: (context, state) {
          final farm = state.extra as FarmDetailsModel?;
          if (farm == null) {
            return const Scaffold(body: Center(child: Text('Error: Finca no encontrada')));
          }
          return FarmDetailScreen(farm: farm);
        },
      ),

      GoRoute(
        name: RouteNames.editFarm,
        path: RouteNames.editFarm,
        builder: (context, state) {
          final farm = state.extra as FarmDetailsModel?;
          if (farm == null) return const Scaffold(body: Center(child: Text('Error')));
          return EditFarmScreen(farm: farm);
        },
      ),

      GoRoute(
        name: RouteNames.lotDetail,
        path: RouteNames.lotDetail,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return LotDetailScreen(
            lot: args['lot'] as LotModel,
            farm: args['farm'] as FarmDetailsModel,
          );
        },
      ),

      GoRoute(
        name: RouteNames.editLot,
        path: RouteNames.editLot,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return EditLotScreen(
            lot: args['lot'] as LotModel,
            farm: args['farm'] as FarmDetailsModel,
          );
        },
      ),

      GoRoute(
        name: RouteNames.createLot,
        path: RouteNames.createLot,
        builder: (context, state) {
          final farm = state.extra as FarmDetailsModel?;
          if (farm == null) return const Scaffold(body: Center(child: Text('Error')));
          return CreateLotScreen(farm: farm);
        },
      ),

      GoRoute(
        name: RouteNames.lotHistory,
        path: RouteNames.lotHistory,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return LotHistoryScreen(
            lot: args['lot'] as LotModel,
            farm: args['farm'] as FarmDetailsModel,
          );
        },
      ),

      GoRoute(
        name: RouteNames.registerActivity,
        path: RouteNames.registerActivity,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return RegisterActivityScreen(
            lot: args['lot'] as LotModel,
            farm: args['farm'] as FarmDetailsModel,
          );
        },
      ),

      GoRoute(
        name: RouteNames.activities,
        path: RouteNames.activities,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          return ActivitiesListScreen(
            initialLot: args?['lot'] as LotModel?,
            initialFarm: args?['farm'] as FarmDetailsModel?,
          );
        },
      ),

      GoRoute(
        name: RouteNames.notifications,
        path: RouteNames.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),

      GoRoute(
        name: RouteNames.profile,
        path: RouteNames.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        name: RouteNames.editActivity,
        path: RouteNames.editActivity,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return EditActivityScreen(
            activity: args['activity'] as ActivityModel,
            lot: args['lot'] as LotModel,
            farm: args['farm'] as FarmDetailsModel,
          );
        },
      ),
      GoRoute(
        name: RouteNames.costs,
        path: RouteNames.costs,
        builder: (context, state) => const CostsListScreen(),
      ),

    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(child: Text('Ruta no encontrada')),
    ),
  );
}