import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'login_notifier.dart';

part 'login_provider.g.dart';

@riverpod
LoginNotifier loginNotifier(LoginNotifierRef ref) => LoginNotifier();
