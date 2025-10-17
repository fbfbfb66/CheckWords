// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isWordFavoritedHash() => r'809a1572b5ff78eb20ab89f4c8ea2f209571c833';

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

/// 检查单词是否被收藏（全局）
///
/// Copied from [isWordFavorited].
@ProviderFor(isWordFavorited)
const isWordFavoritedProvider = IsWordFavoritedFamily();

/// 检查单词是否被收藏（全局）
///
/// Copied from [isWordFavorited].
class IsWordFavoritedFamily extends Family<AsyncValue<bool>> {
  /// 检查单词是否被收藏（全局）
  ///
  /// Copied from [isWordFavorited].
  const IsWordFavoritedFamily();

  /// 检查单词是否被收藏（全局）
  ///
  /// Copied from [isWordFavorited].
  IsWordFavoritedProvider call(
    int wordId,
  ) {
    return IsWordFavoritedProvider(
      wordId,
    );
  }

  @override
  IsWordFavoritedProvider getProviderOverride(
    covariant IsWordFavoritedProvider provider,
  ) {
    return call(
      provider.wordId,
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
  String? get name => r'isWordFavoritedProvider';
}

/// 检查单词是否被收藏（全局）
///
/// Copied from [isWordFavorited].
class IsWordFavoritedProvider extends AutoDisposeFutureProvider<bool> {
  /// 检查单词是否被收藏（全局）
  ///
  /// Copied from [isWordFavorited].
  IsWordFavoritedProvider(
    int wordId,
  ) : this._internal(
          (ref) => isWordFavorited(
            ref as IsWordFavoritedRef,
            wordId,
          ),
          from: isWordFavoritedProvider,
          name: r'isWordFavoritedProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isWordFavoritedHash,
          dependencies: IsWordFavoritedFamily._dependencies,
          allTransitiveDependencies:
              IsWordFavoritedFamily._allTransitiveDependencies,
          wordId: wordId,
        );

  IsWordFavoritedProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.wordId,
  }) : super.internal();

  final int wordId;

