import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants/app_theme.dart';
import 'core/constants/constants.dart';
import 'core/constants/page_routes.dart';
import 'core/services/api_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox("authBox");

  await ApiService.init();

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize:
      MediaQuery.sizeOf(context).width >= 768 ? const Size(1080, 1920) : const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery.withClampedTextScaling(
            minScaleFactor: 1.sp,
            maxScaleFactor: 1.sp,
            child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: appName,
                theme: lightTheme,
                routerConfig: router,
              ),
            ),
          ),
        );
      },
    );
  }
}
