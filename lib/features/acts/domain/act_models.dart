class ActModel {
  final String id;
  final String shortName;
  final String fullName;
  final int year;
  final String jurisdiction;
  final String category;
  final List<ChapterModel> chapters;

  const ActModel({
    required this.id,
    required this.shortName,
    required this.fullName,
    required this.year,
    required this.jurisdiction,
    required this.category,
    required this.chapters,
  });

  int get totalSections =>
      chapters.fold(0, (sum, ch) => sum + ch.sections.length);

  factory ActModel.fromJson(Map<String, dynamic> j) => ActModel(
        id: j['id'] as String,
        shortName: j['shortName'] as String,
        fullName: j['fullName'] as String,
        year: j['year'] as int,
        jurisdiction: j['jurisdiction'] as String,
        category: j['category'] as String,
        chapters: (j['chapters'] as List)
            .map((c) => ChapterModel.fromJson(c as Map<String, dynamic>))
            .toList(),
      );
}

class ChapterModel {
  final String id;
  final String title;
  final List<SectionModel> sections;

  const ChapterModel({
    required this.id,
    required this.title,
    required this.sections,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> j) => ChapterModel(
        id: j['id'] as String,
        title: j['title'] as String,
        sections: (j['sections'] as List)
            .map((s) => SectionModel.fromJson(s as Map<String, dynamic>))
            .toList(),
      );
}

class SectionModel {
  final String id;
  final String sectionNo;
  final String title;
  final String content;
  final List<String> relatedSections;

  const SectionModel({
    required this.id,
    required this.sectionNo,
    required this.title,
    required this.content,
    this.relatedSections = const [],
  });

  factory SectionModel.fromJson(Map<String, dynamic> j) => SectionModel(
        id: j['id'] as String,
        sectionNo: j['sectionNo'] as String,
        title: j['title'] as String,
        content: j['content'] as String,
        relatedSections: j['relatedSections'] != null
            ? List<String>.from(j['relatedSections'] as List)
            : [],
      );
}
