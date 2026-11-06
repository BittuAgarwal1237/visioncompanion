import 'package:equatable/equatable.dart';
import 'package:visioncompanion/features/history/models/history_entry.dart';

sealed class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => const [];
}

class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

class HistoryLoaded extends HistoryState {
  const HistoryLoaded(this.entries);

  final List<HistoryEntry> entries;

  @override
  List<Object?> get props => [entries];
}

class HistoryFailed extends HistoryState {
  const HistoryFailed();
}
