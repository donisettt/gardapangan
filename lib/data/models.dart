/// Model data yang merepresentasikan item makanan dalam aplikasi.
class FoodItem {
  final String id;
  final String name;
  final String shopName;
  final String imageUrl;
  final double originalPrice;
  final double discountPrice;
  final double latitude;
  final double longitude;
  final int stock;

  const FoodItem({
    required this.id,
    required this.name,
    required this.shopName,
    required this.imageUrl,
    required this.originalPrice,
    required this.discountPrice,
    required this.latitude,
    required this.longitude,
    required this.stock,
  });
}