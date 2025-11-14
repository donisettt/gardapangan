import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

/// Halaman profil yang menampilkan info pengembang aplikasi.
/// Menampilkan data statis dan link media sosial.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  /// Membuka URL eksternal di browser default (GitHub, LinkedIn, Instagram).
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // Idealnya, tampilkan SnackBar jika gagal
      debugPrint('Could not launch $url');
    }
  }

  /// Membuka aplikasi email default dengan data yang sudah terisi.
  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'donisetiawanwahyono@gmail.com',
      query: 'subject=Feedback Aplikasi GardaPangan&body=Halo Doni,\n\nSaya ingin memberikan masukan...',
    );
    if (!await launchUrl(emailLaunchUri)) {
      debugPrint('Could not launch email');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil palet warna dan tema font dari AppTheme
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface, // Background dari tema
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparan di atas header
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Tentang Pengembang",
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- HEADER & AVATAR ---
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Background Gradient
                Container(
                  height: 240,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [colorScheme.primary, colorScheme.secondary],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Icon(
                    Icons.volunteer_activism,
                    size: 100,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                // Foto Profil (Floating)
                Positioned(
                  bottom: -60,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5)),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 65,
                      backgroundImage: NetworkImage("https://avatars.githubusercontent.com/u/154044548?v=4"),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 70), // Spacer untuk avatar

            // --- INFO PROFIL ---
            Text(
              "Doni Setiawan Wahyono",
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              "Mobile Application Developer",
              style: textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
            ),
            
            const SizedBox(height: 20),

            // Versi Aplikasi (Chip)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colorScheme.primary.withOpacity(0.3)),
              ),
              child: Text(
                "GardaPangan v1.0.0 (Beta)",
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- KARTU DATA ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildInfoCard(context, Icons.badge, "Nomor Pokok Mahasiswa", "23552011146"),
                  const SizedBox(height: 12),
                  _buildInfoCard(context, Icons.class_, "Kelas", "TIF RP 23 CID A"),
                  const SizedBox(height: 12),
                  _buildInfoCard(context, Icons.school, "Universitas", "Universitas Teknologi Bandung"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- TOMBOL MEDIA SOSIAL ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSocialButton(
                    context,
                    icon: Icons.camera_alt,
                    label: "Instagram",
                    color: Colors.purple,
                    onTap: () => _launchURL("https://www.instagram.com/dnisetyaw"),
                  ),
                  _buildSocialButton(
                    context,
                    icon: Icons.code,
                    label: "GitHub",
                    color: Colors.black,
                    onTap: () => _launchURL("https://www.github.com/donisettt"),
                  ),
                  _buildSocialButton(
                    context,
                    icon: Icons.business_center,
                    label: "LinkedIn",
                    color: Colors.blue[800]!,
                    onTap: () => _launchURL("https://www.linkedin.com/in/doni-setiawan-wahyono"),
                  ),
                  _buildSocialButton(
                    context,
                    icon: Icons.email,
                    label: "Email",
                    color: Colors.red[400]!,
                    onTap: () => _launchEmail(),
                  ),
                ],
              ),
            ),

            // --- FOOTER ---
            const SizedBox(height: 40),
            Text(
              "© 2025 Doni Sw • Made with Flutter",
              style: textTheme.bodySmall?.copyWith(color: Colors.grey[400]),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Menggunakan [context] untuk mengakses tema.
  Widget _buildInfoCard(BuildContext context, IconData icon, String title, String value) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
                ),
                Text(
                  value,
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Widget helper untuk membangun tombol media sosial.
  Widget _buildSocialButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Area klik
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2)),
                ],
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}