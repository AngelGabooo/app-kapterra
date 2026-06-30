class CooperativeModel {
  final String id;
  final String name;
  final String location;
  final int producersCount;
  final int farmsCount;
  final double totalProduction;
  final double monthlyAcopio;
  final double estimatedSales;
  final int traceableLots;
  final double traceabilityAverage;
  final int pendingAlerts;
  final double avgProfitability;
  final String status;

  CooperativeModel({
    required this.id,
    required this.name,
    required this.location,
    required this.producersCount,
    required this.farmsCount,
    required this.totalProduction,
    required this.monthlyAcopio,
    required this.estimatedSales,
    required this.traceableLots,
    required this.traceabilityAverage,
    required this.pendingAlerts,
    required this.avgProfitability,
    required this.status,
  });
}