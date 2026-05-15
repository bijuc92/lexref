// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'local_note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LocalNote {
  String get id => throw _privateConstructorUsedError;
  String get refType => throw _privateConstructorUsedError;
  String get refId => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String get folder => throw _privateConstructorUsedError;
  bool get isSynced => throw _privateConstructorUsedError;

  /// Create a copy of LocalNote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocalNoteCopyWith<LocalNote> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocalNoteCopyWith<$Res> {
  factory $LocalNoteCopyWith(LocalNote value, $Res Function(LocalNote) then) =
      _$LocalNoteCopyWithImpl<$Res, LocalNote>;
  @useResult
  $Res call(
      {String id,
      String refType,
      String refId,
      String content,
      DateTime updatedAt,
      String folder,
      bool isSynced});
}

/// @nodoc
class _$LocalNoteCopyWithImpl<$Res, $Val extends LocalNote>
    implements $LocalNoteCopyWith<$Res> {
  _$LocalNoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocalNote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? refType = null,
    Object? refId = null,
    Object? content = null,
    Object? updatedAt = null,
    Object? folder = null,
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
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      folder: null == folder
          ? _value.folder
          : folder // ignore: cast_nullable_to_non_nullable
              as String,
      isSynced: null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocalNoteImplCopyWith<$Res>
    implements $LocalNoteCopyWith<$Res> {
  factory _$$LocalNoteImplCopyWith(
          _$LocalNoteImpl value, $Res Function(_$LocalNoteImpl) then) =
      __$$LocalNoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String refType,
      String refId,
      String content,
      DateTime updatedAt,
      String folder,
      bool isSynced});
}

/// @nodoc
class __$$LocalNoteImplCopyWithImpl<$Res>
    extends _$LocalNoteCopyWithImpl<$Res, _$LocalNoteImpl>
    implements _$$LocalNoteImplCopyWith<$Res> {
  __$$LocalNoteImplCopyWithImpl(
      _$LocalNoteImpl _value, $Res Function(_$LocalNoteImpl) _then)
      : super(_value, _then);

  /// Create a copy of LocalNote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? refType = null,
    Object? refId = null,
    Object? content = null,
    Object? updatedAt = null,
    Object? folder = null,
    Object? isSynced = null,
  }) {
    return _then(_$LocalNoteImpl(
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
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      folder: null == folder
          ? _value.folder
          : folder // ignore: cast_nullable_to_non_nullable
              as String,
      isSynced: null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$LocalNoteImpl extends _LocalNote {
  const _$LocalNoteImpl(
      {required this.id,
      required this.refType,
      required this.refId,
      required this.content,
      required this.updatedAt,
      this.folder = 'General',
      this.isSynced = false})
      : super._();

  @override
  final String id;
  @override
  final String refType;
  @override
  final String refId;
  @override
  final String content;
  @override
  final DateTime updatedAt;
  @override
  @JsonKey()
  final String folder;
  @override
  @JsonKey()
  final bool isSynced;

  @override
  String toString() {
    return 'LocalNote(id: $id, refType: $refType, refId: $refId, content: $content, updatedAt: $updatedAt, folder: $folder, isSynced: $isSynced)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocalNoteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.refType, refType) || other.refType == refType) &&
            (identical(other.refId, refId) || other.refId == refId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.folder, folder) || other.folder == folder) &&
            (identical(other.isSynced, isSynced) ||
                other.isSynced == isSynced));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, refType, refId, content, updatedAt, folder, isSynced);

  /// Create a copy of LocalNote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocalNoteImplCopyWith<_$LocalNoteImpl> get copyWith =>
      __$$LocalNoteImplCopyWithImpl<_$LocalNoteImpl>(this, _$identity);
}

abstract class _LocalNote extends LocalNote {
  const factory _LocalNote(
      {required final String id,
      required final String refType,
      required final String refId,
      required final String content,
      required final DateTime updatedAt,
      final String folder,
      final bool isSynced}) = _$LocalNoteImpl;
  const _LocalNote._() : super._();

  @override
  String get id;
  @override
  String get refType;
  @override
  String get refId;
  @override
  String get content;
  @override
  DateTime get updatedAt;
  @override
  String get folder;
  @override
  bool get isSynced;

  /// Create a copy of LocalNote
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocalNoteImplCopyWith<_$LocalNoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
