import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:weinber/core/connection/network_info.dart';


import '../../../../../core/constants/page_routes.dart';
import '../../Api/login_repository.dart';
import '../../Model/hive_login_model.dart';
import '../../Model/login_response.dart';


part 'login_notifier.g.dart';

@riverpod
class LoginNotifier extends _$LoginNotifier {
  late final AuthRepository _repo;
  late final AuthLocalStorage _local;
  late final NetworkInfo networkInfo;

  @override
  FutureOr<void> build() async {
    _repo = AuthRepository();
    _local = AuthLocalStorage.instance;
    networkInfo = NetworkInfoImpl(DataConnectionChecker());
    await _local.init();
  }

  Future<void> checkIfUserIsLoggedIn() async {
    final token = _local.getAccessToken();
    if (token != null && token.isNotEmpty) {
      router.go(routerHomePage);
    }else{
      router.go(routerLoginPage);
    }
  }

  Future<void> login({
    required String employeeId,
    required String password,
    required BuildContext context,
  }) async {
    state = const AsyncLoading();

    final connectivity = await Connectivity().checkConnectivity();
    print(connectivity[0]);


    //  No internet → Use saved token
    try {
      if (connectivity[0] == ConnectivityResult.none) {
        final token = _local.getAccessToken();
        if (token != null && token.isNotEmpty) {
          router.go(routerHomePage);
          state = const AsyncData(null);
          return;
        } else {
          state = AsyncError("No internet and no saved session.", StackTrace.current);
          return;
        }
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }

    try {
      final LoginResponse res = await _repo.login(
        employeeId: employeeId,
        password: password,
      );

      if (res.success) {
        await _local.saveLoginData(
          access: res.access,
          refresh: res.refresh,
          employeeId: res.employee.employeeId,
          employeeType: res.employee.employeeType,
          profilePic: res.employee.profilePic,
          appIcon: res.employee.appIcon,
        );

        router.go(routerHomePage);
        state = AsyncData(res);
      } else {
        state = AsyncError(res.message, StackTrace.current);
      }
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }
}
