// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'words_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$wordByIdHash() => r'8f70bbd6499114bb1f711b2cc88d97ba881a071f';

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

/// 根据ID获取单词详情
///
/// Copied from [wordById].
@ProviderFor(wordById)
const wordByIdProvider = WordByIdFamily();

/// 根据ID获取单词详情
///
/// Copied from [wordById].
class WordByIdFamily extends Family<AsyncValue<WordModel?>> {
  /// 根据ID获取单词详情
  ///
  /// Copied from [wordById].
  const WordByIdFamily();

  /// 根据ID获取单词详情
  ///
  /// Copied from [wordById].
  WordByIdProvider call(
    int wordId,
  ) {
    return WordByIdProvider(
      wordId,
    );
  }

  @override
  WordByIdProvider getProviderOverride(
    covariant WordByIdProvider provider,
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
  String? get name => r'wordByIdProvider';
}

/// 根据ID获取单词详情
///
/// Copied from [wordById].
class WordByIdProvider extends AutoDisposeFutureProvider<WordModel?> {
  /// 根据ID获取单词详情
  ///
  /// Copied from [wordById].
  WordByIdProvider(
    int wordId,
  ) : this._internal(
          (ref) => wordById(
            ref as WordByIdRef,
            wordId,
          ),
          from: wordByIdProvider,
          name: r'wordByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$wordByIdHash,
          dependencies: WordByIdFamily._dependencies,
          allTransitiveDependencies: WordByIdFamily._allTransitiveDependencies,
          wordId: wordId,
        );

