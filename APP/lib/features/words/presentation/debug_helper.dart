import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import '../../../core/database/database_provider.dart';
import '../../../core/services/data_import_service.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../shared/models/user_model.dart';

/// 简单的调试助手
class DebugHelper {
  /// 显示快速诊断对话框
  static void showQuickDiagnosis(BuildContext context, WidgetRef ref) {
    final database = ref.read(databaseProvider);
    final authState = ref.read(userNotifierProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('应用诊断'),
        content: SizedBox(
          height: 300,
          width: 400,
          child: FutureBuilder<Map<String, dynamic>>(
            future: _checkAppStatus(database, ref),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Text('错误: ${snapshot.error}');
              }

              final data = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('数据库状态:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    _buildStatusItem('单词总数', '${data['word_count'] ?? 0}'),
                    _buildStatusItem('样本单词', data['samples'] ?? '无'),
                    if (data['found_common'] != null)
                      _buildStatusItem('找到常用词', data['found_common'], isGood: true),
                    if (data['missing_common'] != null)
                      _buildStatusItem('常用词状态', data['missing_common'], isError: true),

                    const SizedBox(height: 16),
                    const Text('用户认证状态:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    _buildStatusItem('登录状态', data['auth_status'] ?? '未知'),
                    _buildStatusItem('用户数', '${data['user_count'] ?? 0}'),
                    if (data['current_user'] != null)
                      _buildStatusItem('当前用户', data['current_user'], isGood: true),
                    if (data['auth_error'] != null)
                      _buildStatusItem('认证错误', data['auth_error'], isError: true),

                    if (data['warning'] != null)
                      _buildStatusItem('警告', data['warning'], isError: true),
                    if (data['error'] != null)
                      _buildStatusItem('错误信息', data['error'], isError: true),
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetDeviceUser(context, ref);
            },
            child: const Text('重置设备用户'),
          ),
        ],
      ),
    );
  }

  /// 检查应用状态
  static Future<Map<String, dynamic>> _checkAppStatus(database, WidgetRef ref) async {
    final results = <String, dynamic>{};

    try {
      // 检查单词数据总数
      final wordCountResult = await database.customSelect(
        'SELECT COUNT(*) as count FROM words_table',
      ).getSingle();

      final wordCount = wordCountResult.data['count'] as int;
      results['word_count'] = wordCount;

      // 获取单词样本
      if (wordCount > 0) {
        final samples = await database.customSelect(
          'SELECT head_word FROM words_table ORDER BY head_word LIMIT 5',
        ).get();
        results['samples'] = samples.map((r) => r.data['head_word']).join(', ');
      } else {
        results['samples'] = '无数据';
      }

      // 检查用户数据
      final userCountResult = await database.customSelect(
        'SELECT COUNT(*) as count FROM users_table',
      ).getSingle();

      final userCount = userCountResult.data['count'] as int;
      results['user_count'] = userCount;

      // 检查认证状态
      try {
        final authState = ref.read(userNotifierProvider);
        authState.when(
          data: (state) {
            if (state.hasUser && state.isValid) {
              results['auth_status'] = '✓ 已登录';
              results['current_user'] = state.user?.name ?? '未知用户';
            } else {
              results['auth_status'] = '✗ 未登录';
              if (!state.hasUser) {
                results['auth_error'] = '用户未登录';
              } else if (!state.isValid) {
                results['auth_error'] = '用户状态无效';
              }
            }
          },
          loading: () => results['auth_status'] = '加载中...',
          error: (error, stack) => results['auth_error'] = error.toString(),
        );
      } catch (e) {
        results['auth_error'] = e.toString();
        results['auth_status'] = '✗ 异常';
      }

      // 检查一些常见英文单词是否存在
      if (wordCount > 0) {
        final commonWords = ['the', 'a', 'an', 'and', 'or', 'but', 'hello', 'world', 'apple'];
        final foundWords = <String>[];

        for (final word in commonWords) {
          final found = await database.customSelect(
            'SELECT head_word FROM words_table WHERE head_word = ? LIMIT 1',
            variables: [drift.Variable.withString(word)],
          ).get();
          if (found.isNotEmpty) {
            foundWords.add(word);
          }
        }

        if (foundWords.isNotEmpty) {
          results['found_common'] = foundWords.join(', ');
        } else {
          results['missing_common'] = '⚠️ 常用单词缺失 - 可能需要重新导入数据';
        }
      }

      if (userCount == 0) {
        results['warning'] = '⚠️ 没有用户数据，无法测试登录功能';
      }

    } catch (e) {
      results['error'] = e.toString();
    }

    return results;
  }

  /// 重置设备用户
  static Future<void> _resetDeviceUser(BuildContext context, WidgetRef ref) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      await ref.read(userNotifierProvider.notifier).resetUser();

      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('设备用户已重置'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('重置失败: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  /// 构建状态项
  static Widget _buildStatusItem(String label, String value, {bool isError = false, bool isGood = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isError ? Colors.red :
                       isGood ? Colors.green :
                       value.contains('✗') ? Colors.red :
                       value.contains('✓') ? Colors.green :
                       value.contains('⚠️') ? Colors.orange : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  }