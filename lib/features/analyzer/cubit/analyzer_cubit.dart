import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visioncompanion/core/services/analytics_service.dart';
import 'package:visioncompanion/features/analyzer/cubit/analyzer_state.dart';
import 'package:visioncompanion/features/analyzer/data/vision_api.dart';
import 'package:visioncompanion/features/history/data/history_repository.dart';
import 'package:visioncompanion/features/history/models/feature_type.dart';
import 'package:visioncompanion/features/settings/cubit/locale_cubit.dart';

class AnalyzerCubit extends Cubit<AnalyzerState> {
  AnalyzerCubit({
    required VisionApi api,
    required ImagePicker picker,
    required HistoryRepository history,
    required AnalyticsService analytics,
    required LocaleCubit locale,
  })  : _api = api,
        _picker = picker,
        _history = history,
        _analytics = analytics,
        _locale = locale,
        super(const AnalyzerIdle()) {
    _analytics.featureOpened(FeatureType.analyzer.name);
  }

  final VisionApi _api;
  final ImagePicker _picker;
  final HistoryRepository _history;
  final AnalyticsService _analytics;
  final LocaleCubit _locale;

  String? _lastPath;

  Future<void> capture() async {
    if (state is AnalyzerProcessing) return;

    try {
      final photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1280,
        imageQuality: 80,
      );
      if (photo == null) return;
      await _analyze(photo.path);
    } on PlatformException {
      emit(AnalyzerError(AnalyzerIssue.camera, imagePath: _lastPath));
    }
  }

  Future<void> retry() async {
    final path = _lastPath;
    if (path == null) {
      await capture();
    } else {
      await _analyze(path);
    }
  }

  Future<void> _analyze(String path) async {
    _lastPath = path;
    emit(AnalyzerProcessing(path));

    try {
      final bytes = await File(path).readAsBytes();
      final data = await _api.analyze(bytes, _locale.state.languageCode);
      if (isClosed) return;

      unawaited(_history.add(FeatureType.analyzer, data.summary));
      _analytics.imageAnalyzed(data.tags.length);
      emit(AnalyzerResult(data, path));
    } on VisionApiException catch (e) {
      if (!isClosed) emit(AnalyzerError(e.issue, imagePath: path));
    } catch (_) {
      if (!isClosed) emit(AnalyzerError(AnalyzerIssue.unknown, imagePath: path));
    }
  }
}
