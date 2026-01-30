import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:whispr_app/core/controllers/posts_controller.dart';
import 'package:whispr_app/core/controllers/session_controller.dart';
import 'package:whispr_app/features/splash/screen/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize global controllers
  Get.put(SessionController(), permanent: true);
  Get.put(PostsController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ScreenUtilInit(
      designSize: Size(size.width, size.height),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Whispr',
          theme: ThemeData.dark(),
          home: const SplashScreen(),
        );
      },
    );
  }
}
