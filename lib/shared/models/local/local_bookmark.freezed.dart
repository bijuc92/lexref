// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'local_bookmark.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LocalBookmark {
  String get id => throw _privateConstructorUsedError;
  String get refType => throw _privateConstructorUsedError;
  String get refId => throw _privateConstructorUsedError;
  String get refTitle => throw _privateConstructorUsedError;
  String? get refAct => throw _privateConstructorUsedError;
  String get folder => throw _privateConstructorUsedError;
  DateTime get savedAt => throw _privateConstructorUsedError;
  bool get isSynced => throw _privateConstructorUsedError;

  /// Create a copy of LocalBookmark
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocalBookmarkCopyWith<LocalBookmark> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocalBookmarkCopyWith<$Res> {
  factory $LocalBookmarkCopyWith(
          LocalBookmark value, $Res Function(LocalBookmark) then) =
      _$LocalBookmarkCopyWithImpl<$Res, LocalBookmark>;
  @useResult
  $Res call(
      {String id,
      String refType,
      String refId,
      String refTitle,
      String? refAct,
      String folder,
      DateTime savedAt,
      bool isSynced});
}

/// @nodoc
class _$LocalBookmarkCopyWithImpl<$Res, $Val extends LocalBookmark>
    implements $LocalBookmarkCopyWith<$Res> {
  _$LocalBookmarkCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocalBookmark
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? refType = null,
    Object? refId = null,
    Object? refTitle = null,
    Object? refAct = freezed,
    Object? folder = null,
    Object? savedAt = null,
    Object? isSynced = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      refType: null == refType
          ? _value.refType
          : refType // ignore: cast_nullable_to_non_nullable
              as String,
      refId: null == refId
          ? _value.refId
          : refId // ignore: cast_nullable_to_non_nullable
              as String,
      refTitle: null == refTitle
          ? _value.refTitle
          : refTitle // ignore: cast_nullable_to_non_nullable
              as String,
      refAct: freezed == refAct
          ? _value.refAct
          : refAct // ignore: cast_nullable_to_non_nullable
              as String?,
      folder: null == folder
          ? _value.folder
          : folder // ignore: cast_nullable_to_non_nullable
              as String,
      savedAt: null == savedAt
          ? _value.savedAt
          : savedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isSynced: null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocalBookmarkImplCopyWith<$Res>
    implements $LocalBookmarkCopyWith<$Res> {
  factory _$$LocalBookmarkImplCopyWith(
          _$LocalBookmarkImpl value, $Res Function(_$LocalBookmarkImpl) then) =
      __$$LocalBookmarkImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String refType,
      String refId,
      String refTitle,
      String? refAct,
      String folder,
      DateTime savedAt,
      bool isSynced});
}

/// @nodoc
class __$$LocalBookmarkImplCopyWithImpl<$Res>
    extends _$LocalBookmarkCopyWithImpl<$Res, _$LocalBookmarkImpl>
    implements _$$LocalBookmarkImplCopyWith<$Res> {
  __$$LocalBookmarkImplCopyWithImpl(
      _$LocalBookmarkImpl _value, $Res Function(_$LocalBookmarkImpl) _then)
      : super(_value, _then);

  /// Create a copy of LocalBookmark
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? refType = null,
    Object? refId = null,
    Object? refTitle = null,
    Object? refAct = freezed,
    Object? folder = null,
    Object? savedAt = null,
    Object? isSynced = null,
  }) {
    return _then(_$LocalBookmarkImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      refType: null == refType
          ? _value.refType
          : refType // ignore: cast_nullable_to_non_nullable
              as String,
      refId: null == refId
          ? _value.refId
          : refId // ignore: cast_nullable_to_non_nullable
              as String,
      refTitle: null == refTitle
          ? _value.refTitle
          : refTitle // ignore: cast_nullable_to_non_nullable
              as String,
      refAct: freezed == refAct
          ? _value.refAct
          : refAct // ignore: cast_nullable_to_non_nullable
              as String?,
      folder: null == folder
          ? _value.folder
          : folder // ignore: cast_nullable_to_non_nullable
              as String,
      savedAt: null == savedAt
          ? _value.savedAt
          : savedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isSynced: null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$LocalBookmarkImpl extends _LocalBookmark {
  const _$LocalBookmarkImpl(
      {required this.id,
      required this.refType,
      required this.refId,
      required this.refTitle,
      this.refAct,
      this.folder = 'General',
      required this.savedAt,
      this.isSynced = false})
      : super._();

  @override
  final String id;
  @override
  final String refType;
  @override
  final String refId;
  @override
  final String refTitle;
  @override
  final String? refAct;
  @override
  @JsonKey()
  final String folder;
  @override
  final DateTime savedAt;
  @override
  @JsonKey()
  final bool isSynced;

  @override
  String toString() {
    return 'LocalBookmark(id: $id, refType: $refType, refId: $refId, refTitle: $refTitle, refAct: $refAct, folder: $folder, savedAt: $savedAt, isSynced: $isSynced)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocalBookmarkImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.refType, refType) || other.refType == refType) &&
            (identical(other.refId, refId) || other.refId == refId) &&
            (identical(other.refTitle, refTitle) ||
                other.refTitle == refTitle) &&
            (identical(other.refAct, refAct) || other.refAct == refAct) &&
            (identical(other.folder, folder) || other.folder == folder) &&
            (identical(other.savedAt, savedAt) || other.savedAt == savedAt) &&
            (identical(other.isSynced, isSynced) ||
                other.isSynced == isSynced));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, refType, refId, refTitle,
      refAct, folder, savedAt, isSynced);

  /// Create a copy of LocalBookmark
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocalBookmarkImplCopyWith<_$LocalBookmarkImpl> get copyWith =>
      __$$LocalBookmarkImplCopyWithImpl<_$LocalBookmarkImpl>(this, _$identity);
}

abstract class _LocalBookmark extends LocalBookmark {
  const factory _LocalBookmark(
      {required final String id,
      required final String refType,
      required final String refId,
      required final String refTitle,
      final String? refAct,
      final String folder,
      required final DateTime savedAt,
      final bool isSynced}) = _$LocalBookmarkImpl;
  const _LocalBookmark._() : super._();

  @override
  String get id;
  @override
  String get refType;
  @override
  String get refId;
  @override
  String get refTitle;
  @override
  String? get refAct;
  @override
  String get folder;
  @override
  DateTime get savedAt;
  @override
  bool get isSynced;

  /// Create a copy of LocalBookmark
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocalBookmarkImplCopyWith<_$LocalBookmarkImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
