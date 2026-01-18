import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Api/home_repository.dart';
import '../../Model/homepage_response.dart';


final homeRepositoryProvider = Provider((ref) {
  return HomeRepository();
});

final homeNotifierProvider =
StateNotifierProvider<HomeNotifier, AsyncValue<HomeResponse>>((ref) {
  return HomeNotifier(ref.read(homeRepositoryProvider));
});

class HomeNotifier extends StateNotifier<AsyncValue<HomeResponse>> {
  final HomeRepository repo;

  HomeNotifier(this.repo) : super(const AsyncLoading()) {
    loadHome();
  }

  Future<void> loadHome() async {
    try {
      state = const AsyncLoading();
      final data = await repo.fetchHome();
      state = AsyncData(data);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() async {
    await loadHome();
  }
}
