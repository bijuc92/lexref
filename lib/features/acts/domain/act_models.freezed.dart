// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'act_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ActModel _$ActModelFromJson(Map<String, dynamic> json) {
  return _ActModel.fromJson(json);
}

/// @nodoc
mixin _$ActModel {
  String get id => throw _privateConstructorUsedError;
  String get shortName => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  int get year => throw _privateConstructorUsedError;
  String get jurisdiction => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  List<ChapterModel> get chapters => throw _privateConstructorUsedError;

  /// Serializes this ActModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActModelCopyWith<ActModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActModelCopyWith<$Res> {
  factory $ActModelCopyWith(ActModel value, $Res Function(ActModel) then) =
      _$ActModelCopyWithImpl<$Res, ActModel>;
  @useResult
  $Res call(
      {String id,
      String shortName,
      String fullName,
      int year,
      String jurisdiction,
      String category,
      List<ChapterModel> chapters});
}

/// @nodoc
class _$ActModelCopyWithImpl<$Res, $Val extends ActModel>
    implements $ActModelCopyWith<$Res> {
  _$ActModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? shortName = null,
    Object? fullName = null,
    Object? year = null,
    Object? jurisdiction = null,
    Object? category = null,
    Object? chapters = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      shortName: null == shortName
          ? _value.shortName
          : shortName // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      jurisdiction: null == jurisdiction
          ? _value.jurisdiction
          : jurisdiction // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      chapters: null == chapters
          ? _value.chapters
          : chapters // ignore: cast_nullable_to_non_nullable
              as List<ChapterModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActModelImplCopyWith<$Res>
    implements $ActModelCopyWith<$Res> {
  factory _$$ActModelImplCopyWith(
          _$ActModelImpl value, $Res Function(_$ActModelImpl) then) =
      __$$ActModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String shortName,
      String fullName,
      int year,
      String jurisdiction,
      String category,
      List<ChapterModel> chapters});
}

/// @nodoc
class __$$ActModelImplCopyWithImpl<$Res>
    extends _$ActModelCopyWithImpl<$Res, _$ActModelImpl>
    implements _$$ActModelImplCopyWith<$Res> {
  __$$ActModelImplCopyWithImpl(
      _$ActModelImpl _value, $Res Function(_$ActModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? shortName = null,
    Object? fullName = null,
    Object? year = null,
    Object? jurisdiction = null,
    Object? category = null,
    Object? chapters = null,
  }) {
    return _then(_$ActModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      shortName: null == shortName
          ? _value.shortName
          : shortName // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      jurisdiction: null == jurisdiction
          ? _value.jurisdiction
          : jurisdiction // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      chapters: null == chapters
          ? _value._chapters
          : chapters // ignore: cast_nullable_to_non_nullable
              as List<ChapterModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActModelImpl extends _ActModel {
  const _$ActModelImpl(
      {required this.id,
      required this.shortName,
      required this.fullName,
      required this.year,
      required this.jurisdiction,
      required this.category,
      required final List<ChapterModel> chapters})
      : _chapters = chapters,
        super._();

  factory _$ActModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActModelImplFromJson(json);

  @override
  final String id;
  @override
  final String shortName;
  @override
  final String fullName;
  @override
  final int year;
  @override
  final String jurisdiction;
  @override
  final String category;
  final List<ChapterModel> _chapters;
  @override
  List<ChapterModel> get chapters {
    if (_chapters is EqualUnmodifiableListView) return _chapters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_chapters);
  }

  @override
  String toString() {
    return 'ActModel(id: $id, shortName: $shortName, fullName: $fullName, year: $year, jurisdiction: $jurisdiction, category: $category, chapters: $chapters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.shortName, shortName) ||
                other.shortName == shortName) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.jurisdiction, jurisdiction) ||
                other.jurisdiction == jurisdiction) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._chapters, _chapters));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, shortName, fullName, year,
      jurisdiction, category, const DeepCollectionEquality().hash(_chapters));

  /// Create a copy of ActModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActModelImplCopyWith<_$ActModelImpl> get copyWith =>
      __$$ActModelImplCopyWithImpl<_$ActModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActModelImplToJson(
      this,
    );
  }
}

