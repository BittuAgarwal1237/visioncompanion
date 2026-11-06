import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:visioncompanion/core/constants/app_constants.dart';
import 'package:visioncompanion/features/analyzer/cubit/analyzer_state.dart';
import 'package:visioncompanion/features/analyzer/models/analysis_data.dart';

class VisionApiException implements Exception {
  const VisionApiException(this.issue);

  final AnalyzerIssue issue;
}

class VisionApi {
  VisionApi(this._client);

  final http.Client _client;

  Future<AnalysisData> analyze(Uint8List image, String languageCode) async {
    final key = (dotenv.env['GROQ_API_KEY'] ?? '').trim();
    if (key.isEmpty || key == 'paste_your_groq_key_here') {
      throw const VisionApiException(AnalyzerIssue.missingKey);
    }

    final language = languageCode == 'hi' ? 'Hindi' : 'English';
    final prompt = 'Look at this photo and reply with JSON only, shaped like '
        '{"description": "two short sentences about what is in the photo", '
        '"tags": [{"name": "one or two words", "confidence": 0-100}]}. '
        'Give between 5 and 8 tags covering the main objects, the setting and '
        'the mood. Write every description and tag in $language.';

    http.Response? response;
    for (final model in AppConstants.groqModels) {
      final body = jsonEncode({
        'model': model,
        'temperature': 0.2,
        'max_completion_tokens': 2000,
        'response_format': {'type': 'json_object'},
        'messages': [
          {
            'role': 'user',
            'content': [
              {'type': 'text', 'text': prompt},
              {
                'type': 'image_url',
                'image_url': {
                  'url': 'data:image/jpeg;base64,${base64Encode(image)}'
                },
              },
            ],
          },
        ],
      });

      response = await _send(key, body);
      if (response.statusCode != 200) {
        debugPrint('Groq error ($model) ${response.statusCode}: ${response.body}');
      }
      // Model nahi mila to agla model try karo
      if (response.statusCode == 404 || response.statusCode == 400) continue;
      break;
    }



    response = response!;

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw const VisionApiException(AnalyzerIssue.badKey);
    }
    if (response.statusCode != 200) {
      throw const VisionApiException(AnalyzerIssue.busy);
    }

    return _parse(response);
  }

  Future<http.Response> _send(String key, String body) async {
    try {
      return await _client
          .post(
        Uri.parse(AppConstants.groqEndpoint),
        headers: {
          'Authorization': 'Bearer $key',
          'Content-Type': 'application/json',
        },
        body: body,
      )
          .timeout(const Duration(seconds: 40));
    } on TimeoutException {
      throw const VisionApiException(AnalyzerIssue.timeout);
    } on SocketException {
      throw const VisionApiException(AnalyzerIssue.noInternet);
    } on http.ClientException {
      throw const VisionApiException(AnalyzerIssue.noInternet);
    }
  }

  AnalysisData _parse(http.Response response) {
    try {
      final outer = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      final choices = outer['choices'] as List;
      final message = (choices.first as Map<String, dynamic>)['message'] as Map<String, dynamic>;
      final raw = message['content'] as String;
      final start = raw.indexOf('{');
      final end = raw.lastIndexOf('}');
      final inner = jsonDecode(raw.substring(start, end + 1)) as Map<String, dynamic>;

      final tags = (inner['tags'] as List).map((raw) {
        final tag = raw as Map<String, dynamic>;
        final value = (tag['confidence'] as num).toDouble();
        final percent = (value <= 1 ? value * 100 : value).round().clamp(0, 100);
        return AnalysisTag(name: tag['name'].toString().trim(), confidence: percent.toInt());
      }).where((tag) => tag.name.isNotEmpty).toList()
        ..sort((a, b) => b.confidence.compareTo(a.confidence));

      final description = (inner['description'] as String).trim();
      if (description.isEmpty && tags.isEmpty) {
        throw const FormatException();
      }
      return AnalysisData(description: description, tags: tags);
    } catch (_) {
      throw const VisionApiException(AnalyzerIssue.parse);
    }
  }
}