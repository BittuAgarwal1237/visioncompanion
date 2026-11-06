import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visioncompanion/features/history/cubit/history_state.dart';
import 'package:visioncompanion/features/history/data/history_repository.dart';
import 'package:visioncompanion/features/history/models/history_entry.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit(this._repo) : super(const HistoryLoading());

  final HistoryRepository _repo;
  StreamSubscription<List<HistoryEntry>>? _subscription;

  void watch() {
    _subscription?.cancel();
    emit(const HistoryLoading());
    _subscription = _repo.watch().listen(
      (entries) => emit(HistoryLoaded(entries)),
      onError: (_) => emit(const HistoryFailed()),
    );
  }

  Future<void> remove(String id) => _repo.remove(id);

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
