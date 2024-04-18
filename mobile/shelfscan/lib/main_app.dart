import 'package:ShelfScan/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:ShelfScan/screens/login_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColor.greenMAIN,
        ),
      ),
      home: const Login(),
    );
  }
}