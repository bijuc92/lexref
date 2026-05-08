// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'act_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActModelImpl _$$ActModelImplFromJson(Map<String, dynamic> json) =>
    _$ActModelImpl(
      id: json['id'] as String,
      shortName: json['shortName'] as String,
      fullName: json['fullName'] as String,
      year: (json['year'] as num).toInt(),
      jurisdiction: json['jurisdiction'] as String,
      category: json['category'] as String,
      chapters: (json['chapters'] as List<dynamic>)
          .map((e) => ChapterModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ActModelImplToJson(_$ActModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shortName': instance.shortName,
      'fullName': instance.fullName,
      'year': instance.year,
      'jurisdiction': instance.jurisdiction,
      'category': instance.category,
      'chapters': instance.chapters,
    };

_$ChapterModelImpl _$$ChapterModelImplFromJson(Map<String, dynamic> json) =>
    _$ChapterModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      sections: (json['sections'] as List<dynamic>)
          .map((e) => SectionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ChapterModelImplToJson(_$ChapterModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'sections': instance.sections,
    };

_$SectionModelImpl _$$SectionModelImplFromJson(Map<String, dynamic> json) =>
    _$SectionModelImpl(
      id: json['id'] as String,
      sectionNo: json['sectionNo'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      relatedSections: (json['relatedSections'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      crossReferences: (json['crossReferences'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
    );

Map<String, dynamic> _$$SectionModelImplToJson(_$SectionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sectionNo': instance.sectionNo,
      'title': instance.title,
      'content': instance.content,
      'relatedSections': instance.relatedSections,
      'crossReferences': instance.crossReferences,
    };
