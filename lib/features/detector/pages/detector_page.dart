import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visioncompanion/core/l10n_x.dart';
import 'package:visioncompanion/core/widgets/error_pane.dart';
import 'package:visioncompanion/features/detector/cubit/detector_cubit.dart';
import 'package:visioncompanion/features/detector/cubit/detector_state.dart';
import 'package:visioncompanion/features/detector/models/detection.dart';
import 'package:visioncompanion/features/detector/models/object_category.dart';
import 'package:visioncompanion/features/detector/models/object_names.dart';
import 'package:visioncompanion/features/detector/widgets/box_painter.dart'
as detector;
import 'package:visioncompanion/l10n/app_localizations.dart';

const Color _surfaceDark = Color(0xFF1A1109);

class DetectorPage extends StatelessWidget {
  const DetectorPage({super.key});

  String _errorText(AppLocalizations l10n, DetectorIssue issue) {
    switch (issue) {
      case DetectorIssue.cameraDenied:
        return l10n.detectorCameraDenied;
      case DetectorIssue.cameraFailed:
        return l10n.detectorCameraFailed;
      case DetectorIssue.modelFailed:
        return l10n.detectorModelFailed;
      case DetectorIssue.inferenceFailed:
        return l10n.detectorStopped;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<DetectorCubit>();

    return Scaffold(
      backgroundColor: _surfaceDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(
          l10n.detectorPageTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: const [_TimingChip()],
      ),
      body: SafeArea(
        child: BlocConsumer<DetectorCubit, DetectorState>(
          listenWhen: (_, next) => next is DetectorResults && next.announce,
          listener: (context, state) {
            if (state is! DetectorResults || state.detections.isEmpty) return;
            final top = state.detections.first;
            final name = localizedObjectName(context.l10n, top.label);
            SemanticsService.announce(
              context.l10n.announceObject(name, top.percent),
              Directionality.of(context),
            );
          },
          builder: (context, state) {
            if (state is DetectorError) {
              return ErrorPane(
                dark: true,
                message: _errorText(l10n, state.issue),
                onRetry: cubit.start,
              );
            }

            final camera = cubit.camera;
            if (camera == null || !camera.value.isInitialized) {
              return Center(
                child: Semantics(
                  liveRegion: true,
                  label: l10n.cameraStarting,
                  child: const CircularProgressIndicator(color: Colors.white),
                ),
              );
            }

            final shown = switch (state) {
              DetectorResults(:final detections) => detections,
              DetectorIdle(:final frozen) => frozen,
              _ => const <Detection>[],
            };
            final paused = state is DetectorIdle && state.paused;

            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(26),
                        child: AspectRatio(
                          aspectRatio: 1 / camera.value.aspectRatio,
                          child: Semantics(
                            label: l10n.cameraFeedLabel,
                            image: true,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                ExcludeSemantics(child: CameraPreview(camera)),
                                ExcludeSemantics(
                                  child: CustomPaint(
                                    painter: detector.BoxPainter(
                                      shown,
                                          (label) => localizedObjectName(l10n, label),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                _ControlPanel(
                  state: state,
                  paused: paused,
                  shown: shown,
                  onToggle: cubit.togglePause,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TimingChip extends StatelessWidget {
  const _TimingChip();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetectorCubit, DetectorState>(
      builder: (context, state) {
        if (state is! DetectorResults) return const SizedBox.shrink();

        return ExcludeSemantics(
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(30),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                context.l10n.inferenceTime(state.inferenceMs),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ControlPanel extends StatelessWidget {
  const _ControlPanel({
    required this.state,
    required this.paused,
    required this.shown,
    required this.onToggle,
  });

  final DetectorState state;
  final bool paused;
  final List<Detection> shown;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final String status;
    if (paused) {
      status = l10n.detectorPausedHint;
    } else if (shown.isEmpty) {
      status = l10n.detectorScanning;
    } else {
      status = l10n.detectorFound(shown.length);
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(20),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            status,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 38,
            child: shown.isEmpty
                ? const SizedBox.shrink()
                : ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: shown.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final item = shown[index];
                final color = ObjectCategory.of(item.label).color;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(19),
                  ),
                  child: Text(
                    '${localizedObjectName(l10n, item.label)} ${item.percent}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: Semantics(
              button: true,
              label: paused ? l10n.resumeDetection : l10n.pauseDetection,
              excludeSemantics: true,
              onTap: onToggle,
              child: FilledButton.icon(
                onPressed: onToggle,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: _surfaceDark,
                ),
                icon: Icon(
                  paused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                ),
                label: Text(paused ? l10n.resumeButton : l10n.pauseButton),
              ),
            ),
          ),
        ],
      ),
    );
  }
}