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
import '../../../core/services/audio_service.dart';
import '../../../shared/widgets/collapsible_section.dart';
import 'package:flutter/foundation.dart';

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
  final AudioService _audioService = AudioService();

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
        actions: [],
      ),
      body: SafeArea(
        child: wordAsync.when(
          data: (word) {
            if (word == null) {
              return const Center(
                child: Text('未找到该单词'),
              );
            }
            // 添加额外的安全检查
            if (word.headWord.isEmpty) {
              return const Center(
                child: Text('单词数据不完整'),
              );
            }
            return _buildSafeWordContent(word);
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
                Text('加载失败: ${error.toString()}'),
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

  /// 安全构建单词内容，带有错误处理
  Widget _buildSafeWordContent(WordModel word) {
    // 使用Builder确保正确的上下文
    return Builder(
      builder: (context) {
        try {
          
          // 验证基本数据
          if (word.headWord == null || word.headWord.isEmpty) {
            return _buildErrorWidget('单词数据无效', 'headWord为空或null');
          }

          // 验证必要的数据完整性
          if (!_validateWordData(word)) {
            return _buildFallbackWordContent(word);
          }

          // 直接构建内容，避免复杂的异步渲染问题
          return _buildWordContent(word);
        } catch (e, stackTrace) {

          // 显示用户友好的错误信息
          if (mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('页面渲染出现问题，显示简化版本'),
                    duration: const Duration(seconds: 2),
                    backgroundColor: Colors.orange,
                    action: SnackBarAction(
                      label: '详情',
                      onPressed: () {
                        _showErrorDialog(context, e.toString());
                      },
                    ),
                  ),
                );
              }
            });
          }

          return _buildFallbackWordContent(word);
        }
      },
    );
  }

  /// 验证单词数据完整性
  bool _validateWordData(WordModel word) {
    try {
      // 检查基本字段
      if (word.headWord.isEmpty) return false;
      if (word.id <= 0) return false;
      if (word.wordId.isEmpty) return false;

      // 检查集合类型字段是否为null
      if (word.trans == null) return false;
      if (word.sentences == null) return false;
      if (word.phrases == null) return false;
      if (word.synonyms == null) return false;
      if (word.relWords == null) return false;
      if (word.exams == null) return false;

      return true;
    } catch (e) {
      return false;
    }
  }

  /// 构建单词内容
  Widget _buildWordContent(WordModel word) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              minWidth: constraints.maxWidth,
            ),
            child: Container(
              padding: const EdgeInsets.all(DesignTokens.spacingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // 确保Column只占用需要的空间
                children: [
            // 单词头部：单词、音标、收藏按钮
            _buildWordHeader(word),
            const SizedBox(height: DesignTokens.spacingLarge),
            // 分类和排名信息
            _buildWordMeta(word),
            const SizedBox(height: DesignTokens.spacingLarge),
            // 词性释义
            _buildTransSection(word),
            const SizedBox(height: DesignTokens.spacingLarge),
            // 例句
            if (word.sentences.isNotEmpty) ...[
              _buildSentencesSection(word),
              const SizedBox(height: DesignTokens.spacingLarge),
            ],
            // 短语
            if (word.phrases.isNotEmpty) ...[
              _buildPhrasesSection(word),
              const SizedBox(height: DesignTokens.spacingLarge),
            ],
            // 同近义词
            if (word.synonyms.isNotEmpty) ...[
              _buildSynonymsSection(word),
              const SizedBox(height: DesignTokens.spacingLarge),
            ],
            // 同根词
            if (word.relWords.isNotEmpty) ...[
              _buildRelWordsSection(word),
              const SizedBox(height: DesignTokens.spacingLarge),
            ],
            // 考试题目
            if (word.exams.isNotEmpty) ...[
              _buildExamsSection(word),
            ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// 构建单词头部信息
  Widget _buildWordHeader(WordModel word) {
    final BuildContext context = this.context;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingLarge),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 单词本身
                  Text(
                    word.headWord ?? '未知单词',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spacingSmall),

                  // 音标
                  if (word.usPhone != null || word.ukPhone != null) ...[
                    Wrap(
                      spacing: DesignTokens.spacingMedium,
                      runSpacing: DesignTokens.spacingSmall,
                      children: [
                        if (word.usPhone != null) ...[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('美音: ', style: TextStyle(fontSize: 12)),
                              Flexible(
                                child: Text(
                                  word.usPhone!,
                                  style: const TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // 美音播放按钮
                              InkWell(
                                onTap: () => _playPronunciation(word.headWord, 'us'),
                                borderRadius: BorderRadius.circular(12),
                                child: const Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Icon(
                                    Icons.volume_up,
                                    size: 16,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (word.ukPhone != null) ...[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('英音: ', style: TextStyle(fontSize: 12)),
                              Flexible(
                                child: Text(
                                  word.ukPhone!,
                                  style: const TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // 英音播放按钮
                              InkWell(
                                onTap: () => _playPronunciation(word.headWord, 'uk'),
                                borderRadius: BorderRadius.circular(12),
                                child: const Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Icon(
                                    Icons.volume_up,
                                    size: 16,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: DesignTokens.spacingSmall),
                  ],
                ],
              ),
            ),

            // 收藏按钮
            _buildFavoriteButton(word),
          ],
        ),
      ),
    );
  }

  /// 构建单词元信息
  Widget _buildWordMeta(WordModel word) {
    final BuildContext context = this.context;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingMedium),
        child: Row(
          children: [
            // 书籍ID/分类
            Chip(
              label: Text(
                _getCategoryName(word.bookId),
                style: const TextStyle(fontSize: 12),
              ),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
            const SizedBox(width: DesignTokens.spacingSmall),

            // 排名
            Chip(
              label: Text(
                '排名: ${word.wordRank}',
                style: const TextStyle(fontSize: 12),
              ),
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            ),
          ],
        ),
      ),
    );
  }

  /// 从bookId获取分类名称
  String _getCategoryName(String bookId) {
    if (bookId.contains('CET4')) return 'CET4';
    if (bookId.contains('CET6')) return 'CET6';
    if (bookId.contains('考研') || bookId.contains('KAUYAN')) return '考研';
    if (bookId.contains('IELTS')) return '雅思';
    if (bookId.contains('TOEFL')) return '托福';
    if (bookId.contains('GRE')) return 'GRE';
    return bookId;
  }

  /// 构建主要释义部分（核心信息）
  Widget _buildTransSection(WordModel word) {
    final BuildContext context = this.context;
    if (word.trans.isEmpty) {
      return const SizedBox.shrink();
    }

    // 只显示前2个释义作为核心信息
    final mainTrans = word.trans.take(2).toList();

    return Container(
      width: 380, // 固定Card宽度
      constraints: const BoxConstraints(
        minWidth: 300, // 最小宽度
        maxWidth: 400, // 最大宽度
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // 高度自适应
            children: [
              Text(
                '词性释义',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: DesignTokens.spacingMedium),
              // 词性释义内容
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // 高度自适应
                children: [
                  ...mainTrans.asMap().entries.map((entry) {
                    final index = entry.key;
                    final trans = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index < mainTrans.length - 1 ? DesignTokens.spacingMedium : 0,
                      ),
                      child: _buildTransItem(context, trans),
                    );
                  }),

                  // 如果有更多释义，显示折叠部分
                  if (word.trans.length > 2) ...[
                    const SizedBox(height: DesignTokens.spacingMedium),
                    CollapsibleSection(
                      title: '更多释义',
                      count: word.trans.length - 2,
                      icon: Icons.more_horiz,
                      initiallyExpanded: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min, // 高度自适应
                        children: word.trans.skip(2).map((trans) => Padding(
                          padding: const EdgeInsets.only(bottom: DesignTokens.spacingMedium),
                          child: _buildTransItem(context, trans),
                        )).toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建单个释义项目（高度自适应）
  Widget _buildTransItem(BuildContext context, dynamic trans) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // 高度自适应
      children: [
        // 词性标签
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            trans.pos,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: DesignTokens.spacingSmall),
        // 中文释义 - 高度自适应
        Text(
          trans.tranCn,
          style: Theme.of(context).textTheme.bodyLarge,
          softWrap: true, // 允许换行
          maxLines: null, // 不限制行数，高度自适应
        ),
        if (trans.tranOther != null && trans.tranOther!.isNotEmpty) ...[
          const SizedBox(height: DesignTokens.spacingSmall),
          // 其他释义 - 高度自适应
          Text(
            trans.tranOther!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
            softWrap: true, // 允许换行
            maxLines: null, // 不限制行数，高度自适应
          ),
        ],
      ],
    );
  }

  /// 构建例句部分
  Widget _buildSentencesSection(WordModel word) {
    final BuildContext context = this.context;
    return CollapsibleSection(
      title: '例句',
      count: word.sentences.length,
      icon: Icons.format_quote,
      initiallyExpanded: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: word.sentences.asMap().entries.map((entry) {
          final index = entry.key;
          final sentence = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < word.sentences.length - 1 ? DesignTokens.spacingMedium : 0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 编号
                Text(
                  '${index + 1}.',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),

                // 英文例句
                Text(
                  sentence.sContent,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 4),

                // 中文翻译
                Text(
                  sentence.sCn,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 构建发音区域 (已移除，音标信息在头部显示)
  Widget _buildPronunciationSection(WordModel word) {
    final BuildContext context = this.context;
    return const SizedBox.shrink();
  }

  /// 构建内容区域（已移除，直接在主构建方法中处理）
  Widget _buildContentSection(WordModel word) {
    final BuildContext context = this.context;
    return const SizedBox.shrink();
  }

  /// 构建例句区域
  Widget _buildExamplesSection(WordModel word) {
    final BuildContext context = this.context;
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
  Widget _buildSentenceItem(WordModel word, int index, KajSentence sentence) {
    final BuildContext context = this.context;
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
                sentence.sContent,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 4),
              
              // 中文翻译
              Text(
                sentence.sCn,
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
      return SizedBox(
        width: 40,
        height: 40,
        child: IconButton(
          icon: const Icon(Icons.favorite_border, size: 24),
          onPressed: () => _showLoginRequiredDialog(),
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
        ),
      );
    }

    // 用户已登录，显示真实的收藏状态
    final favoriteToggleAsync = ref.watch(favoriteToggleProvider(word.id));

    return favoriteToggleAsync.when(
      data: (isFavorited) => SizedBox(
        width: 40,
        height: 40,
        child: IconButton(
          icon: Icon(
            isFavorited ? Icons.favorite : Icons.favorite_border,
            size: 24,
            color: isFavorited ? Colors.red : null,
          ),
          onPressed: () => _toggleFavorite(word),
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
        ),
      ),
      loading: () => const Padding(
        padding: EdgeInsets.all(12.0),
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (error, stack) => SizedBox(
        width: 40,
        height: 40,
        child: IconButton(
          icon: const Icon(Icons.favorite_border, size: 24),
          onPressed: () => _toggleFavorite(word),
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
        ),
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

  /// 构建短语部分
  Widget _buildPhrasesSection(WordModel word) {
    final BuildContext context = this.context;
    return CollapsibleSection(
      title: '短语',
      count: word.phrases.length,
      icon: Icons.short_text,
      initiallyExpanded: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: word.phrases.asMap().entries.map((entry) {
          final index = entry.key;
          final phrase = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < word.phrases.length - 1 ? DesignTokens.spacingMedium : 0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            phrase.pContent,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                            softWrap: true,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            phrase.pCn,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 构建同近义词部分
  Widget _buildSynonymsSection(WordModel word) {
    final BuildContext context = this.context;
    return CollapsibleSection(
      title: '同近义词',
      count: word.synonyms.length,
      icon: Icons.compare,
      initiallyExpanded: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: word.synonyms.asMap().entries.map((entry) {
          final index = entry.key;
          final syno = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < word.synonyms.length - 1 ? DesignTokens.spacingMedium : 0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(syno.pos),
                ),
                const SizedBox(height: DesignTokens.spacingSmall),
                Text(
                  syno.tran,
                  softWrap: true,
                ),
                if (syno.hwds.isNotEmpty) ...[
                  const SizedBox(height: DesignTokens.spacingSmall),
                  Wrap(
                    spacing: DesignTokens.spacingSmall,
                    runSpacing: DesignTokens.spacingSmall,
                    children: [
                      const Text(
                        '近义词: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...syno.hwds.map((hwd) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacingSmall,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
                        ),
                        child: Text(
                          hwd.w,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )),
                    ],
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 构建同根词部分
  Widget _buildRelWordsSection(WordModel word) {
    final BuildContext context = this.context;
    return CollapsibleSection(
      title: '同根词',
      count: word.relWords.fold<int>(0, (sum, relWord) => sum + relWord.words.length),
      icon: Icons.account_tree,
      initiallyExpanded: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: word.relWords.asMap().entries.map((entry) {
          final index = entry.key;
          final relWord = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < word.relWords.length - 1 ? DesignTokens.spacingMedium : 0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(relWord.pos),
                ),
                const SizedBox(height: DesignTokens.spacingSmall),
                Wrap(
                  spacing: DesignTokens.spacingSmall,
                  runSpacing: DesignTokens.spacingSmall,
                  children: relWord.words.map((relatedWord) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacingSmall,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          relatedWord.hwd,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (relatedWord.tran.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            relatedWord.tran,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  )).toList(),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 构建考试题目部分
  Widget _buildExamsSection(WordModel word) {
    final BuildContext context = this.context;
    return CollapsibleSection(
      title: '考试题目',
      count: word.exams.length,
      icon: Icons.quiz,
      initiallyExpanded: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '共 ${word.exams.length} 道题目',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingMedium),
          ElevatedButton.icon(
            onPressed: () => _showExamDialog(word),
            icon: const Icon(Icons.quiz, size: 16),
            label: const Text('开始测试', style: TextStyle(fontSize: 12)),
          ),
          const SizedBox(height: DesignTokens.spacingMedium),
          // 显示题目预览（只显示题目类型）
          ...word.exams.asMap().entries.map((entry) {
            final index = entry.key;
            final exam = entry.value;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < word.exams.length - 1 ? DesignTokens.spacingSmall : 0,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(DesignTokens.spacingSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.help_outline,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: DesignTokens.spacingSmall),
                    Expanded(
                      child: Text(
                        '题目 ${index + 1}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacingSmall,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
                      ),
                      child: Text(
                        '类型 ${exam.examType}',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  /// 显示考试题目对话框
  void _showExamDialog(WordModel word) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('考试题目'),
        content: const Text('考试题目功能正在开发中...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  /// 构建简化的单词内容（作为fallback）
  Widget _buildFallbackWordContent(WordModel word) {
    final BuildContext context = this.context;
    // 使用LayoutBuilder确保有正确的约束
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(DesignTokens.spacingMedium),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - 100, // 确保最小高度
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 简化的单词头部
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(DesignTokens.spacingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          word.headWord,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // 显示音标信息
                        if (word.usPhone != null || word.ukPhone != null) ...[
                          Wrap(
                            children: [
                              if (word.usPhone != null) ...[
                                const Text('美音: ', style: TextStyle(fontSize: 12)),
                                Text(word.usPhone!, style: const TextStyle(fontSize: 12)),
                                const SizedBox(width: 16),
                              ],
                              if (word.ukPhone != null) ...[
                                const Text('英音: ', style: TextStyle(fontSize: 12)),
                                Text(word.ukPhone!, style: const TextStyle(fontSize: 12)),
                              ],
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                        const SizedBox(height: 8),
                        Text(
                          '单词详情暂时无法完全显示',
                          style: const TextStyle(color: Colors.orange, fontSize: 12),
                        ),

                        // 显示主要释义
                        if (word.trans.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            '释义: ${word.trans.first.tranCn}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  
  /// 构建简化的单词头部
  Widget _buildSimpleWordHeader(WordModel word) {
    final BuildContext context = this.context;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 单词本身
            Text(
              word.headWord ?? '未知单词',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),

            // 音标
            if (word.usPhone != null || word.ukPhone != null) ...[
              Wrap(
                children: [
                  if (word.usPhone != null) ...[
                    const Text('美音: ', style: TextStyle(fontSize: 12)),
                    Text(word.usPhone!, style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 16),
                    // 美音播放按钮
                    InkWell(
                      onTap: () => _playPronunciation(word.headWord, 'us'),
                      borderRadius: BorderRadius.circular(12),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.volume_up, size: 16, color: Colors.blue),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                  if (word.ukPhone != null) ...[
                    const Text('英音: ', style: TextStyle(fontSize: 12)),
                    Text(word.ukPhone!, style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 16),
                    // 英音播放按钮
                    InkWell(
                      onTap: () => _playPronunciation(word.headWord, 'uk'),
                      borderRadius: BorderRadius.circular(12),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.volume_up, size: 16, color: Colors.blue),
                      ),
                    ),
                  ],
                ],
              ),
            ],

            // 主要释义
            if (word.trans.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                '释义: ${word.trans.map((t) => t.tranCn).join('；')}',
                style: const TextStyle(fontSize: 14),
              ),
            ],

            // 简单分隔线
            const SizedBox(height: 8),
            const Divider(),
          ],
        ),
      ),
    );
  }

  /// 播放单词发音
  void _playPronunciation(String word, String type) async {
    try {
      await _audioService.playWordPronunciation(word, type);

      // 显示播放提示
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('正在播放 ${type == 'us' ? '美式' : '英式'} 发音'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('播放失败: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  /// 构建错误组件
  Widget _buildErrorWidget(String title, String message) {
    final BuildContext context = this.context;
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: DesignTokens.spacingMedium),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: DesignTokens.spacingSmall),
              Text(message, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: DesignTokens.spacingMedium),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('返回'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建加载组件
  Widget _buildLoadingWidget(String message) {
    final BuildContext context = this.context;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: DesignTokens.spacingMedium),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  /// 显示错误对话框
  void _showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('渲染错误'),
        content: SingleChildScrollView(
          child: Text(error),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}

/// PostFrameCallbackWrapper - 确保在下一帧渲染的包装组件
class PostFrameCallbackWrapper extends StatefulWidget {
  final Widget Function() callback;
  final Widget fallback;

  const PostFrameCallbackWrapper({
    super.key,
    required this.callback,
    required this.fallback,
  });

  @override
  State<PostFrameCallbackWrapper> createState() => _PostFrameCallbackWrapperState();
}

class _PostFrameCallbackWrapperState extends State<PostFrameCallbackWrapper> {
  bool _hasRendered = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_hasRendered) {
        setState(() {
          _hasRendered = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _hasRendered ? widget.callback() : widget.fallback;
  }
}