// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'acts_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sectionDetailHash() => r'541e2ddece2c00c2e8638b86f577ade76bc9446c';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Loads a section by composite key `actId__sectionId`.
/// Seeds the act into sqflite on first access if needed.
///
/// Copied from [sectionDetail].
@ProviderFor(sectionDetail)
const sectionDetailProvider = SectionDetailFamily();

/// Loads a section by composite key `actId__sectionId`.
/// Seeds the act into sqflite on first access if needed.
///
/// Copied from [sectionDetail].
class SectionDetailFamily extends Family<AsyncValue<SectionModel?>> {
  /// Loads a section by composite key `actId__sectionId`.
  /// Seeds the act into sqflite on first access if needed.
  ///
  /// Copied from [sectionDetail].
  const SectionDetailFamily();

  /// Loads a section by composite key `actId__sectionId`.
  /// Seeds the act into sqflite on first access if needed.
  ///
  /// Copied from [sectionDetail].
  SectionDetailProvider call(
    String compositeId,
  ) {
    return SectionDetailProvider(
      compositeId,
    );
  }

  @override
  SectionDetailProvider getProviderOverride(
    covariant SectionDetailProvider provider,
  ) {
    return call(
      provider.compositeId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'sectionDetailProvider';
}

/// Loads a section by composite key `actId__sectionId`.
/// Seeds the act into sqflite on first access if needed.
///
/// Copied from [sectionDetail].
class SectionDetailProvider extends AutoDisposeFutureProvider<SectionModel?> {
  /// Loads a section by composite key `actId__sectionId`.
  /// Seeds the act into sqflite on first access if needed.
  ///
  /// Copied from [sectionDetail].
  SectionDetailProvider(
    String compositeId,
  ) : this._internal(
          (ref) => sectionDetail(
            ref as SectionDetailRef,
            compositeId,
          ),
          from: sectionDetailProvider,
          name: r'sectionDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sectionDetailHash,
          dependencies: SectionDetailFamily._dependencies,
          allTransitiveDependencies:
              SectionDetailFamily._allTransitiveDependencies,
          compositeId: compositeId,
        );

  SectionDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.compositeId,
  }) : super.internal();

  final String compositeId;

  @override
  Override overrideWith(
    FutureOr<SectionModel?> Function(SectionDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SectionDetailProvider._internal(
        (ref) => create(ref as SectionDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        compositeId: compositeId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<SectionModel?> createElement() {
    return _SectionDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SectionDetailProvider && other.compositeId == compositeId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, compositeId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SectionDetailRef on AutoDisposeFutureProviderRef<SectionModel?> {
  /// The parameter `compositeId` of this provider.
  String get compositeId;
}

class _SectionDetailProviderElement
    extends AutoDisposeFutureProviderElement<SectionModel?>
    with SectionDetailRef {
  _SectionDetailProviderElement(super.provider);

  @override
  String get compositeId => (origin as SectionDetailProvider).compositeId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
