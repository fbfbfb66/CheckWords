import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../app/router/route_paths.dart';
import '../../../app/theme/design_tokens.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../shared/providers/words_provider.dart';
import '../../../shared/providers/favorites_provider.dart';
import '../../../shared/providers/locale_provider.dart';
import '../../../shared/models/word_model.dart';
import '../../../l10n/generated/l10n_simple.dart';

/// 单词详情页面
class WordDetailPage extends ConsumerStatefulWidget {
  const WordDetailPage({
    super.key,
    required this.wordId,
    this.searchQuery,
  });

  final int wordId;
  final String? searchQuery; // 用户搜索的查询词

  @override
  ConsumerState<WordDetailPage> createState() => _WordDetailPageState();
}

class _WordDetailPageState extends ConsumerState<WordDetailPage> {
  final Map<int, bool> _phraseDialogExpanded = {};

  @override
  void initState() {
    super.initState();
    // 如果有搜索查询词，添加到搜索历史
    if (widget.searchQuery != null && widget.searchQuery!.isNotEmpty) {
      _addSearchHistoryItem(widget.searchQuery!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final wordAsync = ref.watch(wordByIdProvider(widget.wordId));

    // 监听 locale 变化以确保页面在语言切换时重建
    ref.watch(localeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.wordDetail),
      ),
      body: SafeArea(
        child: wordAsync.when(
          data: (word) {
            if (word == null) {
              return const Center(
                child: Text('未找到该单词'),
              );
            }
            return _buildWordContent(word);
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text('加载失败: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.refresh(wordByIdProvider(widget.wordId)),
                  child: const Text('重试'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建单词内容
  Widget _buildWordContent(WordModel word) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(DesignTokens.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 第一栏：单词、词性、含义、收藏
          _buildWordHeader(word),
          
          const SizedBox(height: DesignTokens.spacingLarge),
          
          // 第二栏：音标/音频
          _buildPronunciationSection(word),
          
          const SizedBox(height: DesignTokens.spacingLarge),
          
          // 第三栏：短语对话（可折叠）或例句
          _buildContentSection(word),
        ],
      ),
    );
  }

  /// 构建单词头部信息
  Widget _buildWordHeader(WordModel word) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 单词本身
                      Text(
                        word.word,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spacingSmall),
                      
                      // 词性
                      Wrap(
                        spacing: DesignTokens.spacingSmall,
                        children: word.partsOfSpeech.map((pos) => Chip(
                          label: Text(pos),
                          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                        )).toList(),
                      ),
                    ],
                  ),
                ),
                
                // 收藏按钮
                _buildFavoriteButton(word),
              ],
            ),
            
            const SizedBox(height: DesignTokens.spacingMedium),
            
            // 主要含义
            Text(
              word.primaryMeaning,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            
            // 所有词性含义
            if (word.posMeanings.length > 1) ...[
              const SizedBox(height: DesignTokens.spacingSmall),
              ...word.posMeanings.skip(1).map((meaning) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        meaning.pos,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        meaning.cn,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }

  /// 构建发音区域
  Widget _buildPronunciationSection(WordModel word) {
    final ipa = word.usIpa;
    
    if (ipa == null || ipa.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingLarge),
        child: Row(
          children: [
            Icon(
              Icons.volume_up_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: DesignTokens.spacingMedium),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '美式发音',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    ipa,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontFamily: 'Inter', // 强制使用Inter字体以支持IPA字符
                    ),
                  ),
                ],
              ),
            ),
            
            // 播放按钮
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: word.hasAudio ? () {
                // TODO: 播放音频
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('音频播放功能待实现')),
                );
              } : null,
            ),
          ],
        ),
      ),
    );
  }

  /// 构建内容区域（短语或例句）
  Widget _buildContentSection(WordModel word) {
    if (word.hasPhrases) {
      return _buildPhrasesSection(word);
    } else if (word.sentences.isNotEmpty) {
      return _buildExamplesSection(word);
    } else {
      return const SizedBox.shrink();
    }
  }

  /// 构建短语区域
  Widget _buildPhrasesSection(WordModel word) {
    if (word.phrases.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.chat_bubble_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('常用短语'),
          ),
          const Divider(height: 1),
          ...word.phrases.asMap().entries.map((entry) {
            final index = entry.key;
            final phrase = entry.value;
            return _buildPhraseItem(word, index, phrase);
          }),
        ],
      ),
    );
  }

  /// 构建短语项
  Widget _buildPhraseItem(WordModel word, int index, Phrase phrase) {
    final isExpanded = _phraseDialogExpanded[index] ?? false;
    
    return Column(
      children: [
        // 短语标题行（始终显示）
        ListTile(
          title: Text(
            phrase.phrase,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          trailing: IconButton(
            icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
            onPressed: () {
              setState(() {
                _phraseDialogExpanded[index] = !isExpanded;
              });
            },
          ),
        ),
        
        // 对话内容（可展开）
        if (isExpanded) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              DesignTokens.spacingLarge,
              0,
              DesignTokens.spacingLarge,
              DesignTokens.spacingMedium,
            ),
            child: Column(
              children: [
                _buildDialogItem('A', phrase.dialog.A),
                const SizedBox(height: 8),
                _buildDialogItem('B', phrase.dialog.B),
              ],
            ),
          ),
        ],
        
        // 分割线（最后一项除外）
        if (index < word.phrases.length - 1) const Divider(height: 1),
      ],
    );
  }

  /// 构建对话项
  Widget _buildDialogItem(String speaker, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              speaker,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
      ],
    );
  }

  /// 构建例句区域
  Widget _buildExamplesSection(WordModel word) {
    if (word.sentences.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.format_quote,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('例句'),
          ),
          
          const Divider(height: 1),
          
          ...word.sentences.asMap().entries.map((entry) {
            final index = entry.key;
            final sentence = entry.value;
            return _buildSentenceItem(word, index + 1, sentence);
          }),
        ],
      ),
    );
  }

  /// 构建例句项
  Widget _buildSentenceItem(WordModel word, int index, Sentence sentence) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(DesignTokens.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 编号
              Text(
                '$index.',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              
              // 英文例句
              Text(
                sentence.en,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 4),
              
              // 中文翻译
              Text(
                sentence.cn,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        
        // 分割线（最后一项除外）
        if (index < word.sentences.length) const Divider(height: 1),
      ],
    );
  }

  /// 构建收藏按钮
  Widget _buildFavoriteButton(WordModel word) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    
    if (!isAuthenticated) {
      return IconButton(
        icon: const Icon(Icons.favorite_border, size: 32),
        onPressed: () => _showLoginRequiredDialog(),
      );
    }

    // 用户已登录，显示真实的收藏状态
    final favoriteToggleAsync = ref.watch(favoriteToggleProvider(word.id));
    
    return favoriteToggleAsync.when(
      data: (isFavorited) => IconButton(
        icon: Icon(
          isFavorited ? Icons.favorite : Icons.favorite_border,
          size: 32,
          color: isFavorited ? Colors.red : null,
        ),
        onPressed: () => _toggleFavorite(word),
      ),
      loading: () => const Padding(
        padding: EdgeInsets.all(12.0),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (error, stack) => IconButton(
        icon: const Icon(Icons.favorite_border, size: 32),
        onPressed: () => _toggleFavorite(word),
      ),
    );
  }

  /// 切换收藏状态
  void _toggleFavorite(WordModel word) async {
    final isAuthenticated = ref.read(isAuthenticatedProvider);
    
    if (!isAuthenticated) {
      _showLoginRequiredDialog();
      return;
    }

    try {
      final toggleNotifier = ref.read(favoriteToggleProvider(word.id).notifier);
      final newState = await toggleNotifier.toggle();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(newState ? '已添加到收藏' : '已从收藏中移除'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('操作失败: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  /// 显示需要登录的提示对话框
  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('需要登录'),
        content: const Text('收藏单词需要登录账户，是否前往登录？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.push(RoutePaths.login);
            },
            child: const Text('去登录'),
          ),
        ],
      ),
    );
  }

  /// 添加搜索历史项
  void _addSearchHistoryItem(String word) async {
    try {
      // 获取现有的搜索历史
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString('search_history');
      List<String> searchHistory = [];
      
      if (historyJson != null) {
        final List<dynamic> historyList = jsonDecode(historyJson);
        searchHistory = historyList.cast<String>();
      }
      
      // 如果已存在，先移除
      searchHistory.remove(word);
      // 添加到开头
      searchHistory.insert(0, word);
      // 限制最大数量为30个
      if (searchHistory.length > 30) {
        searchHistory = searchHistory.take(30).toList();
      }
      
      // 保存到SharedPreferences
      final newHistoryJson = jsonEncode(searchHistory);
      await prefs.setString('search_history', newHistoryJson);
    } catch (e) {
      // 如果保存失败，静默处理
      debugPrint('保存搜索历史失败: $e');
    }
  }
}