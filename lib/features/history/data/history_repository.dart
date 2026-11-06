import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:visioncompanion/core/constants/app_constants.dart';
import 'package:visioncompanion/features/auth/data/auth_repository.dart';
import 'package:visioncompanion/features/history/models/feature_type.dart';
import 'package:visioncompanion/features/history/models/history_entry.dart';

class HistoryRepository {
  HistoryRepository(this._db, this._auth);

  final FirebaseFirestore _db;
  final AuthRepository _auth;

  CollectionReference<Map<String, dynamic>> _entries(String uid) {
    return _db
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .collection(AppConstants.historyCollection);
  }

  Future<void> add(
      FeatureType type,
      String summary, {
        List<Map<String, Object>>? items,
      }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      await _entries(uid).add({
        'timestamp': FieldValue.serverTimestamp(),
        'featureType': type.name,
        'resultSummary': summary,
        if (items != null) 'items': items,
      });
    } catch (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
  }

  Stream<List<HistoryEntry>> watch() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return _entries(uid)
        .orderBy('timestamp', descending: true)
        .limit(100)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(HistoryEntry.fromDoc).toList());
  }

  Future<void> remove(String id) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    await _entries(uid).doc(id).delete();
  }
}