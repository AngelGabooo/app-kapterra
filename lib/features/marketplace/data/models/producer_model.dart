class MarketplaceProducerModel {
  final String id;
  final String name;
  final int yearsExperience;
  final int totalLots;
  final bool isFeatured;
  final String imageUrl;
  final String location;

  MarketplaceProducerModel({
    required this.id,
    required this.name,
    required this.yearsExperience,
    required this.totalLots,
    required this.isFeatured,
    required this.imageUrl,
    required this.location,
  });
}