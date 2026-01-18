import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Api/notes_repo.dart';
import '../../Model/notes_response_model.dart';


final notesNotifierProvider =
StateNotifierProvider<NotesNotifier, AsyncValue<NotesResponse>>(
      (ref) => NotesNotifier(),
);

class NotesNotifier extends StateNotifier<AsyncValue<NotesResponse>> {
  NotesNotifier() : super(const AsyncLoading()) {
    loadNotes();
  }

  final repo = NotesRepository();

  Future<void> loadNotes() async {
    try {
      state = const AsyncLoading();
      final data = await repo.fetchNotes();
      state = AsyncData(data);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() async => loadNotes();
}
