import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_act.freezed.dart';

@freezed
class LocalAct with _$LocalAct {
  const LocalAct._();

  const factory LocalAct({
    required String id,
    required String shortName,
    required String fullName,
    required int year,
    required String jurisdiction,
    required String category,
  }) = _LocalAct;

  factory LocalAct.fromMap(Map<String, dynamic> m) => LocalAct(
        id: m['id'] as String,
        shortName: m['short_name'] as String,
        fullName: m['full_name'] as String,
        year: m['year'] as int,
        jurisdiction: m['jurisdiction'] as String,
        category: m['category'] as String,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'short_name': shortName,
        'full_name': fullName,
        'year': year,
        'jurisdiction': jurisdiction,
        'category': category,
      };
}