abstract class _ActModel extends ActModel {
  const factory _ActModel(
      {required final String id,
      required final String shortName,
      required final String fullName,
      required final int year,
      required final String jurisdiction,
      required final String category,
      required final List<ChapterModel> chapters}) = _$ActModelImpl;
  const _ActModel._() : super._();

  factory _ActModel.fromJson(Map<String, dynamic> json) =
      _$ActModelImpl.fromJson;

  @override
  String get id;
  @override
  String get shortName;
  @override
  String get fullName;
  @override
  int get year;
  @override
  String get jurisdiction;
  @override
  String get category;
  @override
  List<ChapterModel> get chapters;

  /// Create a copy of ActModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActModelImplCopyWith<_$ActModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChapterModel _$ChapterModelFromJson(Map<String, dynamic> json) {
  return _ChapterModel.fromJson(json);
}

/// @nodoc
mixin _$ChapterModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  List<SectionModel> get sections => throw _privateConstructorUsedError;

  /// Serializes this ChapterModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChapterModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChapterModelCopyWith<ChapterModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChapterModelCopyWith<$Res> {
  factory $ChapterModelCopyWith(
          ChapterModel value, $Res Function(ChapterModel) then) =
      _$ChapterModelCopyWithImpl<$Res, ChapterModel>;
  @useResult
  $Res call({String id, String title, List<SectionModel> sections});
}

/// @nodoc
class _$ChapterModelCopyWithImpl<$Res, $Val extends ChapterModel>
    implements $ChapterModelCopyWith<$Res> {
  _$ChapterModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChapterModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? sections = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      sections: null == sections
          ? _value.sections
          : sections // ignore: cast_nullable_to_non_nullable
              as List<SectionModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChapterModelImplCopyWith<$Res>
    implements $ChapterModelCopyWith<$Res> {
  factory _$$ChapterModelImplCopyWith(
          _$ChapterModelImpl value, $Res Function(_$ChapterModelImpl) then) =
      __$$ChapterModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String title, List<SectionModel> sections});
}

