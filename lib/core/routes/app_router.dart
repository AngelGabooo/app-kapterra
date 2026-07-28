// lib/core/routes/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// ==================== FEATURES SPLASH ====================
import 'package:kaabcafe/features/splash/presentation/screens/splash_screen.dart';
import 'package:kaabcafe/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:kaabcafe/features/splash/data/datasources/splash_local_datasource.dart';
import 'package:kaabcafe/features/splash/data/repositories/splash_repository_impl.dart';

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
import 'package:kaabcafe/features/dashboard/presentation/screens/profile_dashboard_screen.dart';

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
import 'package:kaabcafe/features/marketplace/data/models/lot_model.dart';
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
import 'package:kaabcafe/features/auth/presentation/screens/pin_security_screen.dart';
import 'package:kaabcafe/features/farms/presentation/screens/lot_public_screen.dart';
import 'package:kaabcafe/features/buyer/presentation/screens/reports/reports_screen.dart';
import 'package:kaabcafe/features/marketplace/presentation/screens/purchases_screen.dart';
import 'package:kaabcafe/features/buyer/presentation/screens/technicians_screen.dart';
import 'package:kaabcafe/features/technician/presentation/screens/technician_producers_screen.dart';

import '../../features/dashboard/presentation/screens/dashboard_notifications_screen.dart';
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
          final extra = state.extra;

          // ✅ MANEJAR CORRECTAMENTE EL EXTRA
          if (extra is FarmDetailsModel) {
            return FarmDetailScreen(farm: extra);
          } else if (extra is Map<String, dynamic>) {
            try {
              final farm = FarmDetailsModel.fromJson(extra);
              return FarmDetailScreen(farm: farm);
            } catch (e) {
              return const Scaffold(
                body: Center(child: Text('Error: Datos de finca inválidos')),
              );
            }
          }

          return const Scaffold(
            body: Center(child: Text('Error: Finca no encontrada')),
          );
        },
      ),

      GoRoute(
        name: RouteNames.editFarm,
        path: RouteNames.editFarm,
        builder: (context, state) {
          final extra = state.extra;

          if (extra is FarmDetailsModel) {
            return EditFarmScreen(farm: extra);
          } else if (extra is Map<String, dynamic>) {
            try {
              final farm = FarmDetailsModel.fromJson(extra);
              return EditFarmScreen(farm: farm);
            } catch (e) {
              return const Scaffold(
                body: Center(child: Text('Error: Datos de finca inválidos')),
              );
            }
          }

          return const Scaffold(
            body: Center(child: Text('Error: Finca no encontrada')),
          );
        },
      ),

      GoRoute(
        name: RouteNames.lotDetail,
        path: RouteNames.lotDetail,
        builder: (context, state) {
          final extra = state.extra;

          // ✅ MANEJAR CORRECTAMENTE EL EXTRA
          if (extra is Map<String, dynamic>) {
            final lotData = extra['lot'];
            final farmData = extra['farm'];

            LotModel? lot;
            FarmDetailsModel? farm;

            // Procesar lot
            if (lotData is LotModel) {
              lot = lotData;
            } else if (lotData is Map<String, dynamic>) {
              try {
                lot = LotModel.fromJson(lotData);
              } catch (e) {
                // Si falla, intentar con los datos básicos
                lot = LotModel(
                  id: lotData['id'] ?? '',
                  name: lotData['name'] ?? 'Lote sin nombre',
                  variety: lotData['variety'] ?? 'No especificada',
                  estimatedProduction: (lotData['estimatedProduction'] ?? 0).toDouble(),
                  area: (lotData['area'] ?? 0).toDouble(),
                  status: LotStatus.values.firstWhere(
                        (s) => s.toString() == lotData['status'],
                    orElse: () => LotStatus.healthy,
                  ),
                  treesCount: lotData['treesCount'] ?? 0,
                );
              }
            }

            // Procesar farm
            if (farmData is FarmDetailsModel) {
              farm = farmData;
            } else if (farmData is Map<String, dynamic>) {
              try {
                farm = FarmDetailsModel.fromJson(farmData);
              } catch (e) {
                // Si falla, crear uno básico
                farm = FarmDetailsModel(
                  id: farmData['id'] ?? '',
                  name: farmData['name'] ?? 'Finca sin nombre',
                  location: farmData['location'] ?? 'Ubicación no especificada',
                  hectares: (farmData['hectares'] ?? 0).toDouble(),
                  lots: farmData['lots'] ?? 0,
                  productivity: (farmData['productivity'] ?? 0).toDouble(),
                  status: FarmHealthStatus.values.firstWhere(
                        (s) => s.toString() == farmData['status'],
                    orElse: () => FarmHealthStatus.healthy,
                  ),
                  imageUrl: farmData['imageUrl'] ?? '',
                  latitude: (farmData['latitude'] ?? 0).toDouble(),
                  longitude: (farmData['longitude'] ?? 0).toDouble(),
                );
              }
            }

            if (lot != null && farm != null) {
              return LotDetailScreen(lot: lot, farm: farm);
            }
          }

          return const Scaffold(
            body: Center(child: Text('Error: Datos del lote no encontrados')),
          );
        },
      ),

      GoRoute(
        name: RouteNames.editLot,
        path: RouteNames.editLot,
        builder: (context, state) {
          final extra = state.extra;

          if (extra is Map<String, dynamic>) {
            final lotData = extra['lot'];
            final farmData = extra['farm'];

            LotModel? lot;
            FarmDetailsModel? farm;

            if (lotData is LotModel) {
              lot = lotData;
            } else if (lotData is Map<String, dynamic>) {
              try {
                lot = LotModel.fromJson(lotData);
              } catch (e) {
                lot = LotModel(
                  id: lotData['id'] ?? '',
                  name: lotData['name'] ?? 'Lote sin nombre',
                  variety: lotData['variety'] ?? 'No especificada',
                  estimatedProduction: (lotData['estimatedProduction'] ?? 0).toDouble(),
                  area: (lotData['area'] ?? 0).toDouble(),
                  status: LotStatus.values.firstWhere(
                        (s) => s.toString() == lotData['status'],
                    orElse: () => LotStatus.healthy,
                  ),
                  treesCount: lotData['treesCount'] ?? 0,
                );
              }
            }

            if (farmData is FarmDetailsModel) {
              farm = farmData;
            } else if (farmData is Map<String, dynamic>) {
              try {
                farm = FarmDetailsModel.fromJson(farmData);
              } catch (e) {
                farm = FarmDetailsModel(
                  id: farmData['id'] ?? '',
                  name: farmData['name'] ?? 'Finca sin nombre',
                  location: farmData['location'] ?? 'Ubicación no especificada',
                  hectares: (farmData['hectares'] ?? 0).toDouble(),
                  lots: farmData['lots'] ?? 0,
                  productivity: (farmData['productivity'] ?? 0).toDouble(),
                  status: FarmHealthStatus.values.firstWhere(
                        (s) => s.toString() == farmData['status'],
                    orElse: () => FarmHealthStatus.healthy,
                  ),
                  imageUrl: farmData['imageUrl'] ?? '',
                  latitude: (farmData['latitude'] ?? 0).toDouble(),
                  longitude: (farmData['longitude'] ?? 0).toDouble(),
                );
              }
            }

            if (lot != null && farm != null) {
              return EditLotScreen(lot: lot, farm: farm);
            }
          }

          return const Scaffold(
            body: Center(child: Text('Error: Datos del lote no encontrados')),
          );
        },
      ),

      GoRoute(
        name: RouteNames.createLot,
        path: RouteNames.createLot,
        builder: (context, state) {
          final extra = state.extra;

          if (extra is FarmDetailsModel) {
            return CreateLotScreen(farm: extra);
          } else if (extra is Map<String, dynamic>) {
            try {
              final farm = FarmDetailsModel.fromJson(extra);
              return CreateLotScreen(farm: farm);
            } catch (e) {
              return const Scaffold(
                body: Center(child: Text('Error: Datos de finca inválidos')),
              );
            }
          }

          return const Scaffold(
            body: Center(child: Text('Error: Finca no encontrada')),
          );
        },
      ),

      GoRoute(
        name: RouteNames.lotHistory,
        path: RouteNames.lotHistory,
        builder: (context, state) {
          final extra = state.extra;

          if (extra is Map<String, dynamic>) {
            final lotData = extra['lot'];
            final farmData = extra['farm'];

            LotModel? lot;
            FarmDetailsModel? farm;

            if (lotData is LotModel) {
              lot = lotData;
            } else if (lotData is Map<String, dynamic>) {
              try {
                lot = LotModel.fromJson(lotData);
              } catch (e) {
                lot = LotModel(
                  id: lotData['id'] ?? '',
                  name: lotData['name'] ?? 'Lote sin nombre',
                  variety: lotData['variety'] ?? 'No especificada',
                  estimatedProduction: (lotData['estimatedProduction'] ?? 0).toDouble(),
                  area: (lotData['area'] ?? 0).toDouble(),
                  status: LotStatus.values.firstWhere(
                        (s) => s.toString() == lotData['status'],
                    orElse: () => LotStatus.healthy,
                  ),
                  treesCount: lotData['treesCount'] ?? 0,
                );
              }
            }

            if (farmData is FarmDetailsModel) {
              farm = farmData;
            } else if (farmData is Map<String, dynamic>) {
              try {
                farm = FarmDetailsModel.fromJson(farmData);
              } catch (e) {
                farm = FarmDetailsModel(
                  id: farmData['id'] ?? '',
                  name: farmData['name'] ?? 'Finca sin nombre',
                  location: farmData['location'] ?? 'Ubicación no especificada',
                  hectares: (farmData['hectares'] ?? 0).toDouble(),
                  lots: farmData['lots'] ?? 0,
                  productivity: (farmData['productivity'] ?? 0).toDouble(),
                  status: FarmHealthStatus.values.firstWhere(
                        (s) => s.toString() == farmData['status'],
                    orElse: () => FarmHealthStatus.healthy,
                  ),
                  imageUrl: farmData['imageUrl'] ?? '',
                  latitude: (farmData['latitude'] ?? 0).toDouble(),
                  longitude: (farmData['longitude'] ?? 0).toDouble(),
                );
              }
            }

            if (lot != null && farm != null) {
              return LotHistoryScreen(lot: lot, farm: farm);
            }
          }

          return const Scaffold(
            body: Center(child: Text('Error: Datos del lote no encontrados')),
          );
        },
      ),

      GoRoute(
        name: RouteNames.registerActivity,
        path: RouteNames.registerActivity,
        builder: (context, state) {
          final extra = state.extra;

          if (extra is Map<String, dynamic>) {
            final lotData = extra['lot'];
            final farmData = extra['farm'];

            LotModel? lot;
            FarmDetailsModel? farm;

            if (lotData is LotModel) {
              lot = lotData;
            } else if (lotData is Map<String, dynamic>) {
              try {
                lot = LotModel.fromJson(lotData);
              } catch (e) {
                lot = LotModel(
                  id: lotData['id'] ?? '',
                  name: lotData['name'] ?? 'Lote sin nombre',
                  variety: lotData['variety'] ?? 'No especificada',
                  estimatedProduction: (lotData['estimatedProduction'] ?? 0).toDouble(),
                  area: (lotData['area'] ?? 0).toDouble(),
                  status: LotStatus.values.firstWhere(
                        (s) => s.toString() == lotData['status'],
                    orElse: () => LotStatus.healthy,
                  ),
                  treesCount: lotData['treesCount'] ?? 0,
                );
              }
            }

            if (farmData is FarmDetailsModel) {
              farm = farmData;
            } else if (farmData is Map<String, dynamic>) {
              try {
                farm = FarmDetailsModel.fromJson(farmData);
              } catch (e) {
                farm = FarmDetailsModel(
                  id: farmData['id'] ?? '',
                  name: farmData['name'] ?? 'Finca sin nombre',
                  location: farmData['location'] ?? 'Ubicación no especificada',
                  hectares: (farmData['hectares'] ?? 0).toDouble(),
                  lots: farmData['lots'] ?? 0,
                  productivity: (farmData['productivity'] ?? 0).toDouble(),
                  status: FarmHealthStatus.values.firstWhere(
                        (s) => s.toString() == farmData['status'],
                    orElse: () => FarmHealthStatus.healthy,
                  ),
                  imageUrl: farmData['imageUrl'] ?? '',
                  latitude: (farmData['latitude'] ?? 0).toDouble(),
                  longitude: (farmData['longitude'] ?? 0).toDouble(),
                );
              }
            }

            if (lot != null && farm != null) {
              return RegisterActivityScreen(lot: lot, farm: farm);
            }
          }

          return const Scaffold(
            body: Center(child: Text('Error: Datos de actividad no encontrados')),
          );
        },
      ),

      GoRoute(
        name: RouteNames.activities,
        path: RouteNames.activities,
        builder: (context, state) {
          final extra = state.extra;

          if (extra is Map<String, dynamic>) {
            final lotData = extra['lot'];
            final farmData = extra['farm'];

            LotModel? lot;
            FarmDetailsModel? farm;

            if (lotData is LotModel) {
              lot = lotData;
            } else if (lotData is Map<String, dynamic>) {
              try {
                lot = LotModel.fromJson(lotData);
              } catch (e) {
                lot = LotModel(
                  id: lotData['id'] ?? '',
                  name: lotData['name'] ?? 'Lote sin nombre',
                  variety: lotData['variety'] ?? 'No especificada',
                  estimatedProduction: (lotData['estimatedProduction'] ?? 0).toDouble(),
                  area: (lotData['area'] ?? 0).toDouble(),
                  status: LotStatus.values.firstWhere(
                        (s) => s.toString() == lotData['status'],
                    orElse: () => LotStatus.healthy,
                  ),
                  treesCount: lotData['treesCount'] ?? 0,
                );
              }
            }

            if (farmData is FarmDetailsModel) {
              farm = farmData;
            } else if (farmData is Map<String, dynamic>) {
              try {
                farm = FarmDetailsModel.fromJson(farmData);
              } catch (e) {
                farm = FarmDetailsModel(
                  id: farmData['id'] ?? '',
                  name: farmData['name'] ?? 'Finca sin nombre',
                  location: farmData['location'] ?? 'Ubicación no especificada',
                  hectares: (farmData['hectares'] ?? 0).toDouble(),
                  lots: farmData['lots'] ?? 0,
                  productivity: (farmData['productivity'] ?? 0).toDouble(),
                  status: FarmHealthStatus.values.firstWhere(
                        (s) => s.toString() == farmData['status'],
                    orElse: () => FarmHealthStatus.healthy,
                  ),
                  imageUrl: farmData['imageUrl'] ?? '',
                  latitude: (farmData['latitude'] ?? 0).toDouble(),
                  longitude: (farmData['longitude'] ?? 0).toDouble(),
                );
              }
            }

            return ActivitiesListScreen(
              initialLot: lot,
              initialFarm: farm,
            );
          }

          return const ActivitiesListScreen();
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
          final extra = state.extra;

          if (extra is Map<String, dynamic>) {
            final activityData = extra['activity'];
            final lotData = extra['lot'];
            final farmData = extra['farm'];

            ActivityModel? activity;
            LotModel? lot;
            FarmDetailsModel? farm;

            if (activityData is ActivityModel) {
              activity = activityData;
            }

            if (lotData is LotModel) {
              lot = lotData;
            } else if (lotData is Map<String, dynamic>) {
              try {
                lot = LotModel.fromJson(lotData);
              } catch (e) {
                lot = LotModel(
                  id: lotData['id'] ?? '',
                  name: lotData['name'] ?? 'Lote sin nombre',
                  variety: lotData['variety'] ?? 'No especificada',
                  estimatedProduction: (lotData['estimatedProduction'] ?? 0).toDouble(),
                  area: (lotData['area'] ?? 0).toDouble(),
                  status: LotStatus.values.firstWhere(
                        (s) => s.toString() == lotData['status'],
                    orElse: () => LotStatus.healthy,
                  ),
                  treesCount: lotData['treesCount'] ?? 0,
                );
              }
            }

            if (farmData is FarmDetailsModel) {
              farm = farmData;
            } else if (farmData is Map<String, dynamic>) {
              try {
                farm = FarmDetailsModel.fromJson(farmData);
              } catch (e) {
                farm = FarmDetailsModel(
                  id: farmData['id'] ?? '',
                  name: farmData['name'] ?? 'Finca sin nombre',
                  location: farmData['location'] ?? 'Ubicación no especificada',
                  hectares: (farmData['hectares'] ?? 0).toDouble(),
                  lots: farmData['lots'] ?? 0,
                  productivity: (farmData['productivity'] ?? 0).toDouble(),
                  status: FarmHealthStatus.values.firstWhere(
                        (s) => s.toString() == farmData['status'],
                    orElse: () => FarmHealthStatus.healthy,
                  ),
                  imageUrl: farmData['imageUrl'] ?? '',
                  latitude: (farmData['latitude'] ?? 0).toDouble(),
                  longitude: (farmData['longitude'] ?? 0).toDouble(),
                );
              }
            }

            if (activity != null && lot != null && farm != null) {
              return EditActivityScreen(activity: activity, lot: lot, farm: farm);
            }
          }

          return const Scaffold(
            body: Center(child: Text('Error: Datos de actividad no encontrados')),
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
      GoRoute(
        name: RouteNames.technicians,
        path: RouteNames.technicians,
        builder: (context, state) => const TechniciansScreen(),
      ),
      GoRoute(
        name: RouteNames.technicianProducers,
        path: RouteNames.technicianProducers,
        builder: (context, state) => const TechnicianProducersScreen(),
      ),
      GoRoute(
        name: RouteNames.dashboardNotifications,
        path: RouteNames.dashboardNotifications,
        builder: (context, state) => const DashboardNotificationsScreen(),
      ),
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(child: Text('Ruta no encontrada')),
    ),
  );
}