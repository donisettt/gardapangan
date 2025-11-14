import 'models.dart';

/// Data dummy untuk simulasi daftar makanan yang tersedia.
/// Digunakan saat aplikasi belum terhubung ke backend penuh atau untuk keperluan demo.
List<FoodItem> dummyFoods = [
  const FoodItem(
    id: '1',
    name: 'Roti Bakar Coklat (Sisa 2)',
    shopName: 'Bakery Pak Budi',
    imageUrl: 'https://plus.unsplash.com/premium_photo-1695239201469-9f0ed3ad8d65?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1yZWxhdGVkfDE0fHx8ZW58MHx8fHx8',
    originalPrice: 15000,
    discountPrice: 7500,
    latitude: -6.914744,
    longitude: 107.609810,
    stock: 2,
  ),
  const FoodItem(
    id: '2',
    name: 'Nasi Goreng Spesial (Last Order)',
    shopName: 'Warung Bu Siti',
    imageUrl: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?auto=format&fit=crop&w=800&q=80',
    originalPrice: 20000,
    discountPrice: 10000,
    latitude: -6.921234,
    longitude: 107.610000,
    stock: 5,
  ),
];