import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visioncompanion/core/services/analytics_service.dart';
import 'package:visioncompanion/features/analyzer/cubit/analyzer_cubit.dart';
import 'package:visioncompanion/features/analyzer/data/vision_api.dart';
import 'package:visioncompanion/features/auth/cubit/auth_cubit.dart';
import 'package:visioncompanion/features/auth/data/auth_repository.dart';
import 'package:visioncompanion/features/detector/cubit/detector_cubit.dart';
import 'package:visioncompanion/features/detector/data/detector_service.dart';
import 'package:visioncompanion/features/history/cubit/history_cubit.dart';
import 'package:visioncompanion/features/history/data/history_repository.dart';
import 'package:visioncompanion/features/settings/cubit/locale_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupLocator() async {
  final prefs = await SharedPreferences.getInstance();

  getIt
    ..registerSingleton<SharedPreferences>(prefs)
    ..registerSingleton<AnalyticsService>(
      AnalyticsService(FirebaseAnalytics.instance),
    )
    ..registerSingleton<AuthRepository>(
      AuthRepository(FirebaseAuth.instance, GoogleSignIn()),
    )
    ..registerSingleton<HistoryRepository>(
      HistoryRepository(FirebaseFirestore.instance, getIt<AuthRepository>()),
    )
    ..registerSingleton<VisionApi>(VisionApi(http.Client()))
    ..registerSingleton<ImagePicker>(ImagePicker())
    ..registerSingleton<LocaleCubit>(LocaleCubit(prefs))
    ..registerSingleton<AuthCubit>(AuthCubit(getIt<AuthRepository>()))
    ..registerFactory<DetectorService>(DetectorService.new)
    ..registerFactory<HistoryCubit>(
      () => HistoryCubit(getIt<HistoryRepository>()),
    )
    ..registerFactory<DetectorCubit>(
      () => DetectorCubit(
        service: getIt<DetectorService>(),
        history: getIt<HistoryRepository>(),
        analytics: getIt<AnalyticsService>(),
        locale: getIt<LocaleCubit>(),
      ),
    )
    ..registerFactory<AnalyzerCubit>(
      () => AnalyzerCubit(
        api: getIt<VisionApi>(),
        picker: getIt<ImagePicker>(),
        history: getIt<HistoryRepository>(),
        analytics: getIt<AnalyticsService>(),
        locale: getIt<LocaleCubit>(),
      ),
    );
}
