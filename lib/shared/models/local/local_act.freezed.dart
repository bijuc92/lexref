// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'local_act.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LocalAct {
  String get id => throw _privateConstructorUsedError;
  String get shortName => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  int get year => throw _privateConstructorUsedError;
  String get jurisdiction => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;

  /// Create a copy of LocalAct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocalActCopyWith<LocalAct> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocalActCopyWith<$Res> {
  factory $LocalActCopyWith(LocalAct value, $Res Function(LocalAct) then) =
      _$LocalActCopyWithImpl<$Res, LocalAct>;
  @useResult
  $Res call(
      {String id,
      String shortName,
      String fullName,
      int year,
      String jurisdiction,
      String category});
}

/// @nodoc
class _$LocalActCopyWithImpl<$Res, $Val extends LocalAct>
    implements $LocalActCopyWith<$Res> {
  _$LocalActCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocalAct
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocalActImplCopyWith<$Res>
    implements $LocalActCopyWith<$Res> {
  factory _$$LocalActImplCopyWith(
          _$LocalActImpl value, $Res Function(_$LocalActImpl) then) =
      __$$LocalActImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String shortName,
      String fullName,
      int year,
      String jurisdiction,
      String category});
}

/// @nodoc
class __$$LocalActImplCopyWithImpl<$Res>
    extends _$LocalActCopyWithImpl<$Res, _$LocalActImpl>
    implements _$$LocalActImplCopyWith<$Res> {
  __$$LocalActImplCopyWithImpl(
      _$LocalActImpl _value, $Res Function(_$LocalActImpl) _then)
      : super(_value, _then);

  /// Create a copy of LocalAct
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
  }) {
    return _then(_$LocalActImpl(
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
    ));
  }
}

/// @nodoc

class _$LocalActImpl extends _LocalAct {
  const _$LocalActImpl(
      {required this.id,
      required this.shortName,
      required this.fullName,
      required this.year,
      required this.jurisdiction,
      required this.category})
      : super._();

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

  @override
  String toString() {
    return 'LocalAct(id: $id, shortName: $shortName, fullName: $fullName, year: $year, jurisdiction: $jurisdiction, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocalActImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.shortName, shortName) ||
                other.shortName == shortName) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.jurisdiction, jurisdiction) ||
                other.jurisdiction == jurisdiction) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, shortName, fullName, year, jurisdiction, category);

  /// Create a copy of LocalAct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocalActImplCopyWith<_$LocalActImpl> get copyWith =>
      __$$LocalActImplCopyWithImpl<_$LocalActImpl>(this, _$identity);
}

abstract class _LocalAct extends LocalAct {
  const factory _LocalAct(
      {required final String id,
      required final String shortName,
      required final String fullName,
      required final int year,
      required final String jurisdiction,
      required final String category}) = _$LocalActImpl;
  const _LocalAct._() : super._();

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

  /// Create a copy of LocalAct
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocalActImplCopyWith<_$LocalActImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
