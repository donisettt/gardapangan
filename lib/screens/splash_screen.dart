import 'dart:async';
import 'package:flutter/material.dart';
import 'auth/login_screen.dart';

/// Halaman pembuka aplikasi (Splash Screen).
/// Menampilkan logo dan loading selama 3 detik sebelum masuk ke Login.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startSplashTimer();
  }

  /// Memulai timer navigasi.
  void _startSplashTimer() {
    Timer(const Duration(seconds: 3), () {
      // Pastikan widget masih aktif sebelum navigasi (Best Practice)
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil konfigurasi tema global
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Utama
            const Icon(
              Icons.volunteer_activism,
              size: 100,
              color: Colors.white,
            ),
            
            const SizedBox(height: 20),
            
            // Judul Aplikasi
            Text(
              "GardaPangan",
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Tagline
            Text(
              "Selamatkan Makanan, Bantu Sesama",
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            
            const SizedBox(height: 50),
            
            // Loading Indicator
            const CircularProgressIndicator(
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}