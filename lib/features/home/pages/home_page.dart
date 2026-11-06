import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:visioncompanion/core/l10n_x.dart';
import 'package:visioncompanion/core/router/app_routes.dart';
import 'package:visioncompanion/core/widgets/user_avatar.dart';
import 'package:visioncompanion/features/auth/cubit/auth_cubit.dart';
import 'package:visioncompanion/features/auth/cubit/auth_state.dart';
import 'package:visioncompanion/features/auth/cubit/auth_user.dart';
import 'package:visioncompanion/features/home/widgets/feature_card.dart';
import 'package:visioncompanion/features/home/widgets/profile_sheet.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final state = context.watch<AuthCubit>().state;
    final user = state is Authenticated ? state.user : null;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _Header(user: user),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 26, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.homeSectionTitle,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              FeatureCard(
                icon: Icons.center_focus_strong_rounded,
                title: l10n.detectorTitle,
                description: l10n.detectorDescription,
                accent: scheme.primary,
                onStart: () => context.push(AppRoutes.detector),
              ),
              const SizedBox(height: 16),
              FeatureCard(
                icon: Icons.auto_awesome_rounded,
                title: l10n.analyzerTitle,
                description: l10n.analyzerDescription,
                accent: const Color(0xFFBF360C),
                onStart: () => context.push(AppRoutes.analyzer),
              ),
              const SizedBox(height: 22),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.history_rounded, size: 20, color: scheme.outline),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.homeFootnote,
                      style: TextStyle(fontSize: 14, height: 1.4, color: scheme.outline),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.user});

  final AuthUser? user;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final top = MediaQuery.of(context).padding.top;
    final name = user?.name ?? '';

    return Container(
      padding: EdgeInsets.fromLTRB(24, top + 20, 16, 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primary,
            Color.lerp(scheme.primary, scheme.tertiary, 0.7)!,
          ],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(34)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.greeting(name),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.greetingSub,
                  style: TextStyle(
                    color: Colors.white.withAlpha(220),
                    fontSize: 15,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          if (user != null)
            Semantics(
              button: true,
              excludeSemantics: true,
              label: l10n.profileSemantics(user!.name),
              onTap: () => showProfileSheet(context, user!),
              child: InkResponse(
                radius: 34,
                onTap: () => showProfileSheet(context, user!),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: UserAvatar(user: user!, radius: 24),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}