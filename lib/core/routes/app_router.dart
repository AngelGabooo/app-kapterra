import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // 🆕 Agregado para usar BlocProvider
import 'package:go_router/go_router.dart';

// ==================== FEATURES SPLASH ====================
import 'package:kaabcafe/features/splash/presentation/screens/splash_screen.dart';
import 'package:kaabcafe/features/splash/presentation/cubit/splash_cubit.dart'; // 🆕 Agregado
import 'package:kaabcafe/features/splash/data/datasources/splash_local_datasource.dart'; // 🆕 Agregado
import 'package:kaabcafe/features/splash/data/repositories/splash_repository_impl.dart'; // 🆕 Agregado

// ==================== SCREENS ====================
import 'package:kaabcafe/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:kaabcafe/features/auth/presentation/screens/login_screen.dart';
import 'package:kaabcafe/features/auth/presentation/screens/register_screen.dart';
import 'package:kaabcafe/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:kaabcafe/features/auth/presentation/screens/select_user_type_screen.dart';
import 'package:kaabcafe/features/auth/presentation/screens/setup_profile_screen.dart';

import 'package:kaabcafe/features/farm/presentation/screens/register_farm_screen.dart';
import 'package:kaabcafe/features/farm/presentation/screens/farm_success_screen.dart';

import 'package:kaabcafe/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:kaabcafe/features/dashboard/presentation/screens/profile_dashboard_screen.dart'; // ✅ NUEVO

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
import 'package:kaabcafe/features/buyer/presentation/screens/cooperative_dashboard_screen.dart';
import 'package:kaabcafe/features/buyer/presentation/screens/producers_screen.dart';
import 'package:kaabcafe/features/marketplace/presentation/screens/marketplace_screen.dart';
import 'package:kaabcafe/features/marketplace/presentation/screens/explore_screen.dart';
import 'package:kaabcafe/features/marketplace/presentation/screens/lot_detail_screen.dart' as marketplace;
import 'package:kaabcafe/features/marketplace/data/models/lot_model.dart'; // ✅ Agregar este import
import 'package:kaabcafe/features/marketplace/presentation/screens/make_offer_screen.dart';
import 'package:kaabcafe/features/marketplace/presentation/screens/negotiation_screen.dart';
import 'package:kaabcafe/features/marketplace/presentation/screens/digital_passport_screen.dart';
import 'package:kaabcafe/features/marketplace/presentation/screens/buyer_profile_screen.dart';
import 'package:kaabcafe/features/buyer/presentation/screens/acopio_screen.dart';
import 'package:kaabcafe/features/buyer/presentation/screens/cooperative_profile_screen.dart';
import 'package:kaabcafe/features/technician/presentation/screens/technician_dashboard_screen.dart';
import 'package:kaabcafe/features/technician/presentation/screens/technician_agenda_screen.dart';
import 'package:kaabcafe/features/technician/presentation/screens/technician_visit_registration_screen.dart';
import 'package:kaabcafe/features/technician/presentation/screens/technician_lot_inspection_screen.dart';
import 'package:kaabcafe/features/technician/presentation/screens/technician_crop_diagnosis_screen.dart';
import 'package:kaabcafe/features/technician/presentation/screens/technician_lot_certification_screen.dart';
import 'package:kaabcafe/features/auth/presentation/screens/pin_security_screen.dart'; // ✅ NUEVO
import 'package:kaabcafe/features/farms/presentation/screens/lot_public_screen.dart';
import 'package:kaabcafe/features/buyer/presentation/screens/reports/reports_screen.dart';
import 'package:kaabcafe/features/marketplace/presentation/screens/purchases_screen.dart';

import '../../features/dashboard/presentation/screens/indicators_screen.dart';


