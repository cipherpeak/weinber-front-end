import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../Api/home_repository.dart';
import '../../../Authentication/Login/Model/hive_login_model.dart';
import '../../Database/home_local_storage.dart';
import '../../Model/homepage_response.dart';

part 'home_notifier.g.dart';

@riverpod
class HomeNotifier extends _$HomeNotifier {
  late final HomeRepository _repo;
  late final HomeLocalStorage _local;
  late final AuthLocalStorage _auth;

  @override
  FutureOr<HomeResponse?> build() async {
    _local = HomeLocalStorage();
    await _local.init();

    _auth = AuthLocalStorage.instance;
    final token = _auth.getAccessToken();

    _repo = HomeRepository(_local);

    if (token == null) return null;

    return await _repo.fetchHomeData(token);
  }

  Future<void> refreshData() async {
    final token = _auth.getAccessToken();
    if (token == null) return;

    final data = await _repo.fetchHomeData(token);
    state = AsyncData(data);
  }
}
