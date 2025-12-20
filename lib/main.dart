import 'package:flutter/services.dart';
import 'package:rentify/controller/home_controller.dart';
import 'package:rentify/routes/routes.dart';
import 'package:rentify/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());

  // device status bar icon color default to white color
  WidgetsBinding.instance.endOfFrame.then((_) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return ScreenUtilInit(
      designSize: Size(402, 874),
      useInheritedMediaQuery: true,
      minTextAdapt: true,
      splitScreenMode: true,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light),
        child: GetMaterialApp(debugShowCheckedModeBanner: false, theme: AppTheme.theme, getPages: Routes.routes, initialRoute: '/'),
      ),
    );
  }
}
