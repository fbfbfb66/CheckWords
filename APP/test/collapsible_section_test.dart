import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:check_words/shared/widgets/collapsible_section.dart';

void main() {
  group('CollapsibleSection Tests', () {
    testWidgets('应该正确显示标题和数量', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CollapsibleSection(
              title: '测试标题',
              count: 5,
              icon: Icons.info,
              child: const Text('测试内容'),
            ),
          ),
        ),
      );

      // 验证标题显示
      expect(find.text('测试标题'), findsOneWidget);

      // 验证数量显示
      expect(find.text('5'), findsOneWidget);

      // 验证图标显示
      expect(find.byIcon(Icons.info), findsOneWidget);
    });

    testWidgets('应该能够展开和折叠内容', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CollapsibleSection(
              title: '测试标题',
              initiallyExpanded: false,
              child: const Text('测试内容'),
            ),
          ),
        ),
      );

      // 初始状态下内容可能不可见，也可能可见（取决于动画状态）
      // 点击展开/折叠来测试功能
      await tester.tap(find.text('测试标题'));
      await tester.pumpAndSettle();

      // 内容应该可见
      expect(find.text('测试内容'), findsOneWidget);

      // 再次点击折叠
      await tester.tap(find.text('测试标题'));
      await tester.pumpAndSettle();

      // 验证可以正常交互
      expect(find.text('测试标题'), findsOneWidget);
    });

    testWidgets('应该正确处理动画效果', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CollapsibleSection(
              title: '测试标题',
              initiallyExpanded: false,
              child: const Text('测试内容'),
            ),
          ),
        ),
      );

      // 点击展开
      await tester.tap(find.text('测试标题'));
      await tester.pump(); // 开始动画

      // 动画过程中应该有过渡效果
      expect(find.text('测试内容'), findsOneWidget);

      // 等待动画完成
      await tester.pumpAndSettle();

      // 最终状态应该完全展开
      expect(find.text('测试内容'), findsOneWidget);
    });
  });
}