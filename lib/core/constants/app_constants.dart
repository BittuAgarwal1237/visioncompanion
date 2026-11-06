class AppConstants {
  AppConstants._();

  static const String modelAsset = 'assets/models/ssd_mobilenet_v1.tflite';
  static const String labelsAsset = 'assets/models/labelmap.txt';

  static const String localePref = 'app_locale';

  static const String usersCollection = 'users';
  static const String historyCollection = 'history';

  static const String groqEndpoint =
      'https://api.groq.com/openai/v1/chat/completions';
  static const List<String> groqModels = [
    'qwen/qwen3.8-27b'
  ];
  static const double minScore = 0.5;
  static const Duration announceGap = Duration(seconds: 2);
  static const Duration hapticGap = Duration(seconds: 1);
  static const Duration saveGap = Duration(seconds: 5);
}