import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_paths.dart';
import '../../../app/theme/design_tokens.dart';
import '../../../shared/models/user_model.dart';
import '../../../shared/models/word_model.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../shared/providers/learning_provider.dart';
import '../../../shared/providers/locale_provider.dart';
import '../../../l10n/generated/l10n_simple.dart';

class LearningPage extends ConsumerStatefulWidget {
  const LearningPage({super.key});

  @override
  ConsumerState<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends ConsumerState<LearningPage> {
  ProviderSubscription<UserModel?>? _userSubscription;

  @override
  void initState() {
    super.initState();

    _userSubscription = ref.listenManual<UserModel?>(
      currentUserProvider,
      (previous, next) {
        if (next != null) {
          unawaited(
            ref.read(learningSessionProvider.notifier).startLearning(),
          );
        } else {
          ref.read(learningSessionProvider.notifier).resetSession();
        }
      },
      fireImmediately: true,
    );
  }

  @override
  void dispose() {
    _userSubscription?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    // 监听 locale 变化以确保页面在语言切换时重建
    ref.watch(localeNotifierProvider);

    if (!isAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: Text(S.current.learningWords),
          centerTitle: true,
        ),
        body: _buildNotLoggedInView(),
      );
    }

    final session = ref.watch(learningSessionProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(S.current.learningWords),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _showExitConfirmationDialog,
        ),
        actions: [
          if (!session.isLoading &&
              session.totalWords > 0 &&
              !session.isCompleted)
            Padding(
              padding: const EdgeInsets.only(right: DesignTokens.spacingMedium),
              child: Center(
                child: Text(
                  '${session.completedCount}/${session.totalWords}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: _buildBody(session),
      ),
    );
  }

  Widget _buildBody(LearningSessionState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.isCompleted) {
      return _buildCompletionView();
    }

    final currentWord = state.currentWord;
    if (currentWord == null) {
      return _buildNoWordsView(state);
    }

    return _buildActiveLearningView(currentWord, state);
  }

  Widget _buildActiveLearningView(WordModel word, LearningSessionState state) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(DesignTokens.spacingLarge),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: state.progress,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
          ),
          const SizedBox(height: DesignTokens.spacingSmall),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(S.current.completedCount(state.completedCount),
                  style: theme.textTheme.bodyMedium),
              Text(S.current.remainingCount(state.remainingCount),
                  style: theme.textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingXLarge),
          Expanded(
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DesignTokens.radiusLarge),
              ),
              child: Padding(
                padding: const EdgeInsets.all(DesignTokens.spacingXLarge),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      word.word,
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (word.usIpa != null && word.usIpa!.isNotEmpty) ...[
                      const SizedBox(height: DesignTokens.spacingSmall),
                      Text(
                        'US · ${word.usIpa}',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: DesignTokens.spacingXLarge),
                    Container(
                      padding: const EdgeInsets.all(DesignTokens.spacingMedium),
                      decoration: BoxDecoration(
                        color: state.showAnswer
                            ? theme.colorScheme.primaryContainer
                            : theme.colorScheme.surfaceContainerHighest,
                        borderRadius:
                            BorderRadius.circular(DesignTokens.radiusMedium),
                      ),
                      child: Text(
                        state.showAnswer ? word.primaryMeaning : S.current.clickToShowMeaning,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: state.showAnswer
                              ? theme.colorScheme.onPrimaryContainer
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (state.showAnswer && word.partsOfSpeech.isNotEmpty) ...[
                      const SizedBox(height: DesignTokens.spacingLarge),
                      Wrap(
                        spacing: DesignTokens.spacingSmall,
                        runSpacing: DesignTokens.spacingSmall,
                        alignment: WrapAlignment.center,
                        children: word.partsOfSpeech
                            .take(3)
                            .map(
                              (part) => Chip(
                                label: Text(part),
                                backgroundColor:
                                    theme.colorScheme.secondaryContainer,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: DesignTokens.spacingLarge),
          if (!state.showAnswer)
            _buildShowAnswerButton()
          else
            _buildAnswerButtons(),
          const SizedBox(height: DesignTokens.spacingLarge),
        ],
      ),
    );
  }

  Widget _buildShowAnswerButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: () {
          ref.read(learningSessionProvider.notifier).showAnswer();
        },
        child: Text(S.current.showMeaning),
      ),
    );
  }

  Widget _buildAnswerButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: () => _handleAnswer(false),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(S.current.dontKnow),
            ),
          ),
        ),
        const SizedBox(width: DesignTokens.spacingMedium),
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () => _handleAnswer(true),
              child: Text(S.current.knowIt),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleAnswer(bool isKnown) async {
    await ref.read(learningSessionProvider.notifier).handleWordResult(isKnown);
  }

  Widget _buildCompletionView() {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingXLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events,
              size: 96,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: DesignTokens.spacingXLarge),
            Text(
              S.current.learningCompleted,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMedium),
            Text(
              S.current.keepGoing,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingXLarge),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(learningSessionProvider.notifier).restartLearning();
                },
                child: const Text('继续学习'),
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMedium),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _exitLearning,
                child: const Text('返回'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoWordsView(LearningSessionState state) {
    final hasFavoritedWords = state.hasFavoritedWords;
    final allFavoritedMastered = state.allFavoritedMastered;

    final title = allFavoritedMastered
        ? '收藏的单词都已学完'
        : hasFavoritedWords
            ? '暂无待学习单词'
            : '暂无学习单词';

    final subtitle = allFavoritedMastered
        ? '点击下方按钮可以重置学习进度，再次开始学习这些收藏的单词。'
        : hasFavoritedWords
            ? '收藏的单词已全部学习完成，可前往收录页添加新的学习目标。'
            : '请先在单词页面收藏一些单词再来学习。';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingXLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_outline,
              size: 80,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: DesignTokens.spacingLarge),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DesignTokens.spacingMedium),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DesignTokens.spacingXLarge),
            if (allFavoritedMastered) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ref
                        .read(learningSessionProvider.notifier)
                        .resetMasteredFavorites();
                  },
                  child: const Text('重新开始学习'),
                ),
              ),
              const SizedBox(height: DesignTokens.spacingMedium),
            ],
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _exitLearning,
                child: const Text('返回'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotLoggedInView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingXLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.login_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
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
              '登录后即可开始学习单词。',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DesignTokens.spacingXLarge),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _exitLearning,
                child: const Text('返回'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _exitLearning() {
    final router = GoRouter.of(context);
    if (router.canPop()) {
      router.pop();
    } else {
      router.go(RoutePaths.collectedWords);
    }
  }

  void _showExitConfirmationDialog() {
    showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('确认退出'),
        content: const Text('确定要退出学习吗？当前进度将会保存。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Future.delayed(const Duration(milliseconds: 100), () {
                if (mounted) {
                  _exitLearning();
                }
              });
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('退出'),
          ),
        ],
      ),
    );
  }
}