/// @nodoc
class __$$ChapterModelImplCopyWithImpl<$Res>
    extends _$ChapterModelCopyWithImpl<$Res, _$ChapterModelImpl>
    implements _$$ChapterModelImplCopyWith<$Res> {
  __$$ChapterModelImplCopyWithImpl(
      _$ChapterModelImpl _value, $Res Function(_$ChapterModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChapterModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? sections = null,
  }) {
    return _then(_$ChapterModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      sections: null == sections
          ? _value._sections
          : sections // ignore: cast_nullable_to_non_nullable
              as List<SectionModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChapterModelImpl implements _ChapterModel {
  const _$ChapterModelImpl(
      {required this.id,
      required this.title,
      required final List<SectionModel> sections})
      : _sections = sections;

  factory _$ChapterModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChapterModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  final List<SectionModel> _sections;
  @override
  List<SectionModel> get sections {
    if (_sections is EqualUnmodifiableListView) return _sections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sections);
  }

  @override
  String toString() {
    return 'ChapterModel(id: $id, title: $title, sections: $sections)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChapterModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._sections, _sections));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, const DeepCollectionEquality().hash(_sections));

  /// Create a copy of ChapterModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChapterModelImplCopyWith<_$ChapterModelImpl> get copyWith =>
      __$$ChapterModelImplCopyWithImpl<_$ChapterModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChapterModelImplToJson(
      this,
    );
  }
}

abstract class _ChapterModel implements ChapterModel {
  const factory _ChapterModel(
      {required final String id,
      required final String title,
      required final List<SectionModel> sections}) = _$ChapterModelImpl;

  factory _ChapterModel.fromJson(Map<String, dynamic> json) =
      _$ChapterModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  List<SectionModel> get sections;

  /// Create a copy of ChapterModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChapterModelImplCopyWith<_$ChapterModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SectionModel _$SectionModelFromJson(Map<String, dynamic> json) {
  return _SectionModel.fromJson(json);
}

/// @nodoc
mixin _$SectionModel {
  String get id => throw _privateConstructorUsedError;
  String get sectionNo => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  List<String> get relatedSections => throw _privateConstructorUsedError;

  /// Serializes this SectionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SectionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SectionModelCopyWith<SectionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SectionModelCopyWith<$Res> {
  factory $SectionModelCopyWith(
          SectionModel value, $Res Function(SectionModel) then) =
      _$SectionModelCopyWithImpl<$Res, SectionModel>;
  @useResult
  $Res call(
      {String id,
      String sectionNo,
      String title,
      String content,
      List<String> relatedSections});
}

/// @nodoc
class _$SectionModelCopyWithImpl<$Res, $Val extends SectionModel>
    implements $SectionModelCopyWith<$Res> {
  _$SectionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SectionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sectionNo = null,
    Object? title = null,
    Object? content = null,
    Object? relatedSections = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sectionNo: null == sectionNo
          ? _value.sectionNo
          : sectionNo // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      relatedSections: null == relatedSections
          ? _value.relatedSections
          : relatedSections // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SectionModelImplCopyWith<$Res>
    implements $SectionModelCopyWith<$Res> {
  factory _$$SectionModelImplCopyWith(
          _$SectionModelImpl value, $Res Function(_$SectionModelImpl) then) =
      __$$SectionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String sectionNo,
      String title,
      String content,
      List<String> relatedSections});
}

/// @nodoc
class __$$SectionModelImplCopyWithImpl<$Res>
    extends _$SectionModelCopyWithImpl<$Res, _$SectionModelImpl>
    implements _$$SectionModelImplCopyWith<$Res> {
  __$$SectionModelImplCopyWithImpl(
      _$SectionModelImpl _value, $Res Function(_$SectionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SectionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sectionNo = null,
    Object? title = null,
    Object? content = null,
    Object? relatedSections = null,
  }) {
    return _then(_$SectionModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sectionNo: null == sectionNo
          ? _value.sectionNo
          : sectionNo // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      relatedSections: null == relatedSections
          ? _value._relatedSections
          : relatedSections // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SectionModelImpl extends _SectionModel {
  const _$SectionModelImpl(
      {required this.id,
      required this.sectionNo,
      required this.title,
      required this.content,
      final List<String> relatedSections = const []})
      : _relatedSections = relatedSections,
        super._();

  factory _$SectionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SectionModelImplFromJson(json);

  @override
  final String id;
  @override
  final String sectionNo;
  @override
  final String title;
  @override
  final String content;
  final List<String> _relatedSections;
  @override
  @JsonKey()
  List<String> get relatedSections {
    if (_relatedSections is EqualUnmodifiableListView) return _relatedSections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_relatedSections);
  }

  @override
  String toString() {
    return 'SectionModel(id: $id, sectionNo: $sectionNo, title: $title, content: $content, relatedSections: $relatedSections)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SectionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sectionNo, sectionNo) ||
                other.sectionNo == sectionNo) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality()
                .equals(other._relatedSections, _relatedSections));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, sectionNo, title, content,
      const DeepCollectionEquality().hash(_relatedSections));

  /// Create a copy of SectionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SectionModelImplCopyWith<_$SectionModelImpl> get copyWith =>
      __$$SectionModelImplCopyWithImpl<_$SectionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SectionModelImplToJson(
      this,
    );
  }
}

abstract class _SectionModel extends SectionModel {
  const factory _SectionModel(
      {required final String id,
      required final String sectionNo,
      required final String title,
      required final String content,
      final List<String> relatedSections}) = _$SectionModelImpl;
  const _SectionModel._() : super._();

  factory _SectionModel.fromJson(Map<String, dynamic> json) =
      _$SectionModelImpl.fromJson;

  @override
  String get id;
  @override
  String get sectionNo;
  @override
  String get title;
  @override
  String get content;
  @override
  List<String> get relatedSections;

  /// Create a copy of SectionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SectionModelImplCopyWith<_$SectionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
