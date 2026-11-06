import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:visioncompanion/core/l10n_x.dart';
import 'package:visioncompanion/core/router/app_routes.dart';
import 'package:visioncompanion/core/widgets/user_avatar.dart';
import 'package:visioncompanion/features/auth/cubit/auth_cubit.dart';
import 'package:visioncompanion/features/auth/cubit/auth_user.dart';

Future<void> showProfileSheet(BuildContext context, AuthUser user) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => _ProfileSheet(user: user),
  );
}

class _ProfileSheet extends StatelessWidget {
  const _ProfileSheet({required this.user});

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UserAvatar(user: user, radius: 40),
            const SizedBox(height: 14),
            Text(
              user.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              user.email,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.5, color: scheme.outline),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  final router = GoRouter.of(context);
                  Navigator.of(context).pop();
                  router.go(AppRoutes.settings);
                },
                icon: const Icon(Icons.settings_outlined),
                label: Text(l10n.navSettings),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  final auth = context.read<AuthCubit>();
                  Navigator.of(context).pop();
                  auth.signOut();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: scheme.errorContainer,
                  foregroundColor: scheme.onErrorContainer,
                ),
                icon: const Icon(Icons.logout_rounded),
                label: Text(l10n.signOut),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