  @override
  Override overrideWith(
    FutureOr<bool> Function(IsWordFavoritedRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsWordFavoritedProvider._internal(
        (ref) => create(ref as IsWordFavoritedRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        wordId: wordId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _IsWordFavoritedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsWordFavoritedProvider && other.wordId == wordId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, wordId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin IsWordFavoritedRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `wordId` of this provider.
  int get wordId;
}

class _IsWordFavoritedProviderElement
    extends AutoDisposeFutureProviderElement<bool> with IsWordFavoritedRef {
  _IsWordFavoritedProviderElement(super.provider);

  @override
  int get wordId => (origin as IsWordFavoritedProvider).wordId;
}

String _$favoriteWordsHash() => r'f09f3dcd6dbac6dabd8bb02c64dfefea58fc0a82';

/// 获取收藏的单词列表（全局）
///
/// Copied from [favoriteWords].
@ProviderFor(favoriteWords)
const favoriteWordsProvider = FavoriteWordsFamily();

/// 获取收藏的单词列表（全局）
///
/// Copied from [favoriteWords].
class FavoriteWordsFamily extends Family<AsyncValue<List<WordModel>>> {
  /// 获取收藏的单词列表（全局）
  ///
  /// Copied from [favoriteWords].
  const FavoriteWordsFamily();

  /// 获取收藏的单词列表（全局）
  ///
  /// Copied from [favoriteWords].
  FavoriteWordsProvider call({
    int limit = 100,
  }) {
    return FavoriteWordsProvider(
      limit: limit,
    );
  }

  @override
  FavoriteWordsProvider getProviderOverride(
    covariant FavoriteWordsProvider provider,
  ) {
    return call(
      limit: provider.limit,
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
  String? get name => r'favoriteWordsProvider';
}

/// 获取收藏的单词列表（全局）
///
/// Copied from [favoriteWords].
class FavoriteWordsProvider extends AutoDisposeFutureProvider<List<WordModel>> {
  /// 获取收藏的单词列表（全局）
  ///
  /// Copied from [favoriteWords].
  FavoriteWordsProvider({
    int limit = 100,
  }) : this._internal(
          (ref) => favoriteWords(
            ref as FavoriteWordsRef,
            limit: limit,
          ),
          from: favoriteWordsProvider,
          name: r'favoriteWordsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$favoriteWordsHash,
          dependencies: FavoriteWordsFamily._dependencies,
          allTransitiveDependencies:
              FavoriteWordsFamily._allTransitiveDependencies,
          limit: limit,
        );

  FavoriteWordsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.limit,
  }) : super.internal();

  final int limit;

  @override
  Override overrideWith(
    FutureOr<List<WordModel>> Function(FavoriteWordsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FavoriteWordsProvider._internal(
        (ref) => create(ref as FavoriteWordsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<WordModel>> createElement() {
    return _FavoriteWordsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FavoriteWordsProvider && other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FavoriteWordsRef on AutoDisposeFutureProviderRef<List<WordModel>> {
  /// The parameter `limit` of this provider.
  int get limit;
}

class _FavoriteWordsProviderElement
    extends AutoDisposeFutureProviderElement<List<WordModel>>
    with FavoriteWordsRef {
  _FavoriteWordsProviderElement(super.provider);

  @override
  int get limit => (origin as FavoriteWordsProvider).limit;
}

String _$favoriteWordsCountHash() =>
    r'1299fec6ce35e10e7d1c9a1f1daadc56056587ff';

/// 获取收藏数量（全局）
///
/// Copied from [favoriteWordsCount].
@ProviderFor(favoriteWordsCount)
final favoriteWordsCountProvider = AutoDisposeFutureProvider<int>.internal(
  favoriteWordsCount,
  name: r'favoriteWordsCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$favoriteWordsCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FavoriteWordsCountRef = AutoDisposeFutureProviderRef<int>;
String _$favoriteToggleHash() => r'5753d48eb099dc254442fac71d9a9f31a6a62088';

abstract class _$FavoriteToggle
    extends BuildlessAutoDisposeAsyncNotifier<bool> {
  late final int wordId;

  FutureOr<bool> build(
    int wordId,
  );
}

/// 切换单词收藏状态
///
/// Copied from [FavoriteToggle].
@ProviderFor(FavoriteToggle)
const favoriteToggleProvider = FavoriteToggleFamily();

/// 切换单词收藏状态
///
/// Copied from [FavoriteToggle].
class FavoriteToggleFamily extends Family<AsyncValue<bool>> {
  /// 切换单词收藏状态
  ///
  /// Copied from [FavoriteToggle].
  const FavoriteToggleFamily();

  /// 切换单词收藏状态
  ///
  /// Copied from [FavoriteToggle].
  FavoriteToggleProvider call(
    int wordId,
  ) {
    return FavoriteToggleProvider(
      wordId,
    );
  }

  @override
  FavoriteToggleProvider getProviderOverride(
    covariant FavoriteToggleProvider provider,
  ) {
    return call(
      provider.wordId,
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
  String? get name => r'favoriteToggleProvider';
}

/// 切换单词收藏状态
///
/// Copied from [FavoriteToggle].
class FavoriteToggleProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FavoriteToggle, bool> {
  /// 切换单词收藏状态
  ///
  /// Copied from [FavoriteToggle].
  FavoriteToggleProvider(
    int wordId,
  ) : this._internal(
          () => FavoriteToggle()..wordId = wordId,
          from: favoriteToggleProvider,
          name: r'favoriteToggleProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$favoriteToggleHash,
          dependencies: FavoriteToggleFamily._dependencies,
          allTransitiveDependencies:
              FavoriteToggleFamily._allTransitiveDependencies,
          wordId: wordId,
        );

  FavoriteToggleProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.wordId,
  }) : super.internal();

  final int wordId;

  @override
  FutureOr<bool> runNotifierBuild(
    covariant FavoriteToggle notifier,
  ) {
    return notifier.build(
      wordId,
    );
  }

  @override
  Override overrideWith(FavoriteToggle Function() create) {
    return ProviderOverride(
      origin: this,
      override: FavoriteToggleProvider._internal(
        () => create()..wordId = wordId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        wordId: wordId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<FavoriteToggle, bool>
      createElement() {
    return _FavoriteToggleProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FavoriteToggleProvider && other.wordId == wordId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, wordId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FavoriteToggleRef on AutoDisposeAsyncNotifierProviderRef<bool> {
  /// The parameter `wordId` of this provider.
  int get wordId;
}

class _FavoriteToggleProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FavoriteToggle, bool>
    with FavoriteToggleRef {
  _FavoriteToggleProviderElement(super.provider);

  @override
  int get wordId => (origin as FavoriteToggleProvider).wordId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
