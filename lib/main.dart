import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config/app_theme.dart';
import 'screens/splash_screen.dart';

void main() async {
  // Memastikan semua widget binding Flutter siap
  WidgetsFlutterBinding.ensureInitialized();
  
  // Menghubungkan aplikasi ke project Firebase
  await Firebase.initializeApp();

  // Menjalankan aplikasi
  runApp(const MyApp());
}

/// Widget root dari aplikasi GardaPangan.
class MyApp extends StatelessWidget {
  /// Konstruktor default untuk MyApp.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GardaPangan',
      
      // Menonaktifkan banner "DEBUG" di pojok kanan atas
      debugShowCheckedModeBanner: false,
      
      // Mengambil tema global dari file app_theme.dart
      theme: AppTheme.getTheme(),
      
      // Halaman pertama yang dibuka
      home: const SplashScreen(),
    );
  }
}