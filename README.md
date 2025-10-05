# CheckWords APP

CheckWords 是一款基于 Flutter 构建的英语词汇学习应用，支持离线词库、收藏、搜索与多主题切换，适用于移动端、Web 与桌面平台。

## 功能特点
- Riverpod 状态管理，提供一致的跨页面状态体验
- Drift 本地数据库保存词汇、收藏与学习历史，可离线使用
- GoRouter 实现的多页面路由，支持深链导航
- 多主题与字体切换，适配亮色/暗色模式
- 多语言本地化（含中文）与响应式布局

## 环境要求
- Flutter 3.16 或更高版本
- Dart SDK 与 Flutter SDK 已正确安装，并通过 `flutter doctor`
- Android Studio / Xcode / Chrome / Edge 等至少一个可用运行目标

## 快速开始
```bash
cd APP
flutter pub get
flutter run -d <device-id>
```
首次运行会在 `assets/data/` 目录读取预置的 `words.db` 与 `words_seed.json` 并自动导入。

## 目录说明
- `lib/`：应用源代码（路由、主题、数据库、功能模块）
- `assets/`：内置词库、字体与静态资源
- `android/`、`ios/`、`web/`：各平台工程文件
- `test/`：Flutter 单元/组件测试示例

## 常用命令
- `flutter format .`：格式化 Dart 代码
- `flutter analyze`：静态分析
- `flutter test`：运行测试

如需自定义词库，可更新 `assets/data/words_seed.json` 或替换 `words.db`，并在首次启动前清理应用持久化数据。
