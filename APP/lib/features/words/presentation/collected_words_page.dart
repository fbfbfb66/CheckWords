import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_paths.dart';
import '../../../app/theme/design_tokens.dart';
import '../../../shared/providers/auth_provider.dart';

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

  // 模拟数据（实际应从数据库获取）
  final List<Map<String, dynamic>> _favoriteWords = [];
  final List<Map<String, dynamic>> _masteredWords = [];
  final List<Map<String, dynamic>> _learningWords = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadCollectedWords();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  /// 标签页变化监听
  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    }
  }

  /// 加载收录的单词
  void _loadCollectedWords() {
    // TODO: 从数据库加载用户收录的单词
    // 目前为空，等实现数据库查询功能
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    if (!isAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('收录单词'),
          centerTitle: true,
        ),
        body: _buildNotLoggedInView(context),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('收录单词'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.favorite, size: 16),
                  const SizedBox(width: 4),
                  Text('收录 (${_favoriteWords.length})'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, size: 16),
                  const SizedBox(width: 4),
                  Text('已掌握 (${_masteredWords.length})'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.school, size: 16),
                  const SizedBox(width: 4),
                  Text('学习中 (${_learningWords.length})'),
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
                  _buildWordList(_favoriteWords, '收录'),
                  _buildWordList(_masteredWords, '已掌握'),
                  _buildWordList(_learningWords, '学习中'),
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
          hintText: '搜索收录的单词...',
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
          setState(() {});
          // TODO: 实现搜索功能
        },
      ),
    );
  }

  /// 构建单词列表
  Widget _buildWordList(List<Map<String, dynamic>> words, String category) {
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
              onPressed: () => context.go(RoutePaths.home),
              child: const Text('去搜索单词'),
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
              '请先登录',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMedium),
            
            Text(
              '登录后可以查看您收录的单词',
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
                child: const Text('立即登录'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建单词卡片
  Widget _buildWordCard(Map<String, dynamic> wordData) {
    return Card(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingMedium),
      child: ListTile(
        contentPadding: const EdgeInsets.all(DesignTokens.spacingMedium),
        title: Row(
          children: [
            Text(
              wordData['word'] ?? '',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: DesignTokens.spacingSmall),
            Text(
              wordData['phonetic'] ?? '',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontFamily: 'Inter', // 强制使用Inter字体显示音标
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: DesignTokens.spacingSmall),
            Text(
              wordData['meaning'] ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (wordData['tags'] != null && wordData['tags'].isNotEmpty) ...[
              const SizedBox(height: DesignTokens.spacingSmall),
              Wrap(
                spacing: DesignTokens.spacingSmall,
                children: (wordData['tags'] as List<String>)
                    .map((tag) => Chip(
                          label: Text(
                            tag,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          visualDensity: VisualDensity.compact,
                        ))
                    .toList(),
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
              },
            ),
            PopupMenuButton<String>(
              onSelected: (value) => _handleWordAction(value, wordData),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'favorite',
                  child: ListTile(
                    leading: Icon(Icons.favorite_border),
                    title: Text('切换收录状态'),
                    dense: true,
                  ),
                ),
                const PopupMenuItem(
                  value: 'mastered',
                  child: ListTile(
                    leading: Icon(Icons.check_circle_outline),
                    title: Text('标记为已掌握'),
                    dense: true,
                  ),
                ),
                const PopupMenuItem(
                  value: 'learning',
                  child: ListTile(
                    leading: Icon(Icons.school_outlined),
                    title: Text('标记为学习中'),
                    dense: true,
                  ),
                ),
                const PopupMenuItem(
                  value: 'remove',
                  child: ListTile(
                    leading: Icon(Icons.delete_outline, color: Colors.red),
                    title: Text('移除收录', style: TextStyle(color: Colors.red)),
                    dense: true,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          // TODO: 跳转到单词详情页
          if (wordData['id'] != null) {
            context.push(RoutePaths.buildWordDetailPath(wordData['id']));
          }
        },
      ),
    );
  }

  /// 处理单词操作
  void _handleWordAction(String action, Map<String, dynamic> wordData) {
    switch (action) {
      case 'favorite':
        // TODO: 切换收录状态
        break;
      case 'mastered':
        // TODO: 标记为已掌握
        break;
      case 'learning':
        // TODO: 标记为学习中
        break;
      case 'remove':
        _showRemoveWordDialog(wordData);
        break;
    }
  }

  /// 显示移除单词确认对话框
  void _showRemoveWordDialog(Map<String, dynamic> wordData) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('移除收录'),
        content: Text('确定要移除单词 "${wordData['word']}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('移除'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        // TODO: 实现移除收录功能
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('已移除单词："${wordData['word']}"'),
          ),
        );
      }
    });
  }

  /// 获取空状态图标
  IconData _getEmptyStateIcon(String category) {
    switch (category) {
      case '收录':
        return Icons.favorite_outline;
      case '已掌握':
        return Icons.check_circle_outline;
      case '学习中':
        return Icons.school_outlined;
      default:
        return Icons.list_alt_outlined;
    }
  }

  /// 获取空状态标题
  String _getEmptyStateTitle(String category) {
    switch (category) {
      case '收录':
        return '还没有收录的单词';
      case '已掌握':
        return '还没有已掌握的单词';
      case '学习中':
        return '还没有学习中的单词';
      default:
        return '还没有收录任何单词';
    }
  }

  /// 获取空状态副标题
  String _getEmptyStateSubtitle(String category) {
    switch (category) {
      case '收录':
        return '在搜索页面找到喜欢的单词，点击收录按钮将它们添加到这里';
      case '已掌握':
        return '学习过程中掌握的单词会出现在这里';
      case '学习中':
        return '正在学习的单词会出现在这里';
      default:
        return '开始搜索和收录您感兴趣的单词吧';
    }
  }
}