class AppRouter {
  static final router = GoRouter(
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: true,
    routes: [
      // ── RUTA RAIZ: SPLASH CON INYECCIÓN DE NEGOCIO ─────────────────
      GoRoute(
        name: RouteNames.splash,
        path: RouteNames.splash,
        builder: (context, state) {
          return BlocProvider<SplashCubit>(
            create: (context) => SplashCubit(
              splashRepository: SplashRepositoryImpl(
                localDataSource: SplashLocalDataSource(),
              ),
            ),
            child: const SplashScreen(),
          );
        },
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

      // ==================== RUTAS FINCAS ====================
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
      GoRoute(
        name: RouteNames.cooperativeDashboard,
        path: RouteNames.cooperativeDashboard,
        builder: (context, state) => const CooperativeDashboardScreen(),
      ),
      GoRoute(
        name: RouteNames.producers,
        path: RouteNames.producers,
        builder: (context, state) => const ProducersScreen(),
      ),
      GoRoute(
        name: RouteNames.marketplace,
        path: RouteNames.marketplace,
        builder: (context, state) => const MarketplaceScreen(),
      ),
      GoRoute(
        name: RouteNames.explore,
        path: RouteNames.explore,
        builder: (context, state) => const ExploreScreen(),
      ),
      GoRoute(
        name: RouteNames.marketplaceLotDetail,
        path: RouteNames.marketplaceLotDetail,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          final lot = args['lot'] as MarketplaceLotModel;
          return marketplace.LotDetailScreen(lot: lot);
        },
      ),
      GoRoute(
        name: RouteNames.makeOffer,
        path: RouteNames.makeOffer,
        builder: (context, state) {
          final lot = state.extra as MarketplaceLotModel;
          return MakeOfferScreen(lot: lot);
        },
      ),
      GoRoute(
        name: RouteNames.negotiation,
        path: RouteNames.negotiation,
        builder: (context, state) => const NegotiationScreen(),
      ),
      GoRoute(
        name: RouteNames.digitalPassport,
        path: RouteNames.digitalPassport,
        builder: (context, state) {
          final lot = state.extra as MarketplaceLotModel;
          return DigitalPassportScreen(lot: lot);
        },
      ),
      GoRoute(
        name: RouteNames.buyerProfile,
        path: RouteNames.buyerProfile,
        builder: (context, state) => const BuyerProfileScreen(),
      ),
      GoRoute(
        name: RouteNames.acopio,
        path: RouteNames.acopio,
        builder: (context, state) => const AcopioScreen(),
      ),
      GoRoute(
        name: RouteNames.cooperativeProfile,
        path: RouteNames.cooperativeProfile,
        builder: (context, state) => const CooperativeProfileScreen(),
      ),
      GoRoute(
        name: RouteNames.technicianDashboard,
        path: RouteNames.technicianDashboard,
        builder: (context, state) => const TechnicianDashboardScreen(),
      ),
      GoRoute(
        name: RouteNames.technicianAgenda,
        path: RouteNames.technicianAgenda,
        builder: (context, state) => const TechnicianAgendaScreen(),
      ),
      GoRoute(
        name: RouteNames.technicianVisitRegistration,
        path: RouteNames.technicianVisitRegistration,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          return TechnicianVisitRegistrationScreen(
            producerName: args?['producerName'] as String?,
            farmName: args?['farmName'] as String?,
            lotName: args?['lotName'] as String?,
            location: args?['location'] as String?,
          );
        },
      ),
      GoRoute(
        name: RouteNames.technicianLotInspection,
        path: RouteNames.technicianLotInspection,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          return TechnicianLotInspectionScreen(
            lotName: args?['lotName'] as String?,
            farmName: args?['farmName'] as String?,
            producerName: args?['producerName'] as String?,
            location: args?['location'] as String?,
          );
        },
      ),
      GoRoute(
        name: RouteNames.technicianCropDiagnosis,
        path: RouteNames.technicianCropDiagnosis,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          return TechnicianCropDiagnosisScreen(
            lotName: args?['lotName'] as String?,
            farmName: args?['farmName'] as String?,
            producerName: args?['producerName'] as String?,
            location: args?['location'] as String?,
          );
        },
      ),
      GoRoute(
        name: RouteNames.technicianLotCertification,
        path: RouteNames.technicianLotCertification,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          return TechnicianLotCertificationScreen(
            lotName: args?['lotName'] as String?,
            farmName: args?['farmName'] as String?,
            producerName: args?['producerName'] as String?,
            location: args?['location'] as String?,
            variety: args?['variety'] as String?,
          );
        },
      ),
      GoRoute(
        path: RouteNames.pinSecurity,
        name: RouteNames.pinSecurity,
        builder: (context, state) => const PinSecurityScreen(),
      ),
      GoRoute(
        name: RouteNames.profileDashboard,
        path: RouteNames.profileDashboard,
        builder: (context, state) => const ProfileDashboardScreen(),
      ),
      GoRoute(
        name: RouteNames.lotPublic,
        path: RouteNames.lotPublic,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return LotPublicScreen.fromQRData(args);
        },
      ),
      GoRoute(
        name: RouteNames.reports,
        path: RouteNames.reports,
        builder: (context, state) => const ReportsScreen(),
      ),
      GoRoute(
        name: RouteNames.purchases,
        path: RouteNames.purchases,
        builder: (context, state) => const PurchasesScreen(),
      ),
      GoRoute(
        path: RouteNames.indicators,
        name: RouteNames.indicators,
        builder: (context, state) => const IndicatorsScreen(),
      ),
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(child: Text('Ruta no encontrada')),
    ),
  );
}