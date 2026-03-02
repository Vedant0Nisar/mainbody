import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

import 'app/controllers/theme_controller.dart';

import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(ThemeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Main Body Portal',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF3F4F9),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D6EFD), // Blue from standard buttons
          primary: const Color(0xFF0D6EFD),
          surface: Colors.white,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF333333)), // Standard text color
          bodyMedium: TextStyle(color: Color(0xFF666666)), // Secondary text
        ),
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D6EFD), // Blue from standard buttons
          primary: const Color(0xFF0D6EFD),
          surface: const Color(0xFF1E1E1E),
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFEEEEEE)), // Standard text color
          bodyMedium: TextStyle(color: Color(0xFFAAAAAA)), // Secondary text
        ),
      ),
      themeMode: ThemeMode.system,
      initialRoute: Routes.LOGIN,
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
    );
  }
}

