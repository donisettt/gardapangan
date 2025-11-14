import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import '../../../data/dummy_data.dart';
import '../../../data/models.dart';

/// Tab Beranda (Home).
/// Menampilkan daftar makanan yang tersedia untuk diselamatkan.
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  
  Position? _userPosition;
  bool _locationLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  /// Mengambil lokasi user saat ini.
  /// Jika gagal atau ditolak, menggunakan lokasi default (Bandung).
  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _useDefaultLocation(); 
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _useDefaultLocation();
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      _useDefaultLocation();
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium, 
        timeLimit: const Duration(seconds: 3),
      );
      
      if (!mounted) return;
      setState(() {
        _userPosition = position;
        _locationLoading = false;
      });
      
    } catch (e) {
      debugPrint("GPS Error: $e. Using Default Location.");
      _useDefaultLocation();
    }
  }

  /// Fallback jika GPS gagal.
  void _useDefaultLocation() {
    if (!mounted) return;
    setState(() {
      _userPosition = Position(
        longitude: 107.609810,
        latitude: -6.914744,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0, 
        altitudeAccuracy: 0, 
        headingAccuracy: 0
      );
      _locationLoading = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("GPS lambat, menggunakan lokasi estimasi (Bandung)."),
        duration: Duration(seconds: 2),
      )
    );
  }

  /// Menghitung jarak antara user dan toko.
  String _calculateDistance(double storeLat, double storeLng) {
    if (_userPosition == null) return "-";

    double distanceInMeters = Geolocator.distanceBetween(
      _userPosition!.latitude,
      _userPosition!.longitude,
      storeLat,
      storeLng,
    );

    if (distanceInMeters < 1000) {
      return "${distanceInMeters.toStringAsFixed(0)} m";
    } else {
      return "${(distanceInMeters / 1000).toStringAsFixed(1)} km";
    }
  }

  /// Proses booking makanan ke Firestore.
  Future<void> _handleBooking(BuildContext context, FoodItem food) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Silakan login dulu!")));
      return;
    }

    bool? confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Amankan Makanan?"),
        content: Text("Kamu akan membooking '${food.name}' di ${food.shopName}."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white
            ),
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

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          icon: const Icon(Icons.check_circle, color: Colors.green, size: 60),
          title: const Text("Berhasil Diamankan!"),
          content: const Text(
            "Makanan ini sudah jadi milikmu.\n\nSilakan datang ke toko dan tunjukkan QR Code di menu Riwayat untuk mengambilnya.",
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Siap!"))
          ],
        ),
      );

    } catch (e) {
      if (mounted) Navigator.pop(context);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dummyFoods.length,
        itemBuilder: (context, index) {
          final food = dummyFoods[index];
          String distanceInfo = _calculateDistance(food.latitude, food.longitude);
          
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    food.imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (c,e,s) => Container(height: 180, color: Colors.grey[300], child: const Icon(Icons.image_not_supported)),
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.red)),
                            child: Text("Sisa: ${food.stock} porsi", style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                          
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                Icon(Icons.location_on, size: 14, color: Colors.blue[700]),
                                const SizedBox(width: 4),
                                Text(
                                  distanceInfo,
                                  style: TextStyle(color: Colors.blue[700], fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(food.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(food.shopName, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(currencyFormatter.format(food.discountPrice), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorScheme.primary)),
                          const SizedBox(width: 10),
                          Text(currencyFormatter.format(food.originalPrice), style: const TextStyle(fontSize: 14, decoration: TextDecoration.lineThrough, color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _handleBooking(context, food), 
                          icon: const Icon(Icons.shopping_bag_outlined),
                          label: const Text("AMANKAN MAKANAN INI"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}