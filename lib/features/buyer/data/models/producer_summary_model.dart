class ProducerSummaryModel {
  final String id;
  final String name;
  final double production;
  final double traceability;
  final double profitability;
  final int rank;

  ProducerSummaryModel({
    required this.id,
    required this.name,
    required this.production,
    required this.traceability,
    required this.profitability,
    required this.rank,
  });
}