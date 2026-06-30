class MarketplaceLotModel {
  final String id;
  final String name;
  final String producerName;
  final String location;
  final double price;
  final double availableQuantity;
  final double rating;
  final String imageUrl;
  final bool isVerified;
  final String category;
  final String description;

  MarketplaceLotModel({
    required this.id,
    required this.name,
    required this.producerName,
    required this.location,
    required this.price,
    required this.availableQuantity,
    required this.rating,
    required this.imageUrl,
    required this.isVerified,
    required this.category,
    required this.description,
  });
}