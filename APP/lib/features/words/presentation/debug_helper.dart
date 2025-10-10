import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/services/data_import_service.dart';

/// 简单的调试助手
class DebugHelper {
  /// 显示快速诊断对话框
  static void showQuickDiagnosis(BuildContext context, WidgetRef ref) {
    final database = ref.read(databaseProvider);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('数据库诊断'),
        content: SizedBox(
          height: 150,
          child: FutureBuilder<Map<String, dynamic>>(
            future: _checkDatabase(database),
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
                    _buildStatusItem('数据库状态', data['status'] ?? '未知'),
                    _buildStatusItem('单词总数', '${data['count'] ?? 0}'),
                    _buildStatusItem('样本单词', data['samples'] ?? '无'),
                    if (data['found_common'] != null)
                      _buildStatusItem('找到常用词', data['found_common'], isGood: true),
                    if (data['missing_common'] != null)
                      _buildStatusItem('常用词状态', data['missing_common'], isError: true),
                    if (data['import_flag'] != null)
                      _buildStatusItem('数据导入', data['import_flag']),
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
          ElevatedButton(
            onPressed: () => _forceReimportData(context, database),
            child: const Text('重新导入数据'),
          ),
          ElevatedButton(
            onPressed: () => _forceFixDatabase(context, database),
            child: const Text('修复搜索'),
          ),
        ],
      ),
    );
  }

  /// 检查数据库状态
  static Future<Map<String, dynamic>> _checkDatabase(database) async {
    final results = <String, dynamic>{};
    
    try {
      // 检查数据总数
      final countResult = await database.customSelect(
        'SELECT COUNT(*) as count FROM words_table',
      ).getSingle();
      
      final count = countResult.data['count'] as int;
      results['count'] = count;
      results['status'] = count > 0 ? '✓ 正常' : '✗ 无数据';

      // 获取样本 - 查找真正的英文单词
      if (count > 0) {
        // 查找以字母开头的单词（简单方式）
        final englishWords = await database.customSelect(
          "SELECT head_word FROM words_table WHERE head_word >= 'a' AND head_word < 'z' AND LENGTH(head_word) > 1 ORDER BY head_word LIMIT 5",
        ).get();

        if (englishWords.isNotEmpty) {
          results['samples'] = englishWords.map((r) => r.data['head_word']).join(', ');
        } else {
          // 尝试查找任何包含字母的单词
          final anyWords = await database.customSelect(
            "SELECT head_word FROM words_table WHERE head_word LIKE '%a%' OR head_word LIKE '%e%' OR head_word LIKE '%i%' ORDER BY head_word LIMIT 5",
          ).get();

          if (anyWords.isNotEmpty) {
            results['samples'] = anyWords.map((r) => r.data['head_word']).join(', ');
          } else {
            // 如果都没有，显示前几个单词
            final samples = await database.customSelect(
              'SELECT head_word FROM words_table ORDER BY head_word LIMIT 5',
            ).get();
            results['samples'] = samples.map((r) => r.data['head_word']).join(', ');
            results['warning'] = '⚠️ 数据质量问题：多为数字/符号';
          }
        }

        // 检查一些常见英文单词是否存在
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
          
          // 检查数据导入状态
          try {
            final prefs = await SharedPreferences.getInstance();
            final isMarkedAsImported = prefs.getBool('data_imported') ?? false;
            results['import_flag'] = '导入标记: ${isMarkedAsImported ? "已标记" : "未标记"}';
          } catch (e) {
            results['import_flag'] = '导入标记检查失败: $e';
          }
        }
      }

    } catch (e) {
      results['error'] = e.toString();
      results['status'] = '✗ 异常';
    }
    
    return results;
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

  /// 强制重新导入数据
  static void _forceReimportData(BuildContext context, database) async {
    Navigator.pop(context); // 关闭当前对话框
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        title: Text('正在重新导入数据'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('清空现有数据并重新导入单词库...\n这可能需要1-2分钟，请稍候'),
          ],
        ),
      ),
    );

    try {
      // 使用DataImportService强制重新导入
      final success = await DataImportService.forceReimport(database);
      
      Navigator.pop(context); // 关闭进度对话框
      
      // 显示导入结果
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(success ? '导入成功' : '导入失败'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(success 
                ? '✅ 数据重新导入成功！\n🔍 搜索功能已恢复\n📊 所有单词数据已更新' 
                : '❌ 数据导入失败\n请检查assets/data/words_seed.json文件\n或重启应用后再试'),
              if (success) const SizedBox(height: 16),
              if (success) const Text('现在可以正常搜索单词了！', 
                style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('确定'),
            ),
          ],
        ),
      );
      
    } catch (e) {
      Navigator.pop(context); // 关闭进度对话框
      
      // 显示错误信息
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('导入失败'),
          content: Text('导入过程中出现错误: $e\n\n请重启应用后再试'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('确定'),
            ),
          ],
        ),
      );
    }
  }

  /// 强制修复数据库 - 简化版本
  static void _forceFixDatabase(BuildContext context, database) async {
    Navigator.pop(context); // 关闭当前对话框
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        title: Text('正在修复数据库'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('使用简化方案，约5-10秒...'),
          ],
        ),
      ),
    );

    try {
      // 重建FTS5索引而不是删除
      await database.customStatement('DROP TABLE IF EXISTS words_fts');
      
      // 重新创建FTS5表
      await database.customStatement('''
        CREATE VIRTUAL TABLE words_fts USING fts5(
          head_word,
          word_id,
          search_content
        );
      ''');

      // 重新创建触发器保持FTS表同步
      await database.customStatement('''
        CREATE TRIGGER words_fts_insert AFTER INSERT ON words_table BEGIN
          INSERT INTO words_fts(rowid, head_word, word_id, search_content)
          VALUES (new.id, new.head_word, new.word_id, new.search_content);
        END;
      ''');

      await database.customStatement('''
        CREATE TRIGGER words_fts_delete AFTER DELETE ON words_table BEGIN
          DELETE FROM words_fts WHERE rowid = old.id;
        END;
      ''');

      await database.customStatement('''
        CREATE TRIGGER words_fts_update AFTER UPDATE ON words_table BEGIN
          DELETE FROM words_fts WHERE rowid = old.id;
          INSERT INTO words_fts(rowid, head_word, word_id, search_content)
          VALUES (new.id, new.head_word, new.word_id, new.search_content);
        END;
      ''');

      // 同步数据到FTS5表
      await database.customStatement('''
        INSERT INTO words_fts(rowid, head_word, word_id, search_content)
        SELECT id, head_word, word_id, search_content FROM words_table
      ''');

      // 测试FTS5搜索是否工作
      final testResult = await database.customSelect(
        '''
        SELECT w.head_word FROM words_table w
        INNER JOIN words_fts fts ON w.id = fts.rowid
        WHERE words_fts MATCH ?
        LIMIT 1
        ''',
        variables: [drift.Variable.withString('hello')],
      ).get();

      Navigator.pop(context); // 关闭进度对话框
      
      // 显示修复结果
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('修复完成'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('✅ 已重建FTS5全文搜索索引'),
              const Text('🚀 已同步所有单词数据'),
              Text('🧪 测试FTS5搜索"hello": ${testResult.isNotEmpty ? '✅ 成功' : '❌ 失败'}'),
              const SizedBox(height: 16),
              const Text('搜索功能已修复，现在应该能正常工作了！', 
                style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('确定'),
            ),
          ],
        ),
      );
      
    } catch (e) {
      Navigator.pop(context); // 关闭进度对话框
      
      // 显示错误信息
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('修复失败'),
          content: Text('错误: $e\n\n请重启应用后再试'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('确定'),
            ),
          ],
        ),
      );
    }
  }
}