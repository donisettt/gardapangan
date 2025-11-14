import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Halaman scanner khusus untuk memvalidasi pengambilan pesanan.
/// Mengupdate status pesanan di Firestore menjadi 'Selesai' setelah scan berhasil.
class ValidationScanScreen extends StatefulWidget {
  final String orderId;
  final String foodName;

  const ValidationScanScreen({
    super.key,
    required this.orderId,
    required this.foodName,
  });

  @override
  State<ValidationScanScreen> createState() => _ValidationScanScreenState();
}

class _ValidationScanScreenState extends State<ValidationScanScreen> {
  bool _isProcessing = false;

  /// Memproses logika setelah QR Code terdeteksi.
  /// Mengupdate data di Firestore dan memberikan feedback ke user.
  void _handleScan(String code) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    try {
      // Tampilkan indikator loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (c) => const Center(child: CircularProgressIndicator()),
      );

      // Update status pesanan menjadi 'Selesai'
      await FirebaseFirestore.instance
          .collection('pesanan')
          .doc(widget.orderId)
          .update({
            'status': 'Selesai',
            'picked_up_at': FieldValue.serverTimestamp(),
          });

      if (!mounted) return;

      // Tutup Loading & Kembali ke halaman sebelumnya
      Navigator.pop(context); 
      Navigator.pop(context); 

      // Tampilkan notifikasi sukses (SnackBar)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Berhasil! ${widget.foodName} telah diambil."),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );

    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Tutup loading jika error
      
      setState(() => _isProcessing = false); // Reset agar bisa scan ulang
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal memproses data: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR Toko")),
      body: Stack(
        children: [
          // 1. Kamera Scanner
          MobileScanner(
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  _handleScan(barcode.rawValue!);
                }
              }
            },
          ),

          // 2. Overlay Visual (Kotak Fokus)
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 4),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 10)
                ],
              ),
            ),
          ),

          // 3. Instruksi Teks di Bawah
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Scan QR Code di Kasir Toko\nuntuk mengambil: ${widget.foodName}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}