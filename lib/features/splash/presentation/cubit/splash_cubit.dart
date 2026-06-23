import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaabcafe/features/splash/domain/repositories/splash_repository.dart';
import 'package:kaabcafe/features/splash/presentation/cubit/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final SplashRepository _splashRepository;

  SplashCubit({required SplashRepository splashRepository})
      : _splashRepository = splashRepository,
        super(SplashInitial());

  Future<void> checkAppStatus() async {
    try {
      final initialData = await _splashRepository.getInitialData();

      if (initialData.isFirstLaunch) {
        await _splashRepository.setFirstLaunch(false);
        emit(NavigateToOnboarding());
      } else if (initialData.isLoggedIn) {
        emit(NavigateToHome());
      } else {
        emit(NavigateToLogin());
      }
    } catch (_) {
      emit(NavigateToOnboarding());
    }
  }
}