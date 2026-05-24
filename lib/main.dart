import 'package:flutter/material.dart';
import 'screens/signup_page.dart';
import 'constants/app_colors.dart';

void main() {
  runApp(const CircularJOApp());
}

class CircularJOApp extends StatelessWidget {
  const CircularJOApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circular JO',
      debugShowCheckedModeBanner: false,
      home: const SignUpPage(),
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.softBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryGreen,
        ),
      ),
    );
  }
}