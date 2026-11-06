import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:visioncompanion/core/di/service_locator.dart';
import 'package:visioncompanion/core/l10n_x.dart';
import 'package:visioncompanion/core/router/app_routes.dart';
import 'package:visioncompanion/features/analyzer/cubit/analyzer_cubit.dart';
import 'package:visioncompanion/features/analyzer/pages/analyzer_page.dart';
import 'package:visioncompanion/features/auth/cubit/auth_cubit.dart';
import 'package:visioncompanion/features/auth/cubit/auth_state.dart';
import 'package:visioncompanion/features/auth/pages/login_page.dart';
import 'package:visioncompanion/features/detector/cubit/detector_cubit.dart';
import 'package:visioncompanion/features/detector/pages/detector_page.dart';
import 'package:visioncompanion/features/history/cubit/history_cubit.dart';
import 'package:visioncompanion/features/history/pages/history_page.dart';
import 'package:visioncompanion/features/home/pages/home_page.dart';
import 'package:visioncompanion/features/home/pages/home_shell.dart';
import 'package:visioncompanion/features/settings/pages/settings_page.dart';

class _AuthRefresh extends ChangeNotifier {
  _AuthRefresh(Stream<AuthState> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

GoRouter buildRouter(AuthCubit auth) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: _AuthRefresh(auth.stream),
    redirect: (context, state) {
      final current = auth.state;
      final at = state.matchedLocation;

      if (current is AuthLoading) return null;

      if (current is! Authenticated) {
        return at == AppRoutes.login ? null : AppRoutes.login;
      }

      if (at == AppRoutes.login || at == AppRoutes.splash) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const _SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => HomeShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.history,
                builder: (context, state) => BlocProvider(
                  create: (_) => getIt<HistoryCubit>()..watch(),
                  child: const HistoryPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.detector,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<DetectorCubit>()..start(),
          child: const DetectorPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.analyzer,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<AnalyzerCubit>(),
          child: const AnalyzerPage(),
        ),
      ),
    ],
  );
}

class _SplashPage extends StatelessWidget {
  const _SplashPage();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.primary,
      body: Center(
        child: Semantics(
          liveRegion: true,
          label: context.l10n.splashLoading,
          child: const CircularProgressIndicator(color: Colors.white),
        ),
      ),
    );
  }
}
