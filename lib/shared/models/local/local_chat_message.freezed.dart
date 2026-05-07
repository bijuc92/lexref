// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'local_chat_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LocalChatMessage {
  String get id => throw _privateConstructorUsedError;
  String get sessionId => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of LocalChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocalChatMessageCopyWith<LocalChatMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocalChatMessageCopyWith<$Res> {
  factory $LocalChatMessageCopyWith(
          LocalChatMessage value, $Res Function(LocalChatMessage) then) =
      _$LocalChatMessageCopyWithImpl<$Res, LocalChatMessage>;
  @useResult
  $Res call(
      {String id,
      String sessionId,
      String role,
      String content,
      DateTime createdAt});
}

/// @nodoc
class _$LocalChatMessageCopyWithImpl<$Res, $Val extends LocalChatMessage>
    implements $LocalChatMessageCopyWith<$Res> {
  _$LocalChatMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocalChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? role = null,
    Object? content = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocalChatMessageImplCopyWith<$Res>
    implements $LocalChatMessageCopyWith<$Res> {
  factory _$$LocalChatMessageImplCopyWith(_$LocalChatMessageImpl value,
          $Res Function(_$LocalChatMessageImpl) then) =
      __$$LocalChatMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String sessionId,
      String role,
      String content,
      DateTime createdAt});
}

/// @nodoc
class __$$LocalChatMessageImplCopyWithImpl<$Res>
    extends _$LocalChatMessageCopyWithImpl<$Res, _$LocalChatMessageImpl>
    implements _$$LocalChatMessageImplCopyWith<$Res> {
  __$$LocalChatMessageImplCopyWithImpl(_$LocalChatMessageImpl _value,
      $Res Function(_$LocalChatMessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of LocalChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? role = null,
    Object? content = null,
    Object? createdAt = null,
  }) {
    return _then(_$LocalChatMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$LocalChatMessageImpl extends _LocalChatMessage {
  const _$LocalChatMessageImpl(
      {required this.id,
      required this.sessionId,
      required this.role,
      required this.content,
      required this.createdAt})
      : super._();

  @override
  final String id;
  @override
  final String sessionId;
  @override
  final String role;
  @override
  final String content;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'LocalChatMessage(id: $id, sessionId: $sessionId, role: $role, content: $content, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocalChatMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, sessionId, role, content, createdAt);

  /// Create a copy of LocalChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocalChatMessageImplCopyWith<_$LocalChatMessageImpl> get copyWith =>
      __$$LocalChatMessageImplCopyWithImpl<_$LocalChatMessageImpl>(
          this, _$identity);
}

abstract class _LocalChatMessage extends LocalChatMessage {
  const factory _LocalChatMessage(
      {required final String id,
      required final String sessionId,
      required final String role,
      required final String content,
      required final DateTime createdAt}) = _$LocalChatMessageImpl;
  const _LocalChatMessage._() : super._();

  @override
  String get id;
  @override
  String get sessionId;
  @override
  String get role;
  @override
  String get content;
  @override
  DateTime get createdAt;

  /// Create a copy of LocalChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocalChatMessageImplCopyWith<_$LocalChatMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
