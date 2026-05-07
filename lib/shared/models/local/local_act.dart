class LocalAct {
  final String id;
  final String shortName;
  final String fullName;
  final int year;
  final String jurisdiction;
  final String category;

  const LocalAct({
    required this.id,
    required this.shortName,
    required this.fullName,
    required this.year,
    required this.jurisdiction,
    required this.category,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'short_name': shortName,
        'full_name': fullName,
        'year': year,
        'jurisdiction': jurisdiction,
        'category': category,
      };

  factory LocalAct.fromMap(Map<String, dynamic> m) => LocalAct(
        id: m['id'] as String,
        shortName: m['short_name'] as String,
        fullName: m['full_name'] as String,
        year: m['year'] as int,
        jurisdiction: m['jurisdiction'] as String,
        category: m['category'] as String,
      );
}
