import 'package:freezed_annotation/freezed_annotation.dart';

part 'act_models.freezed.dart';
part 'act_models.g.dart';

@freezed
class ActModel with _$ActModel {
  const ActModel._();

  const factory ActModel({
    required String id,
    required String shortName,
    required String fullName,
    required int year,
    required String jurisdiction,
    required String category,
    required List<ChapterModel> chapters,
  }) = _ActModel;

  factory ActModel.fromJson(Map<String, dynamic> json) =>
      _$ActModelFromJson(json);

  int get totalSections =>
      chapters.fold(0, (sum, ch) => sum + ch.sections.length);
}

@freezed
class ChapterModel with _$ChapterModel {
  const factory ChapterModel({
    required String id,
    required String title,
    required List<SectionModel> sections,
  }) = _ChapterModel;

  factory ChapterModel.fromJson(Map<String, dynamic> json) =>
      _$ChapterModelFromJson(json);
}

@freezed
class SectionModel with _$SectionModel {
  const SectionModel._();

  const factory SectionModel({
    required String id,
    required String sectionNo,
    required String title,
    required String content,
    @Default([]) List<String> relatedSections,
  }) = _SectionModel;

  factory SectionModel.fromJson(Map<String, dynamic> json) =>
      _$SectionModelFromJson(json);
}
