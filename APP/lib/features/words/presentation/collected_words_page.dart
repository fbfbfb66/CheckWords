import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_paths.dart';
import '../../../app/theme/design_tokens.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../shared/providers/favorites_provider.dart';
import '../../../shared/providers/locale_provider.dart';
import '../../../shared/models/word_model.dart';
import '../../../core/database/tables/user_words_table.dart';
import '../../../l10n/generated/l10n_simple.dart';

/// 收录单词页面
class CollectedWordsPage extends ConsumerStatefulWidget {
  const CollectedWordsPage({super.key});

  @override
  ConsumerState<CollectedWordsPage> createState() => _CollectedWordsPageState();
}

class _CollectedWordsPageState extends ConsumerState<CollectedWordsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  // 当前选中的标签索引
  int _currentTabIndex = 0;

  // 搜索关键词
  String _searchQuery = '';

  // 搜索防抖定时器
  Timer? _searchDebouncer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    // 移除_loadCollectedWords调用，改为实时获取数据
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _searchDebouncer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 页面重新获得焦点时触发刷新
    if (mounted) {
      // 延迟一下刷新，确保其他页面的操作已经完成
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  /// 标签页变化监听
  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    }
  }

  /// 根据学习状态获取单词
  Future<List<WordModel>> _getWordsByStatus(LearningStatus status) async {
    // 这里暂时只实现了收藏功能，其他学习状态为空
    if (status == LearningStatus.notLearned) {
      // 获取收藏的单词（isFavorited = true）
      final favoriteWordsAsync = ref.read(favoriteWordsProvider(limit: 1000));
      return favoriteWordsAsync.when(
        data: (words) => words,
        loading: () => [],
        error: (_, __) => [],
      );
    }
    return []; // 已掌握和学习中的单词暂时为空
  }

  /// 搜索收录的单词
  Future<List<WordModel>> _searchWords(LearningStatus status) async {
    if (_searchQuery.isEmpty) return [];

    // 只在收录分类中搜索收藏的单词
    if (status == LearningStatus.notLearned) {
      final favoriteWordsAsync = ref.read(favoriteWordsProvider(limit: 1000));
      return favoriteWordsAsync.when(
        data: (words) => words
            .where((word) =>
                word.headWord.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                word.primaryMeaning
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()))
            .toList(),
        loading: () => [],
        error: (_, __) => [],
      );
    }
    // 已掌握和学习中分类暂时为空，不返回任何单词
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    // 监听 locale 变化以确保页面在语言切换时重建
    ref.watch(localeNotifierProvider);

    if (!isAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: Text(S.current.favoriteWords),
          centerTitle: true,
        ),
        body: _buildNotLoggedInView(context),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.favoriteWords),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
          tabs: [
            Tab(
              child: Consumer(
                builder: (context, ref, child) {
                  final favoriteCountAsync =
                      ref.watch(favoriteWordsCountProvider);
                  return favoriteCountAsync.when(
                    data: (count) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.favorite, size: 16),
                        const SizedBox(width: 4),
                        Text('${S.current.collected} ($count)'),
                      ],
                    ),
                    loading: () => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.favorite, size: 16),
                        const SizedBox(width: 4),
                        Text('${S.current.collected} (...'),
                      ],
                    ),
                    error: (_, __) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.favorite, size: 16),
                        const SizedBox(width: 4),
                        Text('${S.current.collected} (0)'),
                      ],
                    ),
                  );
                },
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, size: 16),
                  const SizedBox(width: 4),
                  Text(S.current.masteredWithCount ?? '已掌握 (0)'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.school, size: 16),
                  const SizedBox(width: 4),
                  Text(S.current.learningWithCount ?? '学习中 (0)'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 搜索栏
            _buildSearchBar(),

            // 内容区域
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildWordsList(LearningStatus.notLearned, S.current.collected),
                  _buildWordsList(LearningStatus.mastered, S.current.mastered),
                  _buildWordsList(LearningStatus.learning, S.current.learning),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建搜索栏
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMedium),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: S.current.searchCollectedWords,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        onChanged: (value) {
          // 取消之前的防抖定时器
          _searchDebouncer?.cancel();

          // 设置新的防抖定时器（300ms防抖）
          _searchDebouncer = Timer(const Duration(milliseconds: 300), () {
            if (mounted) {
              setState(() {
                _searchQuery = value.trim();
              });
            }
          });
        },
      ),
    );
  }

  /// 构建单词列表
  Widget _buildWordsList(LearningStatus status, String category) {
    // 已掌握和学习中分类暂时显示空状态
    if (status == LearningStatus.mastered ||
        status == LearningStatus.learning) {
      return _buildEmptyView(category);
    }

    return Consumer(
      builder: (context, ref, child) {
        if (_searchQuery.isEmpty) {
          // 显示所有收藏单词 - 使用Consumer自动监听数据变化
          final favoriteWordsAsync =
              ref.watch(favoriteWordsProvider(limit: 1000));

          return favoriteWordsAsync.when(
            data: (words) => _buildWordsListView(words, category),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => _buildErrorView(category, S.current.loadFailed),
          );
        } else {
          // 显示搜索结果 - 只在收录分类中搜索
          final favoriteWordsAsync =
              ref.watch(favoriteWordsProvider(limit: 1000));

          return favoriteWordsAsync.when(
            data: (words) {
              final searchWords = words
                  .where((word) =>
                      word.headWord
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()) ||
                      word.primaryMeaning
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()))
                  .toList();
              return _buildWordsListView(searchWords, category);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => _buildErrorView(category, S.current.searchFailed),
          );
        }
      },
    );
  }

  /// 构建单词列表视图
  Widget _buildWordsListView(List<WordModel> words, String category) {
    if (words.isEmpty) {
      return _buildEmptyView(category);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(DesignTokens.spacingMedium),
      itemCount: words.length,
      itemBuilder: (context, index) => _buildWordCard(words[index]),
    );
  }

  /// 构建空状态视图
  Widget _buildEmptyView(String category) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingXLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getEmptyStateIcon(category),
              size: 80,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: DesignTokens.spacingLarge),
            Text(
              _getEmptyStateTitle(category),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: DesignTokens.spacingMedium),
            Text(
              _getEmptyStateSubtitle(category),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DesignTokens.spacingXLarge),
            ElevatedButton(
              onPressed: () {
                if (category == S.current.learning) {
                  // 学习中分类跳转到学习页面
                  context.push(RoutePaths.learning);
                } else {
                  context.go(RoutePaths.home);
                }
              },
              child: Text(category == S.current.learning ? S.current.goToLearning : S.current.goToSearchWords),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建搜索为空视图
  Widget _buildEmptySearchView(String category, String query) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingXLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: DesignTokens.spacingLarge),
            Text(
              S.current.noWordsFound,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: DesignTokens.spacingMedium),
            Text(
              S.current.noWordsFoundInCategory(category, query),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DesignTokens.spacingMedium),
            TextButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                });
              },
              child: Text(S.current.clearSearch),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建错误视图
  Widget _buildErrorView(String category, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingXLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: DesignTokens.spacingLarge),
            Text(
              S.current.loadFailed,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: DesignTokens.spacingMedium),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DesignTokens.spacingLarge),
            ElevatedButton(
              onPressed: () => setState(() {}),
              child: Text(S.current.retry),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建未登录视图
  Widget _buildNotLoggedInView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingXLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: 80,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: DesignTokens.spacingLarge),
            Text(
              S.current.pleaseLoginFirst,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: DesignTokens.spacingMedium),
            Text(
              S.current.loginToViewCollectedWords,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DesignTokens.spacingXLarge),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.go(RoutePaths.login),
                child: Text(S.current.loginNow),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建单词卡片
  Widget _buildWordCard(WordModel word) {
    return Card(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingMedium),
      child: ListTile(
        contentPadding: const EdgeInsets.all(DesignTokens.spacingMedium),
        title: Row(
          children: [
            Text(
              word.headWord,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            if (word.usPhone != null && word.usPhone!.isNotEmpty) ...[
              const SizedBox(width: DesignTokens.spacingSmall),
              Text(
                word.usPhone!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontFamily: 'Inter', // 强制使用Inter字体显示音标
                    ),
              ),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: DesignTokens.spacingSmall),
            Text(
              word.primaryMeaning,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (word.partsOfSpeech.isNotEmpty) ...[
              const SizedBox(height: DesignTokens.spacingSmall),
              Wrap(
                spacing: DesignTokens.spacingSmall,
                children: word.partsOfSpeech.take(3).map((pos) {
                  return Chip(
                    label: Text(
                      pos,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    visualDensity: VisualDensity.compact,
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                  );
                }).toList(),
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.volume_up_outlined),
              onPressed: () {
                // TODO: 播放发音
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(S.current.pronunciationFeatureNotImplemented)),
                );
              },
            ),
            PopupMenuButton<String>(
              onSelected: (value) => _handleWordAction(value, word),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'favorite',
                  child: Consumer(
                    builder: (context, ref, child) {
                      final isFavoritedAsync =
                          ref.watch(isWordFavoritedProvider(word.id));
                      return isFavoritedAsync.when(
                        data: (isFavorited) => ListTile(
                          leading: Icon(
                            isFavorited
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFavorited ? Colors.red : null,
                          ),
                          title: Text(isFavorited ? S.current.removeFromCollection : S.current.addToCollection),
                          dense: true,
                        ),
                        loading: () => const ListTile(
                          leading: CircularProgressIndicator(),
                          title: Text('...'),
                          dense: true,
                        ),
                        error: (_, __) => const ListTile(
                          leading: Icon(Icons.favorite_border),
                          title: Text('收录'),
                          dense: true,
                        ),
                      );
                    },
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'mastered',
                  child: ListTile(
                    leading: Icon(Icons.check_circle_outline),
                    title: Text(S.current.markAsMastered),
                    dense: true,
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'learning',
                  child: ListTile(
                    leading: Icon(Icons.school_outlined),
                    title: Text(S.current.markAsLearning),
                    dense: true,
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'remove',
                  child: ListTile(
                    leading: Icon(Icons.delete_outline, color: Colors.red),
                    title: Text(S.current.removeWord, style: TextStyle(color: Colors.red)),
                    dense: true,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          context.push(RoutePaths.buildWordDetailPath(word.id));
        },
      ),
    );
  }

  /// 处理单词操作
  void _handleWordAction(String action, WordModel word) {
    switch (action) {
      case 'favorite':
        _toggleFavorite(word);
        break;
      case 'mastered':
        _showNotImplementedDialog('标记为已掌握');
        break;
      case 'learning':
        _showNotImplementedDialog('标记为学习中');
        break;
      case 'remove':
        _showRemoveWordDialog(word);
        break;
    }
  }

  /// 切换收藏状态
  Future<void> _toggleFavorite(WordModel word) async {
    try {
      final favoriteToggle = ref.read(favoriteToggleProvider(word.id).notifier);
      final newFavoriteState = await favoriteToggle.toggle();

      // 确保UI更新
      if (mounted) {
        setState(() {});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(newFavoriteState
                ? S.current.wordAddedToCollection(word.headWord)
                : S.current.wordRemovedFromCollection(word.headWord)),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.current.operationFailed(e.toString())),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  /// 显示功能未实现对话框
  void _showNotImplementedDialog(String feature) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.current.featureNotImplemented),
        content: Text(S.current.featureWillBeImplemented(feature)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(S.current.gotIt),
          ),
        ],
      ),
    );
  }

  /// 显示移除单词确认对话框
  void _showRemoveWordDialog(WordModel word) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.current.confirmRemoveWord),
        content: Text(S.current.confirmRemoveWordMessage(word.headWord)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(S.current.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(S.current.remove),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        _toggleFavorite(word); // 移除收藏就是取消收藏
      }
    });
  }

  /// 获取空状态图标
  IconData _getEmptyStateIcon(String category) {
    if (category == S.current.collected) {
      return Icons.favorite_outline;
    } else if (category == S.current.mastered) {
      return Icons.check_circle_outline;
    } else if (category == S.current.learning) {
      return Icons.school_outlined;
    }
    return Icons.list_alt_outlined;
  }

  /// 获取空状态标题
  String _getEmptyStateTitle(String category) {
    if (category == S.current.collected) {
      return S.current.noCollectedWords;
    } else if (category == S.current.mastered) {
      return S.current.noMasteredWords;
    } else if (category == S.current.learning) {
      return S.current.noLearningWords;
    }
    return S.current.noCollectedWords;
  }

  /// 获取空状态副标题
  String _getEmptyStateSubtitle(String category) {
    if (category == S.current.collected) {
      return S.current.noCollectedWordsSubtitle;
    } else if (category == S.current.mastered) {
      return S.current.noMasteredWordsSubtitle;
    } else if (category == S.current.learning) {
      return S.current.noLearningWordsSubtitle;
    }
    return S.current.noCollectedWordsSubtitle;
  }
}
