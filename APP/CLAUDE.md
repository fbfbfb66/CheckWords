# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

CheckWords 是一个离线优先的词汇学习应用，基于 Flutter 开发。应用使用 SQLite 数据库存储词汇数据，支持全文搜索、收藏和学习功能。

## 开发环境设置

### 基本要求
- Flutter SDK >= 3.16.0
- Dart SDK >= 3.2.0
- 开发平台支持：Windows、Android、iOS

### 网络代理设置（中国大陆开发环境）
在 `start.md` 中设置了代理配置，用于访问 Flutter 资源：
```powershell
$env:HTTP_PROXY = "http://127.0.0.1:10808"
$env:HTTPS_PROXY = "http://127.0.0.1:10808"
$env:PUB_HOSTED_URL = "https://pub.flutter-io.cn"
$env:FLUTTER_STORAGE_BASE_URL = "https://storage.flutter-io.cn"
```

### 常用开发命令

```bash
# 获取依赖
flutter pub get

# 生成代码（运行 build_runner）
flutter packages pub run build_runner build --delete-conflicting-outputs

# 运行应用
flutter run

# 构建 Windows 应用
flutter build windows

# 构建 Android 应用
flutter build apk

# 代码分析
flutter analyze

# 运行测试
flutter test
```

## 项目架构

### 核心技术栈
- **状态管理**: Flutter Riverpod
- **路由**: GoRouter
- **数据库**: Drift (SQLite)
- **国际化**: flutter_localizations + flutter_intl
- **数据模型**: Freezed + JSON Serializable

### 目录结构
```
lib/
├── app/                    # 应用核心配置
│   ├── app.dart           # 应用入口配置
│   ├── theme/             # 主题配置
│   └── router/            # 路由配置
├── core/                  # 核心功能
│   ├── database/          # 数据库相关
│   │   ├── app_database.dart      # 数据库主文件
│   │   ├── tables/               # 数据表定义
│   │   └── database_provider.dart # 数据库提供者
│   └── services/          # 服务层
│       └── data_import_service.dart # 数据导入服务
├── shared/                # 共享组件
│   ├── models/            # 数据模型
│   ├── providers/         # Riverpod 提供者
│   └── widgets/           # 通用组件
├── features/              # 功能模块
│   ├── auth/              # 认证模块
│   ├── home/              # 主页模块
│   ├── words/             # 词汇模块
│   ├── learning/          # 学习模块
│   ├── settings/          # 设置模块
│   └── profile/           # 个人资料模块
└── l10n/                  # 国际化文件
```

### 数据库架构

使用 Drift ORM 管理SQLite数据库，包含以下主要表：
- `words_table`: 词汇数据表，支持 FTS5 全文搜索
- `users_table`: 用户表
- `user_words_table`: 用户词汇关联表
- `search_history_table`: 搜索历史表

### 关键特性

#### FTS5 全文搜索
- 创建虚拟表 `words_fts` 用于高性能搜索
- 支持前缀匹配、模糊搜索和排序
- 搜索结果按相关性、频率和长度排序

#### 数据导入机制
- 应用启动时自动从 `assets/data/words_seed.json` 导入词汇数据
- 支持版本控制和强制重新导入
- 分批处理大量数据，避免内存问题

#### 状态管理
- 使用 Riverpod 进行状态管理
- 各功能模块独立的 Provider
- 支持异步状态处理

## 数据模型

### 词汇数据结构
当前使用的词汇数据格式包含：
- `word`: 单词
- `parts_of_speech`: 词性
- `pos_meanings`: 词性释义
- `phrases`: 短语
- `sentences`: 例句
- `pronunciation`: 发音
- `tags`: 标签
- `synonyms`: 同义词
- `antonyms`: 反义词

## 重要配置文件

### pubspec.yaml
项目依赖配置，包含所有必要的第三方库。

### analysis_options.yaml
代码分析规则配置。

### build.yaml
构建配置，用于代码生成。

## 开发注意事项

### 代码生成
项目大量使用代码生成（Freezed、Riverpod、Drift），修改数据模型或提供者后需要运行：
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 数据库迁移
修改数据库结构时需要更新 `schemaVersion` 并实现相应的迁移逻辑。

### 国际化
添加新的文本字符串后需要运行：
```bash
flutter gen-l10n
```

### 调试功能
应用包含调试助手 `debug_helper.dart`，可以在开发时使用。

## 项目当前状态

根据 `Requirements.md`，项目正计划从现有的 AI 生成数据源迁移到 kajweb/dict 项目的标准化词典数据，这将涉及：
- 数据结构重新设计
- UI 界面更新
- 新增分类选择器
- 支持更多词汇类别（CET4、CET6、考研、雅思等）