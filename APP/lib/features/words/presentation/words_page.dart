import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/router/route_paths.dart';
import '../../../app/theme/design_tokens.dart';
import '../../../shared/models/word_model.dart';
import '../../../shared/providers/words_provider.dart';
import '../../../shared/widgets/custom_text_field.dart';
import 'debug_helper.dart';

/// 单词页面（首页）
class WordsPage extends ConsumerStatefulWidget {
  const WordsPage({super.key});

  @override
  ConsumerState<WordsPage> createState() => _WordsPageState();
}

class _WordsPageState extends ConsumerState<WordsPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<String> _searchHistory = [];
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CheckWords'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report_outlined),
            tooltip: '快速调试',
            onPressed: () => _showQuickDebug(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMedium),
      child: SearchTextField(
        controller: _searchController,
        hintText: '搜索单词...',
        onChanged: _handleSearchChanged,
        onSubmitted: _handleSearchSubmitted,
        onClear: _handleSearchClear,
      ),
    );
  }

  Widget _buildContent() {
    if (_currentQuery.isEmpty) {
      return _buildHomeContent();
    }
    return _buildSearchResults();
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding:
          const EdgeInsets.symmetric(horizontal: DesignTokens.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_searchHistory.isNotEmpty)
            _buildSection(
              title: '搜索历史',
              hasMoreAction: true,
              onMorePressed: _showClearHistoryDialog,
              moreText: '清除全部',
              child: _buildSearchHistory(),
            ),
          if (_searchHistory.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: DesignTokens.spacingXXLarge),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.history,
                      size: 80,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: DesignTokens.spacingLarge),
                    Text(
                      '暂无搜索历史',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: DesignTokens.spacingMedium),
                    Text(
                      '搜索单词后，历史记录会出现在这里',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    final searchResultsAsync = ref.watch(searchWordsProvider(_currentQuery));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingMedium,
            vertical: DesignTokens.spacingSmall,
          ),
          child: Text(
            '搜索 "" 的结果',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Expanded(
          child: searchResultsAsync.when(
            data: (words) {
              if (words.isEmpty) {
                return _buildNoResultsView(_currentQuery);
              }
              return _buildWordsList(words);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => _buildErrorView(error.toString()),
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
    bool hasMoreAction = false,
    VoidCallback? onMorePressed,
    String? moreText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: DesignTokens.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (hasMoreAction && onMorePressed != null)
                TextButton(
                  onPressed: onMorePressed,
                  child: Text(moreText ?? '更多'),
                ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingMedium),
          child,
        ],
      ),
    );
  }

  Widget _buildSearchHistory() {
    if (_searchHistory.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(
        bottom: DesignTokens.spacingLarge,
        left: DesignTokens.spacingMedium,
        right: DesignTokens.spacingMedium,
      ),
      itemCount: _searchHistory.length,
      separatorBuilder: (_, __) => const SizedBox(
        height: DesignTokens.spacingSmall,
      ),
      itemBuilder: (context, index) {
        final keyword = _searchHistory[index];
        final wordAsync = ref.watch(wordByNameProvider(keyword));

        return wordAsync.when(
          data: (word) {
            final displayWord = word?.word ?? keyword;
            return _buildHistoryBubble(
              displayWord: displayWord,
              partsOfSpeech: word?.partsOfSpeech ?? const [],
              meaning: word?.primaryMeaning ?? '',
              onTap: () => _searchWord(displayWord),
              onDetail: word == null
                  ? null
                  : () => _navigateToWordDetail(word.id, displayWord),
            );
          },
          loading: () => _buildHistoryBubble(
            displayWord: keyword,
            partsOfSpeech: const [],
              meaning: '加载中…',
            isSkeleton: true,
          ),
          error: (_, __) => _buildHistoryBubble(
            displayWord: keyword,
            partsOfSpeech: const [],
            meaning: '',
            onTap: () => _searchWord(keyword),
          ),
        );
      },
    );
  }

  Widget _buildHistoryBubble({
    required String displayWord,
    required List<String> partsOfSpeech,
    required String meaning,
    VoidCallback? onTap,
    VoidCallback? onDetail,
    bool isSkeleton = false,
  }) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surfaceVariant;
    final onSurface = theme.colorScheme.onSurfaceVariant;
    final effectiveMeaning = meaning.isNotEmpty ? meaning : '暂无释义';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: isSkeleton ? null : onTap,
        child: Container(
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingMedium,
            vertical: DesignTokens.spacingSmall,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            displayWord,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!isSkeleton && onDetail != null)
                          IconButton(
                            icon: const Icon(Icons.open_in_new, size: 18),
                            onPressed: onDetail,
                            padding: EdgeInsets.zero,
                            splashRadius: 18,
                          ),
                      ],
                    ),
                    if (partsOfSpeech.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: DesignTokens.spacingXSmall,
                          bottom: DesignTokens.spacingXSmall,
                        ),
                        child: Wrap(
                          spacing: DesignTokens.spacingXSmall,
                          runSpacing: DesignTokens.spacingXSmall,
                          children: partsOfSpeech
                              .take(3)
                              .map((pos) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: DesignTokens.spacingSmall,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      pos,
                                      style:
                                          theme.textTheme.labelSmall?.copyWith(
                                        color: theme
                                            .colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    Text(
                      effectiveMeaning,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWordsList(List<WordModel> words) {
    return ListView.builder(
      controller: _scrollController,
      padding:
          const EdgeInsets.symmetric(horizontal: DesignTokens.spacingMedium),
      itemCount: words.length,
      itemBuilder: (context, index) => _buildWordListItem(words[index]),
    );
  }

  Widget _buildWordListItem(WordModel word) {
    return Card(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingSmall),
      child: ListTile(
        title: Text(
          word.word,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (word.partsOfSpeech.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: DesignTokens.spacingXSmall),
                child: Wrap(
                  spacing: DesignTokens.spacingXSmall,
                  runSpacing: DesignTokens.spacingXSmall,
                  children: word.partsOfSpeech.take(3).map((pos) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacingSmall,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius:
                            BorderRadius.circular(DesignTokens.radiusSmall),
                      ),
                      child: Text(
                        pos,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    );
                  }).toList(),
                ),
              ),
            if (word.primaryMeaning.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: DesignTokens.spacingXSmall),
                child: Text(
                  word.primaryMeaning,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _navigateToWordDetail(word.id, word.word),
      ),
    );
  }

  Widget _buildNoResultsView(String query) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingLarge),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: DesignTokens.spacingMedium),
              Text(
                '查询不到相关单词',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: DesignTokens.spacingSmall),
              Text(
                '没有找到与 "" 相关的单词',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: DesignTokens.spacingMedium),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '请尝试：',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: DesignTokens.spacingXSmall),
                  Text('· 检查拼写是否正确', style: _buildHintTextStyle()),
                  Text('· 尝试使用同义词', style: _buildHintTextStyle()),
                  Text('· 尝试更简短的关键词', style: _buildHintTextStyle()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.grey),
            const SizedBox(height: DesignTokens.spacingMedium),
            Text('加载失败: '),
            const SizedBox(height: DesignTokens.spacingMedium),
            ElevatedButton(
              onPressed: () => setState(() {}),
              child: const Text('重试'),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle? _buildHintTextStyle() {
    return Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );
  }

  void _handleSearchChanged(String value) {
    final trimmed = value.trim();
    if (trimmed.length >= 2) {
      setState(() {
        _currentQuery = trimmed;
      });
    } else if (trimmed.isEmpty) {
      setState(() {
        _currentQuery = '';
      });
    }
  }

  void _handleSearchSubmitted(String value) {
    final query = value.trim();
    if (query.isNotEmpty) {
      setState(() {
        _currentQuery = query;
      });
    }
  }

  void _handleSearchClear() {
    setState(() {
      _currentQuery = '';
      _searchController.clear();
    });
  }

  void _searchWord(String word) {
    _searchController.text = word;
    setState(() {
      _currentQuery = word;
    });
  }

  Future<void> _navigateToWordDetail(int wordId, String searchQuery) async {
    final trimmedQuery = searchQuery.trim();
    if (trimmedQuery.isNotEmpty) {
      await _addSearchHistoryItem(trimmedQuery);
    }

    if (!mounted) {
      return;
    }

    final path = trimmedQuery.isNotEmpty
        ? RoutePaths.buildWordDetailPathWithQuery(wordId, trimmedQuery)
        : RoutePaths.buildWordDetailPath(wordId);
    context.push(path);
  }

  void _showClearHistoryDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('清除搜索历史'),
        content: const Text('确定要清除所有搜索历史吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await _clearSearchHistory();
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  Future<void> _clearSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('search_history');
      if (!mounted) {
        return;
      }
      setState(() {
        _searchHistory = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('搜索历史已清空')),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('清除失败: `$e')),
      );
    }
  }

  Future<void> _addSearchHistoryItem(String word) async {
    final trimmedWord = word.trim();
    if (trimmedWord.isEmpty) {
      return;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString('search_history');
      List<String> history = [];
      if (historyJson != null) {
        final List<dynamic> historyList = jsonDecode(historyJson);
        history = historyList.cast<String>();
      }
      history.remove(trimmedWord);
      history.insert(0, trimmedWord);
      if (history.length > 30) {
        history = history.take(30).toList();
      }
      await prefs.setString('search_history', jsonEncode(history));
      if (!mounted) {
        return;
      }
      setState(() {
        _searchHistory = history;
      });
    } catch (e) {
      debugPrint('保存搜索历史失败: `$e');
    }
  }

  Future<void> _loadSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString('search_history');
      if (historyJson == null) {
        return;
      }
      final List<dynamic> historyList = jsonDecode(historyJson);
      final history = historyList.cast<String>();
      if (!mounted) {
        return;
      }
      setState(() {
        _searchHistory = history;
      });
    } catch (e) {
      debugPrint('加载搜索历史失败: `$e');
    }
  }

  void _showQuickDebug() {
    DebugHelper.showQuickDiagnosis(context, ref);
  }
}
