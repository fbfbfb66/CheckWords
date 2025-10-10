# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

这是一个基于Flutter的离线优先词汇学习应用，专门用于CET4等英语考试单词学习。应用使用SQLite作为本地数据库，支持单词搜索、收藏、学习进度跟踪等功能。

## 常用命令

### 开发命令
```bash
# 启动开发服务器
flutter run

# 构建应用
flutter build apk --release
flutter build ios --release

# 运行测试
flutter test

# 代码生成
flutter pub run build_runner build --delete-conflicting-outputs

# 格式化代码
flutter format .

# 静态分析
flutter analyze

# 清理构建缓存
flutter clean
flutter pub get
```

### 数据库相关
```bash
# 查看数据库状态（在main.dart中已集成调试输出）
# 应用启动时会自动导入和验证CET4词汇数据
```

## 项目架构

### 核心架构
- **状态管理**: Flutter Riverpod (2.4.10)
- **路由管理**: GoRouter (13.2.4)
- **数据库**: Drift (2.16.0) + SQLite3
- **序列化**: Freezed + JSON Annotation
- **国际化**: flutter_intl

### 目录结构
```
lib/
├── core/                    # 核心功能
│   ├── database/           # 数据库相关
│   │   ├── app_database.dart      # 主数据库类
│   │   ├── tables/               # 数据表定义
│   │   └── database_provider.dart # 数据库Provider
│   └── services/           # 服务层
│       └── data_import_service.dart # 数据导入服务
├── features/               # 功能模块
│   ├── auth/              # 认证模块
│   ├── home/              # 首页模块
│   ├── words/             # 单词模块
│   ├── learning/          # 学习模块
│   ├── profile/           # 个人资料
│   └── settings/          # 设置模块
├── shared/                # 共享组件
│   ├── models/            # 数据模型
│   ├── providers/         # Riverpod Providers
│   └── widgets/          # 共享UI组件
├── app/                   # 应用配置
│   ├── app.dart           # 应用导出
│   ├── router/            # 路由配置
│   └── theme/             # 主题配置
└── l10n/                  # 国际化
```

### 数据库架构

#### 主要数据表
1. **words_table**: 词汇主表
   - 存储CET4词汇的完整信息
   - 包含单词、音标、释义、例句、短语等
   - 支持FTS5全文搜索

2. **users_table**: 用户表
   - 用户基本信息和认证

3. **user_words_table**: 用户-单词关联表
   - 收藏、学习进度、掌握程度

4. **search_history_table**: 搜索历史表
   - 记录用户搜索历史

#### 数据导入
- 使用`DataImportService`从assets导入预置的CET4词汇数据
- 支持版本控制和数据清洗
- 应用启动时自动执行数据导入和验证

### 状态管理

#### 主要Providers
- **authNotifierProvider**: 用户认证状态
- **wordsProvider**: 单词数据和搜索
- **favoritesProvider**: 收藏功能
- **learningProvider**: 学习进度
- **localeProvider**: 语言设置
- **themeProvider**: 主题设置

### 数据模型

#### WordModel
核心词汇数据模型，基于kajweb/dict格式：
- **基本信息**: wordId, bookId, wordRank, headWord
- **发音**: usphone, ukphone, usspeech, ukspeech
- **释义**: trans (包含词性、中英文释义)
- **例句**: sentences (中英文对照)
- **短语**: phrases (固定搭配)
- **同近义词**: synonyms
- **同根词**: relWords
- **考试题目**: exams

## 开发注意事项

### 数据库操作
- 数据库版本升级时需要更新`schemaVersion`和迁移逻辑
- 使用FTS5进行全文搜索，支持中英文搜索
- 数据导入使用`DataImportService`，包含版本控制和错误处理

### 代码生成
- 使用`build_runner`生成必要的代码文件
- 涉及Freezed、Drift、Riverpod Generator等

### 国际化
- 使用`flutter_intl`管理多语言
- 主要支持中文和英文
- 语言文件位于`lib/l10n/`

### 搜索功能
- 实现了前缀匹配和全文搜索的混合搜索
- 搜索结果按相关性排序
- 支持中文释义搜索

### 音频播放
- 使用`audioplayers`播放单词发音
- 支持美式和英式发音

## 关键特性

1. **离线优先**: 所有数据本地存储，无需网络连接
2. **智能搜索**: 支持单词前缀匹配和全文搜索
3. **数据完整性**: 自动数据导入和验证机制
4. **性能优化**: 数据库索引、FTS5搜索优化
5. **类型安全**: 使用Freezed和Drift确保类型安全