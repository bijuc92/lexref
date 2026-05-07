// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'case_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CaseResult {
  String get docId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get citation => throw _privateConstructorUsedError;
  String get court => throw _privateConstructorUsedError;
  int? get year => throw _privateConstructorUsedError;
  String? get summary => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;
  List<String> get sectionsCited => throw _privateConstructorUsedError;

  /// Create a copy of CaseResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CaseResultCopyWith<CaseResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CaseResultCopyWith<$Res> {
  factory $CaseResultCopyWith(
          CaseResult value, $Res Function(CaseResult) then) =
      _$CaseResultCopyWithImpl<$Res, CaseResult>;
  @useResult
  $Res call(
      {String docId,
      String title,
      String? citation,
      String court,
      int? year,
      String? summary,
      String? url,
      List<String> sectionsCited});
}

/// @nodoc
class _$CaseResultCopyWithImpl<$Res, $Val extends CaseResult>
    implements $CaseResultCopyWith<$Res> {
  _$CaseResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CaseResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? docId = null,
    Object? title = null,
    Object? citation = freezed,
    Object? court = null,
    Object? year = freezed,
    Object? summary = freezed,
    Object? url = freezed,
    Object? sectionsCited = null,
  }) {
    return _then(_value.copyWith(
      docId: null == docId
          ? _value.docId
          : docId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      citation: freezed == citation
          ? _value.citation
          : citation // ignore: cast_nullable_to_non_nullable
              as String?,
      court: null == court
          ? _value.court
          : court // ignore: cast_nullable_to_non_nullable
              as String,
      year: freezed == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int?,
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      sectionsCited: null == sectionsCited
          ? _value.sectionsCited
          : sectionsCited // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CaseResultImplCopyWith<$Res>
    implements $CaseResultCopyWith<$Res> {
  factory _$$CaseResultImplCopyWith(
          _$CaseResultImpl value, $Res Function(_$CaseResultImpl) then) =
      __$$CaseResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String docId,
      String title,
      String? citation,
      String court,
      int? year,
      String? summary,
      String? url,
      List<String> sectionsCited});
}

/// @nodoc
class __$$CaseResultImplCopyWithImpl<$Res>
    extends _$CaseResultCopyWithImpl<$Res, _$CaseResultImpl>
    implements _$$CaseResultImplCopyWith<$Res> {
  __$$CaseResultImplCopyWithImpl(
      _$CaseResultImpl _value, $Res Function(_$CaseResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of CaseResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? docId = null,
    Object? title = null,
    Object? citation = freezed,
    Object? court = null,
    Object? year = freezed,
    Object? summary = freezed,
    Object? url = freezed,
    Object? sectionsCited = null,
  }) {
    return _then(_$CaseResultImpl(
      docId: null == docId
          ? _value.docId
          : docId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      citation: freezed == citation
          ? _value.citation
          : citation // ignore: cast_nullable_to_non_nullable
              as String?,
      court: null == court
          ? _value.court
          : court // ignore: cast_nullable_to_non_nullable
              as String,
      year: freezed == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int?,
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      sectionsCited: null == sectionsCited
          ? _value._sectionsCited
          : sectionsCited // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$CaseResultImpl extends _CaseResult {
  const _$CaseResultImpl(
      {required this.docId,
      required this.title,
      this.citation,
      required this.court,
      this.year,
      this.summary,
      this.url,
      final List<String> sectionsCited = const []})
      : _sectionsCited = sectionsCited,
        super._();

  @override
  final String docId;
  @override
  final String title;
  @override
  final String? citation;
  @override
  final String court;
  @override
  final int? year;
  @override
  final String? summary;
  @override
  final String? url;
  final List<String> _sectionsCited;
  @override
  @JsonKey()
  List<String> get sectionsCited {
    if (_sectionsCited is EqualUnmodifiableListView) return _sectionsCited;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sectionsCited);
  }

  @override
  String toString() {
    return 'CaseResult(docId: $docId, title: $title, citation: $citation, court: $court, year: $year, summary: $summary, url: $url, sectionsCited: $sectionsCited)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CaseResultImpl &&
            (identical(other.docId, docId) || other.docId == docId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.citation, citation) ||
                other.citation == citation) &&
            (identical(other.court, court) || other.court == court) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.url, url) || other.url == url) &&
            const DeepCollectionEquality()
                .equals(other._sectionsCited, _sectionsCited));
  }

  @override
  int get hashCode => Object.hash(runtimeType, docId, title, citation, court,
      year, summary, url, const DeepCollectionEquality().hash(_sectionsCited));

  /// Create a copy of CaseResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CaseResultImplCopyWith<_$CaseResultImpl> get copyWith =>
      __$$CaseResultImplCopyWithImpl<_$CaseResultImpl>(this, _$identity);
}

abstract class _CaseResult extends CaseResult {
  const factory _CaseResult(
      {required final String docId,
      required final String title,
      final String? citation,
      required final String court,
      final int? year,
      final String? summary,
      final String? url,
      final List<String> sectionsCited}) = _$CaseResultImpl;
  const _CaseResult._() : super._();

  @override
  String get docId;
  @override
  String get title;
  @override
  String? get citation;
  @override
  String get court;
  @override
  int? get year;
  @override
  String? get summary;
  @override
  String? get url;
  @override
  List<String> get sectionsCited;

  /// Create a copy of CaseResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CaseResultImplCopyWith<_$CaseResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
