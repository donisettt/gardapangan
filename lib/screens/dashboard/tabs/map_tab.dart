import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/dummy_data.dart';
import '../../../data/models.dart';

/// Tab Peta Interaktif.
/// Menampilkan lokasi makanan dalam bentuk marker di peta.
/// User bisa klik marker untuk melihat detail dan melakukan booking.
class MapTab extends StatefulWidget {
  const MapTab({super.key});

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  /// Fungsi untuk memproses booking makanan ke Firestore.
  Future<void> _handleBooking(BuildContext context, FoodItem food) async {
    final user = FirebaseAuth.instance.currentUser;
    
    // 1. Validasi Login
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Silakan login dulu!")));
      return;
    }

    // Tutup BottomSheet sebelum dialog konfirmasi
    Navigator.pop(context); 

    // 2. Dialog Konfirmasi
    bool? confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Amankan Makanan?"),
        content: Text("Kamu akan membooking '${food.name}' di ${food.shopName}."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            child: const Text("Ya, Amankan!"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      if (!mounted) return;
      showDialog(
        context: context, 
        barrierDismissible: false, 
        builder: (c) => const Center(child: CircularProgressIndicator())
      );

      // 3. Kirim Data ke Firestore (Deadline 2 Jam)
      DateTime now = DateTime.now();
      DateTime deadline = now.add(const Duration(hours: 2)); 

      await FirebaseFirestore.instance.collection('pesanan').add({
        'food_name': food.name,
        'shop_name': food.shopName,
        'price': food.discountPrice,
        'image_url': food.imageUrl,
        'user_email': user.email,
        'user_uid': user.uid,
        'status': 'Menunggu Pengambilan',
        'order_time': FieldValue.serverTimestamp(),
        'deadline_time': Timestamp.fromDate(deadline),
      });

      if (!mounted) return;
      Navigator.pop(context); // Tutup Loading

      // 4. Sukses
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          icon: const Icon(Icons.check_circle, color: Colors.green, size: 60),
          title: const Text("Berhasil!"),
          content: const Text("Silakan cek menu Riwayat Pesanan."),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("OK"))],
        ),
      );

    } catch (e) {
      if (mounted) Navigator.pop(context);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal: $e")));
    }
  }

  /// Menampilkan detail makanan dalam Bottom Sheet.
  void _showLocationDetail(BuildContext context, FoodItem food) {
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle Bar
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      width: 50, height: 5,
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                    ),
                  ),

                  // Gambar Makanan
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      food.imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (c,e,s) => Container(height: 200, color: Colors.grey[300], child: const Icon(Icons.broken_image)),
                    ),
                  ),
                  
                  // Detail Info
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                food.name,
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.red[50], 
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red)
                              ),
                              child: Text("Sisa: ${food.stock}", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.store, color: Colors.grey, size: 18),
                            const SizedBox(width: 5),
                            Text(food.shopName, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 10),
                        
                        // Harga & Tombol Action
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Harga Spesial", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                                Text(
                                  currencyFormatter.format(food.discountPrice),
                                  style: TextStyle(
                                    fontSize: 24, 
                                    fontWeight: FontWeight.bold, 
                                    color: colorScheme.primary
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: () => _handleBooking(context, food),
                              icon: const Icon(Icons.shopping_bag_outlined),
                              label: const Text("AMANKAN"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 30), 
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(-6.914744, 107.609810), 
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.gardapangan',
          ),
          
          MarkerLayer(
            markers: dummyFoods.map((food) {
              return Marker(
                point: LatLng(food.latitude, food.longitude),
                width: 80,
                height: 80,
                child: GestureDetector(
                  onTap: () => _showLocationDetail(context, food),
                  child: _buildMarkerContent(food.shopName),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      
      // Tombol Recenter (Dummy)
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.my_location),
      ),
    );
  }

  // Widget Custom Marker (Pin Merah + Label Toko)
  Widget _buildMarkerContent(String shopName) {
    return Column(
      children: [
        const Icon(Icons.location_on, color: Colors.red, size: 40),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [const BoxShadow(blurRadius: 4, color: Colors.black26)]
          ),
          child: Text(
            shopName,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}