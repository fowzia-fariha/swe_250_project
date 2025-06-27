import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_in_flutter/pages/1_onboarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodExpress',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const OnboardingScreen(), // 👈 Shows first
    );
  }
}
