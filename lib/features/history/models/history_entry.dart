import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:visioncompanion/features/history/models/feature_type.dart';

class HistoryEntry extends Equatable {
  const HistoryEntry({
    required this.id,
    required this.timestamp,
    required this.type,
    required this.summary,
    this.items = const [],
  });

  final String id;
  final DateTime timestamp;
  final FeatureType type;
  final String summary;

  /// Detector results saved as raw labels, so they can be shown in any language.
  final List<({String label, int percent})> items;

  factory HistoryEntry.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final stamp = data['timestamp'];

    return HistoryEntry(
      id: doc.id,
      timestamp: stamp is Timestamp ? stamp.toDate() : DateTime.now(),
      type: FeatureType.fromKey(data['featureType'] as String? ?? ''),
      summary: data['resultSummary'] as String? ?? '',
      items: _readItems(data['items']),
    );
  }

  static List<({String label, int percent})> _readItems(Object? raw) {
    if (raw is! List) return const [];
    return [
      for (final item in raw)
        if (item is Map && item['label'] is String)
          (
          label: item['label'] as String,
          percent: (item['percent'] as num?)?.toInt() ?? 0,
          ),
    ];
  }

  @override
  List<Object?> get props => [id, timestamp, type, summary, items];
}