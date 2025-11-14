import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';

// Tab Pages
import 'tabs/home_tab.dart';
import 'tabs/map_tab.dart';
import 'tabs/ai_chef_tab.dart';
import 'tabs/qr_scan_tab.dart';

// Other Screens
import '../history_screen.dart';
import '../about_screen.dart';
import '../auth/login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeTab(),
    const MapTab(),
    const AiChefTab(),
    const QrScanTab(),
  ];

  final List<String> _titles = [
    "GardaPangan",
    "Peta Makanan",
    "Chef AI Pintar",
    "Scan QR Mitra",
  ];

  /// Mengatur logika logout dan navigasi kembali ke login.
  Future<void> _handleLogout() async {
    await AuthService().logout();
    
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;
    final colorScheme = Theme.of(context).colorScheme;

    String displayName = "Warga GardaPangan";
    if (user != null && user.email != null) {
      displayName = user.email!.split('@')[0];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        centerTitle: true,
        // Warna AppBar mengambil dari Theme Global (app_theme.dart)
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      
      // --- SIDEBAR NAVIGATION ---
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Header Profil
            UserAccountsDrawerHeader(
              accountName: Text(
                "Halo, $displayName",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(user?.email ?? "Tamu"),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.grey),
              ),
              decoration: BoxDecoration(
                color: colorScheme.primary,
              ),
            ),
            
            // Menu Items
            _buildDrawerItem(Icons.home, "Beranda", 0),
            _buildDrawerItem(Icons.map, "Peta Rescue", 1),
            _buildDrawerItem(Icons.soup_kitchen, "Chef AI", 2),
            _buildDrawerItem(Icons.qr_code_scanner, "Scan Transaksi", 3),
            
            const Divider(),
            
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("Riwayat Pesanan"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("Tentang Aplikasi"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Keluar", style: TextStyle(color: Colors.red)),
              onTap: _handleLogout,
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }

  /// Helper widget untuk item drawer agar kode lebih ringkas
  Widget _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: _selectedIndex == index,
      selectedColor: Theme.of(context).colorScheme.primary,
      onTap: () {
        setState(() => _selectedIndex = index);
        Navigator.pop(context);
      },
    );
  }
}