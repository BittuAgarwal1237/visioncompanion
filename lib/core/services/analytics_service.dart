import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  AnalyticsService(this._analytics);

  final FirebaseAnalytics _analytics;

  Future<void> featureOpened(String feature) {
    return _analytics.logEvent(
      name: 'feature_opened',
      parameters: {'feature': feature},
    );
  }

  Future<void> detectionCompleted(String topLabel, int objectCount) {
    return _analytics.logEvent(
      name: 'detection_completed',
      parameters: {'top_label': topLabel, 'object_count': objectCount},
    );
  }

  Future<void> imageAnalyzed(int tagCount) {
    return _analytics.logEvent(
      name: 'image_analyzed',
      parameters: {'tag_count': tagCount},
    );
  }
}
