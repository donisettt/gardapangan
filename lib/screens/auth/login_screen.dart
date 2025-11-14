import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/auth_service.dart';
import '../dashboard/dashboard_screen.dart';
import 'register_screen.dart';

/// Halaman Login dengan desain "Floating Card" dan "Wave" background.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isObscure = true;
  bool _rememberMe = false;

  // Palet warna lokal untuk UI halaman ini
  final Color _primaryGreen = const Color(0xFF2E7D32);
  final Color _accentGreen = const Color(0xFF4CAF50);

  /// Menangani proses login menggunakan Firebase Auth.
  void _handleLogin() async {
    setState(() => _isLoading = true);
    try {
      await AuthService().login(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal Masuk: ${e.toString()}"),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
              // Background Bawah (Hijau)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: size.height * 0.5,
                child: Container(color: _primaryGreen),
              ),

              // Efek Gelombang
              Positioned(
                bottom: size.height * 0.49,
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

              // Header (Logo & Teks)
              Positioned(
                top: size.height * 0.12,
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
                      child: Icon(Icons.lock_open_rounded, size: 50, color: _primaryGreen),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Selamat Datang!",
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        "Masuk untuk mulai menyelamatkan makanan.",
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
              ),

              // Kartu Form Login
              Positioned(
                top: size.height * 0.35,
                left: 24,
                right: 24,
                child: Container(
                  padding: const EdgeInsets.all(28),
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
                      Text(
                        "Akun Login",
                        style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),

                      _buildSoftInput(
                        controller: _emailController,
                        hint: "Alamat Email",
                        icon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 16),

                      _buildSoftInput(
                        controller: _passwordController,
                        hint: "Kata Sandi",
                        icon: Icons.lock_outline,
                        isPassword: true,
                      ),
                      
                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                height: 24, width: 24,
                                child: Checkbox(
                                  value: _rememberMe,
                                  activeColor: _primaryGreen,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  onChanged: (val) => setState(() => _rememberMe = val!),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text("Simpan Sandi", style: textTheme.bodySmall?.copyWith(color: Colors.grey[700])),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "Lupa Sandi?",
                              style: textTheme.bodySmall?.copyWith(color: _primaryGreen, fontWeight: FontWeight.bold),
                            ),
                          )
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
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: Text(
                            "Masuk Sekarang",
                            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text("Atau masuk dengan", style: textTheme.bodySmall?.copyWith(color: Colors.grey[500])),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialBtn(Icons.g_mobiledata, Colors.red),
                          const SizedBox(width: 20),
                          _buildSocialBtn(Icons.facebook, Colors.blue),
                          const SizedBox(width: 20),
                          _buildSocialBtn(Icons.apple, Colors.black),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Footer
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Belum punya akun? ", style: textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const RegisterScreen())),
                      child: Text(
                        "Daftar Disini",
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

  /// Widget helper untuk input field (Email & Password).
  Widget _buildSoftInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
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
          prefixIcon: Icon(icon, color: Colors.grey[400], size: 22),
          suffixIcon: isPassword 
            ? IconButton(
                icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                onPressed: () => setState(() => _isObscure = !_isObscure),
              ) 
            : null,
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  /// Widget helper untuk tombol media sosial (dummy).
  Widget _buildSocialBtn(IconData icon, Color color) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))
        ],
      ),
      child: Icon(icon, color: color, size: 28),
    );
  }
}

/// Class Clipper untuk membuat efek gelombang pada background.
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, 20);
    var firstControlPoint = Offset(size.width / 4, 0);
    var firstEndPoint = Offset(size.width / 2.25, 30);
    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    var secondControlPoint = Offset(size.width - (size.width / 3.25), 65);
    var secondEndPoint = Offset(size.width, 40);
    path.quadraticBezierTo(
        secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}