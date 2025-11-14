import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/auth_service.dart';
import '../dashboard/dashboard_screen.dart';
import 'login_screen.dart';

/// Halaman Pendaftaran Akun Baru.
/// Menggunakan gaya desain "Floating Card" yang konsisten dengan Login Screen.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  bool _isObscure = true;
  bool _agreeToTerms = false;

  // Palet warna lokal
  final Color _primaryGreen = const Color(0xFF2E7D32);
  final Color _accentGreen = const Color(0xFF4CAF50);

  /// Memproses pendaftaran user ke Firebase Auth.
  void _handleRegister() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnackBar("Password konfirmasi tidak cocok!", Colors.red);
      return;
    }
    if (!_agreeToTerms) {
      _showSnackBar("Anda harus menyetujui Syarat & Ketentuan", Colors.orange);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await AuthService().register(
        email: _emailController.text,
        password: _passwordController.text,
      );
      
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } catch (e) {
      _showSnackBar("Gagal Daftar: ${e.toString()}", Theme.of(context).colorScheme.error);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Stack(
            children: [
              // Background Hijau Bawah
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: size.height * 0.40,
                child: Container(color: _primaryGreen),
              ),

              // Efek Gelombang
              Positioned(
                bottom: size.height * 0.39,
                left: 0,
                right: 0,
                child: ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    height: 100,
                    color: _primaryGreen,
                  ),
                ),
              ),

              // Header (Judul)
              Positioned(
                top: size.height * 0.10,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[50],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person_add_alt_1_rounded, size: 40, color: _primaryGreen),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Buat Akun Baru",
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "Bergabunglah dengan komunitas Food Rescue.",
                      style: textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              // Kartu Form
              Positioned(
                top: size.height * 0.28,
                left: 24,
                right: 24,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 25,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Email"),
                      _buildSoftInput(
                        controller: _emailController, 
                        hint: "nama@email.com", 
                        icon: Icons.email_outlined
                      ),
                      const SizedBox(height: 16),

                      _buildLabel("Kata Sandi"),
                      _buildSoftInput(
                        controller: _passwordController, 
                        hint: "Minimal 6 karakter", 
                        icon: Icons.lock_outline, 
                        isPassword: true
                      ),
                      const SizedBox(height: 16),

                      _buildLabel("Konfirmasi Sandi"),
                      _buildSoftInput(
                        controller: _confirmPasswordController, 
                        hint: "Ulangi kata sandi", 
                        icon: Icons.lock_reset, 
                        isPassword: true
                      ),
                      
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          SizedBox(
                            height: 24, width: 24,
                            child: Checkbox(
                              value: _agreeToTerms,
                              activeColor: _primaryGreen,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              onChanged: (val) => setState(() => _agreeToTerms = val!),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Saya setuju dengan Syarat & Ketentuan",
                              style: textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Container(
                              width: double.infinity,
                              height: 55,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [_primaryGreen, _accentGreen]),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [BoxShadow(color: _accentGreen.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 5))],
                              ),
                              child: ElevatedButton(
                                onPressed: _handleRegister,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                                child: Text(
                                  "Daftar Sekarang",
                                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ),
                      
                      const SizedBox(height: 20),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialBtn(Icons.g_mobiledata, Colors.red),
                          const SizedBox(width: 20),
                          _buildSocialBtn(Icons.facebook, Colors.blue),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Footer
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Sudah punya akun? ", style: textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        "Masuk Disini",
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[800]),
      ),
    );
  }

  Widget _buildSoftInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? _isObscure : false,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey, size: 20),
                  onPressed: () => setState(() => _isObscure = !_isObscure),
                )
              : null,
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildSocialBtn(IconData icon, Color color) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))],
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}

/// Class Clipper untuk membuat efek gelombang (Duplikasi dari Login agar file mandiri)
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, 20);
    var firstControlPoint = Offset(size.width / 4, 0);
    var firstEndPoint = Offset(size.width / 2.25, 30);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    var secondControlPoint = Offset(size.width - (size.width / 3.25), 65);
    var secondEndPoint = Offset(size.width, 40);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}