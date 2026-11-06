import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visioncompanion/core/l10n_x.dart';
import 'package:visioncompanion/core/widgets/error_pane.dart';
import 'package:visioncompanion/features/analyzer/cubit/analyzer_cubit.dart';
import 'package:visioncompanion/features/analyzer/cubit/analyzer_state.dart';
import 'package:visioncompanion/features/analyzer/models/analysis_data.dart';
import 'package:visioncompanion/l10n/app_localizations.dart';

class AnalyzerPage extends StatelessWidget {
  const AnalyzerPage({super.key});

  String _errorText(AppLocalizations l10n, AnalyzerIssue issue) {
    switch (issue) {
      case AnalyzerIssue.noInternet:
        return l10n.analyzerNoInternet;
      case AnalyzerIssue.timeout:
        return l10n.analyzerTimeout;
      case AnalyzerIssue.busy:
        return l10n.analyzerBusy;
      case AnalyzerIssue.badKey:
        return l10n.analyzerBadKey;
      case AnalyzerIssue.missingKey:
        return l10n.analyzerMissingKey;
      case AnalyzerIssue.parse:
        return l10n.analyzerParse;
      case AnalyzerIssue.camera:
        return l10n.analyzerCameraFailed;
      case AnalyzerIssue.unknown:
        return l10n.analyzerUnknown;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<AnalyzerCubit>();

    return BlocConsumer<AnalyzerCubit, AnalyzerState>(
      listener: (context, state) {
        final message = switch (state) {
          AnalyzerProcessing() => context.l10n.analyzingStatus,
          AnalyzerResult() => context.l10n.analysisDone,
          AnalyzerError(:final issue) => _errorText(context.l10n, issue),
          _ => null,
        };
        if (message != null) {
          SemanticsService.announce(message, Directionality.of(context));
        }
      },
      builder: (context, state) {
        final busy = state is AnalyzerProcessing;
        final hasResult = state is AnalyzerResult;

        final Widget body = switch (state) {
          AnalyzerIdle() => const _IdleView(),
          AnalyzerProcessing(:final imagePath) => _ProcessingView(path: imagePath),
          AnalyzerResult(:final data, :final imagePath) =>
            _ResultView(data: data, path: imagePath),
          AnalyzerError(:final issue, :final imagePath) => Column(
              children: [
                if (imagePath != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: _Photo(path: imagePath),
                  ),
                Expanded(
                  child: ErrorPane(
                    message: _errorText(l10n, issue),
                    onRetry: cubit.retry,
                  ),
                ),
              ],
            ),
        };

        return Scaffold(
          appBar: AppBar(title: Text(l10n.analyzerPageTitle)),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: KeyedSubtree(
                      key: ValueKey(state.runtimeType),
                      child: body,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: busy ? null : cubit.capture,
                      icon: const Icon(Icons.photo_camera_rounded),
                      label: Text(
                        hasResult ? l10n.captureAgain : l10n.captureButton,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Photo extends StatelessWidget {
  const _Photo({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: context.l10n.photoLabel,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: Image.file(File(path), fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class _IdleView extends StatelessWidget {
  const _IdleView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;

    Widget tip(IconData icon, String text) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: scheme.primary),
            const SizedBox(width: 10),
            Flexible(child: Text(text, style: const TextStyle(fontSize: 14.5))),
          ],
        ),
      );
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [scheme.primaryContainer, scheme.tertiaryContainer],
                ),
              ),
              child: Icon(
                Icons.image_search_rounded,
                size: 60,
                color: scheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              l10n.analyzerIdleTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.analyzerIdleBody,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15.5, height: 1.45, color: scheme.outline),
            ),
            const SizedBox(height: 18),
            tip(Icons.wb_sunny_outlined, l10n.tipLight),
            tip(Icons.crop_free_rounded, l10n.tipSteady),
          ],
        ),
      ),
    );
  }
}

class _ProcessingView extends StatelessWidget {
  const _ProcessingView({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      children: [
        _Photo(path: path),
        const SizedBox(height: 36),
        Center(
          child: Semantics(
            liveRegion: true,
            label: l10n.processingLabel,
            child: const SizedBox(
              width: 52,
              height: 52,
              child: CircularProgressIndicator(strokeWidth: 5),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ExcludeSemantics(
          child: Text(
            l10n.analyzingStatus,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView({required this.data, required this.path});

  final AnalysisData data;
  final String path;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      children: [
        _Photo(path: path),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.resultDescriptionTitle,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                  color: scheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                data.description,
                style: const TextStyle(fontSize: 16.5, height: 1.45),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Text(
          l10n.resultTagsTitle,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final tag in data.tags)
              Semantics(
                label: l10n.tagSemantics(tag.name, tag.confidence),
                excludeSemantics: true,
                child: Container(
                  constraints: const BoxConstraints(minHeight: 40),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tag.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: scheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${tag.confidence}%',
                        style: TextStyle(
                          fontSize: 13,
                          color: scheme.onPrimaryContainer.withAlpha(190),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