  WordByIdProvider._internal(
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
    FutureOr<WordModel?> Function(WordByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WordByIdProvider._internal(
        (ref) => create(ref as WordByIdRef),
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
  AutoDisposeFutureProviderElement<WordModel?> createElement() {
    return _WordByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WordByIdProvider && other.wordId == wordId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, wordId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WordByIdRef on AutoDisposeFutureProviderRef<WordModel?> {
  /// The parameter `wordId` of this provider.
  int get wordId;
}

class _WordByIdProviderElement
    extends AutoDisposeFutureProviderElement<WordModel?> with WordByIdRef {
  _WordByIdProviderElement(super.provider);

  @override
  int get wordId => (origin as WordByIdProvider).wordId;
}

String _$databaseStatusHash() => r'0625f159e294af8c39079c607dd9ff8efc7e2e8f';

/// 检查数据库状态（调试用）
///
/// Copied from [databaseStatus].
@ProviderFor(databaseStatus)
final databaseStatusProvider =
    AutoDisposeFutureProvider<DatabaseStatus>.internal(
  databaseStatus,
  name: r'databaseStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$databaseStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DatabaseStatusRef = AutoDisposeFutureProviderRef<DatabaseStatus>;
String _$wordByNameHash() => r'45bb551baf59c7be435aa7b3b352c861d475dab6';

/// 根据单词名称获取单词详情
///
/// Copied from [wordByName].
@ProviderFor(wordByName)
const wordByNameProvider = WordByNameFamily();

/// 根据单词名称获取单词详情
///
/// Copied from [wordByName].
class WordByNameFamily extends Family<AsyncValue<WordModel?>> {
  /// 根据单词名称获取单词详情
  ///
  /// Copied from [wordByName].
  const WordByNameFamily();

  /// 根据单词名称获取单词详情
  ///
  /// Copied from [wordByName].
  WordByNameProvider call(
    String word,
  ) {
    return WordByNameProvider(
      word,
    );
  }

  @override
  WordByNameProvider getProviderOverride(
    covariant WordByNameProvider provider,
  ) {
    return call(
      provider.word,
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
  String? get name => r'wordByNameProvider';
}

/// 根据单词名称获取单词详情
///
/// Copied from [wordByName].
class WordByNameProvider extends AutoDisposeFutureProvider<WordModel?> {
  /// 根据单词名称获取单词详情
  ///
  /// Copied from [wordByName].
  WordByNameProvider(
    String word,
  ) : this._internal(
          (ref) => wordByName(
            ref as WordByNameRef,
            word,
          ),
          from: wordByNameProvider,
          name: r'wordByNameProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$wordByNameHash,
          dependencies: WordByNameFamily._dependencies,
          allTransitiveDependencies:
              WordByNameFamily._allTransitiveDependencies,
          word: word,
        );

  WordByNameProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.word,
  }) : super.internal();

  final String word;

  @override
  Override overrideWith(
    FutureOr<WordModel?> Function(WordByNameRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WordByNameProvider._internal(
        (ref) => create(ref as WordByNameRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        word: word,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<WordModel?> createElement() {
    return _WordByNameProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WordByNameProvider && other.word == word;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, word.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WordByNameRef on AutoDisposeFutureProviderRef<WordModel?> {
  /// The parameter `word` of this provider.
  String get word;
}

class _WordByNameProviderElement
    extends AutoDisposeFutureProviderElement<WordModel?> with WordByNameRef {
  _WordByNameProviderElement(super.provider);

  @override
  String get word => (origin as WordByNameProvider).word;
}

String _$searchWordsHash() => r'4adbb2b2c601c487af02b34b383179fd974d1e76';

/// 搜索单词
///
/// Copied from [searchWords].
@ProviderFor(searchWords)
const searchWordsProvider = SearchWordsFamily();

/// 搜索单词
///
/// Copied from [searchWords].
class SearchWordsFamily extends Family<AsyncValue<List<WordModel>>> {
  /// 搜索单词
  ///
  /// Copied from [searchWords].
  const SearchWordsFamily();

  /// 搜索单词
  ///
  /// Copied from [searchWords].
  SearchWordsProvider call(
    String query, {
    int limit = 20,
  }) {
    return SearchWordsProvider(
      query,
      limit: limit,
    );
  }

  @override
  SearchWordsProvider getProviderOverride(
    covariant SearchWordsProvider provider,
  ) {
    return call(
      provider.query,
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
  String? get name => r'searchWordsProvider';
}

/// 搜索单词
///
/// Copied from [searchWords].
class SearchWordsProvider extends AutoDisposeFutureProvider<List<WordModel>> {
  /// 搜索单词
  ///
  /// Copied from [searchWords].
  SearchWordsProvider(
    String query, {
    int limit = 20,
  }) : this._internal(
          (ref) => searchWords(
            ref as SearchWordsRef,
            query,
            limit: limit,
          ),
          from: searchWordsProvider,
          name: r'searchWordsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchWordsHash,
          dependencies: SearchWordsFamily._dependencies,
          allTransitiveDependencies:
              SearchWordsFamily._allTransitiveDependencies,
          query: query,
          limit: limit,
        );

  SearchWordsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
    required this.limit,
  }) : super.internal();

  final String query;
  final int limit;

  @override
  Override overrideWith(
    FutureOr<List<WordModel>> Function(SearchWordsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchWordsProvider._internal(
        (ref) => create(ref as SearchWordsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<WordModel>> createElement() {
    return _SearchWordsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchWordsProvider &&
        other.query == query &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SearchWordsRef on AutoDisposeFutureProviderRef<List<WordModel>> {
  /// The parameter `query` of this provider.
  String get query;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _SearchWordsProviderElement
    extends AutoDisposeFutureProviderElement<List<WordModel>>
    with SearchWordsRef {
  _SearchWordsProviderElement(super.provider);

  @override
  String get query => (origin as SearchWordsProvider).query;
  @override
  int get limit => (origin as SearchWordsProvider).limit;
}

String _$exactSearchWordsHash() => r'618ea10eaf287f82b29aecae0f5279b5b23eee67';

/// 精确搜索单词（点击搜索按钮后使用）
///
/// Copied from [exactSearchWords].
@ProviderFor(exactSearchWords)
const exactSearchWordsProvider = ExactSearchWordsFamily();

/// 精确搜索单词（点击搜索按钮后使用）
///
/// Copied from [exactSearchWords].
class ExactSearchWordsFamily extends Family<AsyncValue<WordModel?>> {
  /// 精确搜索单词（点击搜索按钮后使用）
  ///
  /// Copied from [exactSearchWords].
  const ExactSearchWordsFamily();

  /// 精确搜索单词（点击搜索按钮后使用）
  ///
  /// Copied from [exactSearchWords].
  ExactSearchWordsProvider call(
    String query,
  ) {
    return ExactSearchWordsProvider(
      query,
    );
  }

  @override
  ExactSearchWordsProvider getProviderOverride(
    covariant ExactSearchWordsProvider provider,
  ) {
    return call(
      provider.query,
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
  String? get name => r'exactSearchWordsProvider';
}

/// 精确搜索单词（点击搜索按钮后使用）
///
/// Copied from [exactSearchWords].
class ExactSearchWordsProvider extends AutoDisposeFutureProvider<WordModel?> {
  /// 精确搜索单词（点击搜索按钮后使用）
  ///
  /// Copied from [exactSearchWords].
  ExactSearchWordsProvider(
    String query,
  ) : this._internal(
          (ref) => exactSearchWords(
            ref as ExactSearchWordsRef,
            query,
          ),
          from: exactSearchWordsProvider,
          name: r'exactSearchWordsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$exactSearchWordsHash,
          dependencies: ExactSearchWordsFamily._dependencies,
          allTransitiveDependencies:
              ExactSearchWordsFamily._allTransitiveDependencies,
          query: query,
        );

  ExactSearchWordsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<WordModel?> Function(ExactSearchWordsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExactSearchWordsProvider._internal(
        (ref) => create(ref as ExactSearchWordsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<WordModel?> createElement() {
    return _ExactSearchWordsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExactSearchWordsProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ExactSearchWordsRef on AutoDisposeFutureProviderRef<WordModel?> {
  /// The parameter `query` of this provider.
  String get query;
}

class _ExactSearchWordsProviderElement
    extends AutoDisposeFutureProviderElement<WordModel?>
    with ExactSearchWordsRef {
  _ExactSearchWordsProviderElement(super.provider);

  @override
  String get query => (origin as ExactSearchWordsProvider).query;
}

String _$fuzzySearchWordsHash() => r'c6155fdb513445d9013e37aac5256113781ecac5';

/// 模糊搜索单词（用于输入提示）
///
/// Copied from [fuzzySearchWords].
@ProviderFor(fuzzySearchWords)
const fuzzySearchWordsProvider = FuzzySearchWordsFamily();

/// 模糊搜索单词（用于输入提示）
///
/// Copied from [fuzzySearchWords].
class FuzzySearchWordsFamily extends Family<AsyncValue<List<WordModel>>> {
  /// 模糊搜索单词（用于输入提示）
  ///
  /// Copied from [fuzzySearchWords].
  const FuzzySearchWordsFamily();

  /// 模糊搜索单词（用于输入提示）
  ///
  /// Copied from [fuzzySearchWords].
  FuzzySearchWordsProvider call(
    String query, {
    int limit = 10,
  }) {
    return FuzzySearchWordsProvider(
      query,
      limit: limit,
    );
  }

  @override
  FuzzySearchWordsProvider getProviderOverride(
    covariant FuzzySearchWordsProvider provider,
  ) {
    return call(
      provider.query,
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
  String? get name => r'fuzzySearchWordsProvider';
}

/// 模糊搜索单词（用于输入提示）
///
/// Copied from [fuzzySearchWords].
class FuzzySearchWordsProvider
    extends AutoDisposeFutureProvider<List<WordModel>> {
  /// 模糊搜索单词（用于输入提示）
  ///
  /// Copied from [fuzzySearchWords].
  FuzzySearchWordsProvider(
    String query, {
    int limit = 10,
  }) : this._internal(
          (ref) => fuzzySearchWords(
            ref as FuzzySearchWordsRef,
            query,
            limit: limit,
          ),
          from: fuzzySearchWordsProvider,
          name: r'fuzzySearchWordsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fuzzySearchWordsHash,
          dependencies: FuzzySearchWordsFamily._dependencies,
          allTransitiveDependencies:
              FuzzySearchWordsFamily._allTransitiveDependencies,
          query: query,
          limit: limit,
        );

  FuzzySearchWordsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
    required this.limit,
  }) : super.internal();

  final String query;
  final int limit;

  @override
  Override overrideWith(
    FutureOr<List<WordModel>> Function(FuzzySearchWordsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FuzzySearchWordsProvider._internal(
        (ref) => create(ref as FuzzySearchWordsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<WordModel>> createElement() {
    return _FuzzySearchWordsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FuzzySearchWordsProvider &&
        other.query == query &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FuzzySearchWordsRef on AutoDisposeFutureProviderRef<List<WordModel>> {
  /// The parameter `query` of this provider.
  String get query;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _FuzzySearchWordsProviderElement
    extends AutoDisposeFutureProviderElement<List<WordModel>>
    with FuzzySearchWordsRef {
  _FuzzySearchWordsProviderElement(super.provider);

  @override
  String get query => (origin as FuzzySearchWordsProvider).query;
  @override
  int get limit => (origin as FuzzySearchWordsProvider).limit;
}

String _$popularWordsHash() => r'4497ce76f115aa5095d99451da228195790f5447';

/// 获取热门单词
///
/// Copied from [popularWords].
@ProviderFor(popularWords)
const popularWordsProvider = PopularWordsFamily();

/// 获取热门单词
///
/// Copied from [popularWords].
class PopularWordsFamily extends Family<AsyncValue<List<WordModel>>> {
  /// 获取热门单词
  ///
  /// Copied from [popularWords].
  const PopularWordsFamily();

  /// 获取热门单词
  ///
  /// Copied from [popularWords].
  PopularWordsProvider call({
    int limit = 50,
  }) {
    return PopularWordsProvider(
      limit: limit,
    );
  }

  @override
  PopularWordsProvider getProviderOverride(
    covariant PopularWordsProvider provider,
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
  String? get name => r'popularWordsProvider';
}

/// 获取热门单词
///
/// Copied from [popularWords].
class PopularWordsProvider extends AutoDisposeFutureProvider<List<WordModel>> {
  /// 获取热门单词
  ///
  /// Copied from [popularWords].
  PopularWordsProvider({
    int limit = 50,
  }) : this._internal(
          (ref) => popularWords(
            ref as PopularWordsRef,
            limit: limit,
          ),
          from: popularWordsProvider,
          name: r'popularWordsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$popularWordsHash,
          dependencies: PopularWordsFamily._dependencies,
          allTransitiveDependencies:
              PopularWordsFamily._allTransitiveDependencies,
          limit: limit,
        );

  PopularWordsProvider._internal(
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
    FutureOr<List<WordModel>> Function(PopularWordsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PopularWordsProvider._internal(
        (ref) => create(ref as PopularWordsRef),
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
    return _PopularWordsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PopularWordsProvider && other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PopularWordsRef on AutoDisposeFutureProviderRef<List<WordModel>> {
  /// The parameter `limit` of this provider.
  int get limit;
}

class _PopularWordsProviderElement
    extends AutoDisposeFutureProviderElement<List<WordModel>>
    with PopularWordsRef {
  _PopularWordsProviderElement(super.provider);

  @override
  int get limit => (origin as PopularWordsProvider).limit;
}

String _$wordsByLevelHash() => r'cb2ba731c582eda7756ba4e05e394b9ef6ba9b63';

/// 根据级别获取单词
///
/// Copied from [wordsByLevel].
@ProviderFor(wordsByLevel)
const wordsByLevelProvider = WordsByLevelFamily();

/// 根据级别获取单词
///
/// Copied from [wordsByLevel].
class WordsByLevelFamily extends Family<AsyncValue<List<WordModel>>> {
  /// 根据级别获取单词
  ///
  /// Copied from [wordsByLevel].
  const WordsByLevelFamily();

  /// 根据级别获取单词
  ///
  /// Copied from [wordsByLevel].
  WordsByLevelProvider call(
    String level, {
    int limit = 100,
  }) {
    return WordsByLevelProvider(
      level,
      limit: limit,
    );
  }

  @override
  WordsByLevelProvider getProviderOverride(
    covariant WordsByLevelProvider provider,
  ) {
    return call(
      provider.level,
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
  String? get name => r'wordsByLevelProvider';
}

/// 根据级别获取单词
///
/// Copied from [wordsByLevel].
class WordsByLevelProvider extends AutoDisposeFutureProvider<List<WordModel>> {
  /// 根据级别获取单词
  ///
  /// Copied from [wordsByLevel].
  WordsByLevelProvider(
    String level, {
    int limit = 100,
  }) : this._internal(
          (ref) => wordsByLevel(
            ref as WordsByLevelRef,
            level,
            limit: limit,
          ),
          from: wordsByLevelProvider,
          name: r'wordsByLevelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$wordsByLevelHash,
          dependencies: WordsByLevelFamily._dependencies,
          allTransitiveDependencies:
              WordsByLevelFamily._allTransitiveDependencies,
          level: level,
          limit: limit,
        );

  WordsByLevelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.level,
    required this.limit,
  }) : super.internal();

  final String level;
  final int limit;

  @override
  Override overrideWith(
    FutureOr<List<WordModel>> Function(WordsByLevelRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WordsByLevelProvider._internal(
        (ref) => create(ref as WordsByLevelRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        level: level,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<WordModel>> createElement() {
    return _WordsByLevelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WordsByLevelProvider &&
        other.level == level &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, level.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WordsByLevelRef on AutoDisposeFutureProviderRef<List<WordModel>> {
  /// The parameter `level` of this provider.
  String get level;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _WordsByLevelProviderElement
    extends AutoDisposeFutureProviderElement<List<WordModel>>
    with WordsByLevelRef {
  _WordsByLevelProviderElement(super.provider);

  @override
  String get level => (origin as WordsByLevelProvider).level;
  @override
  int get limit => (origin as WordsByLevelProvider).limit;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
