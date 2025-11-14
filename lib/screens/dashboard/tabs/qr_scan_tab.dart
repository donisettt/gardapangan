import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Tab Scanner di Dashboard.
/// Berfungsi untuk scan QR umum dan menampilkan QR Code identitas user.
class QrScanTab extends StatefulWidget {
  const QrScanTab({super.key});

  @override
  State<QrScanTab> createState() => _QrScanTabState();
}

class _QrScanTabState extends State<QrScanTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Tab Bar Header
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            labelColor: colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: colorScheme.primary,
            indicatorWeight: 3,
            tabs: const [
              Tab(icon: Icon(Icons.qr_code_scanner), text: "Scan Umum"),
              Tab(icon: Icon(Icons.qr_code_2), text: "Kode Saya"),
            ],
          ),
        ),
        
        // Tab Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // TAB 1: SCANNER UMUM
              // (Fitur scan transaksi spesifik sudah ada di HistoryScreen)
              Stack(
                children: [
                  MobileScanner(
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        if (barcode.rawValue != null) {
                          // Menampilkan hasil scan sementara di SnackBar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Terdeteksi: ${barcode.rawValue}")),
                          );
                        }
                      }
                    },
                  ),
                  // Overlay Kotak Fokus
                  Center(
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(color: colorScheme.primary, width: 4),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  // Teks Petunjuk
                  const Positioned(
                    bottom: 50,
                    left: 0,
                    right: 0,
                    child: Text(
                      "Arahkan kamera ke QR Code",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white, 
                        fontSize: 16, 
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                      ),
                    ),
                  )
                ],
              ),

              // TAB 2: GENERATE QR CODE (IDENTITAS SAYA)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: QrImageView(
                        data: 'USER-ID-12345-DONI', // Data dummy identitas
                        version: QrVersions.auto,
                        size: 220.0,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Tunjukkan QR ini ke Mitra",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Untuk verifikasi pengambilan makanan",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}