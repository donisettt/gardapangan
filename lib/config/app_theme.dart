import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  
  // 1. WARNA UTAMA (LEBIH GELAP & ELEGAN)
  // ---------------------------------
  
  /// Hijau Tua (Forest Green) - Mirip Gojek/Grab
  /// Memberikan kontras yang sangat baik untuk teks putih di AppBar.
  static const Color primaryColor = Color(0xFF1B5E20); 
  
  /// Hijau Aksen (Sedikit lebih terang untuk variasi)
  static const Color accentColor = Color(0xFF43A047);

  /// Background default (Putih Tulang)
  static const Color backgroundColor = Color(0xFFF5F5F5);

  // 2. FUNGSI TEMA UTAMA
  // ---------------------------------
  static ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: accentColor,
        surface: backgroundColor,
        // Pastikan teks di atas warna primary berwarna putih
        onPrimary: Colors.white, 
        onSurface: Colors.black87,
      ),

      textTheme: GoogleFonts.poppinsTextTheme(),

      // KONFIGURASI APP BAR
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor, // Warna AppBar Hijau Tua
        foregroundColor: Colors.white, // Warna Teks & Ikon Putih
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Colors.white, // Paksa Putih
        ),
        iconTheme: const IconThemeData(color: Colors.white), // Paksa Ikon Putih
      ),

      // KONFIGURASI TOMBOL
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}