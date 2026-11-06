import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:visioncompanion/core/l10n_x.dart';
import 'package:visioncompanion/core/widgets/error_pane.dart';
import 'package:visioncompanion/features/detector/models/object_names.dart';
import 'package:visioncompanion/features/history/cubit/history_cubit.dart';
import 'package:visioncompanion/features/history/cubit/history_state.dart';
import 'package:visioncompanion/features/history/models/feature_type.dart';
import 'package:visioncompanion/features/history/models/history_entry.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.historyTitle)),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          return switch (state) {
            HistoryLoading() => const Center(child: CircularProgressIndicator()),
            HistoryFailed() => ErrorPane(
              message: l10n.historyLoadError,
              onRetry: context.read<HistoryCubit>().watch,
            ),
            HistoryLoaded(:final entries) => entries.isEmpty
                ? const _EmptyHistory()
                : _EntryList(entries: entries),
          };
        },
      ),
    );
  }
}

class _EntryList extends StatelessWidget {
  const _EntryList({required this.entries});

  final List<HistoryEntry> entries;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: entries.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
            child: Text(
              l10n.historyCount(entries.length),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: scheme.outline,
              ),
            ),
          );
        }

        final entry = entries[index - 1];
        return Dismissible(
          key: ValueKey(entry.id),
          direction: DismissDirection.endToStart,
          background: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.only(right: 24),
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              color: scheme.errorContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.delete_outline_rounded, color: scheme.onErrorContainer),
          ),
          onDismissed: (_) {
            context.read<HistoryCubit>().remove(entry.id);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(l10n.historyRemoved)));
          },
          child: _EntryCard(entry: entry),
        );
      },
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({required this.entry});

  final HistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).toString();
    final isDetector = entry.type == FeatureType.detector;
    final when = DateFormat.yMMMd(locale).add_jm().format(entry.timestamp);
    // Detector results are stored as raw labels and translated here,
    // so they follow the current app language.
    final summary = entry.items.isEmpty
        ? entry.summary
        : entry.items
        .map((i) => '${localizedObjectName(l10n, i.label)} ${i.percent}%')
        .join(', ');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: isDetector
                  ? scheme.primaryContainer
                  : scheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isDetector
                  ? Icons.center_focus_strong_rounded
                  : Icons.image_search_rounded,
              color: isDetector
                  ? scheme.onPrimaryContainer
                  : scheme.onTertiaryContainer,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.historyFeature(entry.type.name),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  when,
                  style: TextStyle(fontSize: 12.5, color: scheme.outline),
                ),
                const SizedBox(height: 8),
                Text(
                  summary,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14.5, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scheme.primaryContainer,
              ),
              child: Icon(
                Icons.history_rounded,
                size: 46,
                color: scheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.historyEmptyTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.historyEmptyBody,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, height: 1.4, color: scheme.outline),
            ),
          ],
        ),
      ),
    );
  }
}