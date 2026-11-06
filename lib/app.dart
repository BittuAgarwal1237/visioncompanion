import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:visioncompanion/core/di/service_locator.dart';
import 'package:visioncompanion/core/router/app_router.dart';
import 'package:visioncompanion/core/theme/app_theme.dart';
import 'package:visioncompanion/features/auth/cubit/auth_cubit.dart';
import 'package:visioncompanion/features/settings/cubit/locale_cubit.dart';
import 'package:visioncompanion/l10n/app_localizations.dart';

class VisionCompanionApp extends StatefulWidget {
  const VisionCompanionApp({super.key});

  @override
  State<VisionCompanionApp> createState() => _VisionCompanionAppState();
}

class _VisionCompanionAppState extends State<VisionCompanionApp> {
  final AuthCubit _auth = getIt<AuthCubit>();
  final LocaleCubit _locale = getIt<LocaleCubit>();
  late final GoRouter _router = buildRouter(_auth);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: _auth),
        BlocProvider<LocaleCubit>.value(value: _locale),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: _router,
            locale: locale,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            onGenerateTitle: (context) => AppLocalizations.of(context).appName,
          );
        },
      ),
    );
  }
}
