import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'validation_scan_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final colorScheme = Theme.of(context).colorScheme;
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Pesanan"),
        // Menggunakan warna dari tema global
        backgroundColor: colorScheme.secondary, 
        foregroundColor: colorScheme.onSurface,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('pesanan')
            .where('user_email', isEqualTo: user?.email)
            .orderBy('order_time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    "Belum ada riwayat pesanan.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final docId = docs[index].id;
              final data = docs[index].data() as Map<String, dynamic>;
              
              String status = data['status'] ?? 'Proses';
              Timestamp? deadlineTs = data['deadline_time'];
              
              bool isExpired = false;
              String timeInfo = "";

              // Logika Cek Deadline
              if (deadlineTs != null) {
                DateTime deadlineDate = deadlineTs.toDate();
                
                if (DateTime.now().isAfter(deadlineDate) && status == 'Menunggu Pengambilan') {
                  isExpired = true;
                  status = "Waktu Habis";
                  
                  // Auto-update status di Firestore (Fire & Forget)
                  FirebaseFirestore.instance
                      .collection('pesanan')
                      .doc(docId)
                      .update({'status': 'Waktu Habis'});
                      
                } else {
                  String jam = DateFormat('HH:mm').format(deadlineDate);
                  timeInfo = "Batas: $jam";
                }
              }

              // Logika Warna Status
              Color statusColor = Colors.orange;
              if (status == 'Selesai') statusColor = Colors.green;
              if (status == 'Waktu Habis') statusColor = Colors.grey;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: isExpired ? 0 : 2,
                color: isExpired ? Colors.grey[100] : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      // Bagian Atas: Info Produk
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Gambar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              data['image_url'] ?? '',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (c,e,s) => Container(width: 80, height: 80, color: Colors.grey[300]),
                            ),
                          ),
                          const SizedBox(width: 12),
                          
                          // Teks Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['food_name'] ?? '-',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  data['shop_name'] ?? '-',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 4),
                                if (!isExpired && status == 'Menunggu Pengambilan')
                                  Row(
                                    children: [
                                      Icon(Icons.timer, size: 14, color: Colors.red[400]),
                                      const SizedBox(width: 4),
                                      Text(
                                        timeInfo,
                                        style: TextStyle(fontSize: 12, color: Colors.red[400], fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                const SizedBox(height: 4),
                                Text(
                                  currencyFormatter.format(data['price'] ?? 0),
                                  style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          
                          // Badge Status
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: statusColor.withOpacity(0.5))),
                            child: Text(
                              status,
                              style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      
                      // Bagian Bawah: Tombol Aksi
                      if (status == 'Menunggu Pengambilan' && !isExpired) ...[
                        const Divider(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ValidationScanScreen(
                                    orderId: docId,
                                    foodName: data['food_name'],
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.qr_code_scanner, size: 18),
                            label: const Text("SCAN QR TOKO UNTUK AMBIL"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        )
                      ]
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}