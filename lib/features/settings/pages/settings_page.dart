import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visioncompanion/core/l10n_x.dart';
import 'package:visioncompanion/core/widgets/user_avatar.dart';
import 'package:visioncompanion/features/auth/cubit/auth_cubit.dart';
import 'package:visioncompanion/features/auth/cubit/auth_state.dart';
import 'package:visioncompanion/features/settings/cubit/locale_cubit.dart';
import 'package:visioncompanion/l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final authState = context.watch<AuthCubit>().state;
    final user = authState is Authenticated ? authState.user : null;

    return BlocListener<LocaleCubit, Locale>(
      listener: (context, locale) {
        final target = lookupAppLocalizations(locale);
        final name = locale.languageCode == 'hi'
            ? target.languageHindi
            : target.languageEnglish;
        SemanticsService.announce(
          target.languageChanged(name),
          Directionality.of(context),
        );
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.settingsTitle)),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
          children: [
            if (user != null)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: scheme.outlineVariant),
                ),
                child: Row(
                  children: [
                    UserAvatar(user: user, radius: 30),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user.email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: scheme.outline),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 10),
              child: Text(
                l10n.languageTitle,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            BlocBuilder<LocaleCubit, Locale>(
              builder: (context, locale) {
                return Container(
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: scheme.outlineVariant),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      _LanguageTile(
                        title: l10n.languageEnglish,
                        selected: locale.languageCode == 'en',
                        onTap: () => context.read<LocaleCubit>().select('en'),
                      ),
                      const Divider(height: 1),
                      _LanguageTile(
                        title: l10n.languageHindi,
                        selected: locale.languageCode == 'hi',
                        onTap: () => context.read<LocaleCubit>().select('hi'),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 28),
            OutlinedButton.icon(
              onPressed: () => context.read<AuthCubit>().signOut(),
              icon: const Icon(Icons.logout_rounded),
              label: Text(l10n.signOut),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ListTile(
      minTileHeight: 60,
      selected: selected,
      selectedColor: scheme.primary,
      leading: const Icon(Icons.translate_rounded),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      trailing: selected ? const Icon(Icons.check_circle_rounded) : null,
      onTap: onTap,
    );
  }
}
