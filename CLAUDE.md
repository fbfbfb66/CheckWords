# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

CheckWords 是一个基于 GLM-4.6 AI 模型的离线优先词汇学习应用系统，包含两个主要组件：

1. **数据生成系统** (Python): 使用 AI 自动生成词汇数据的管道系统
2. **移动应用** (Flutter): 基于生成的词汇数据的离线学习应用

## 常用开发命令

### 数据生成和管理

```bash
# 运行词汇生成管道 (在 Resource 目录)
cd Resource && python pipeline.py

# 查看全局统计概览
python stats.py

# 查看详细统计
python stats.py -d

# 验证词汇数据
python validate_words.py

# 合并 Resource2,3,4 到主 Resource
python merge_resources.py

# 验证和合并临时词汇文件
python validate_words.py

# 修复音标错误
python fix_ipa.py

# 测试功能完整性
python test_functionality.py

# 检查和安装依赖
python check_deps.py
```

### Flutter 应用开发

```bash
# 进入应用目录
cd APP

# 获取依赖
flutter pub get

# 运行代码生成
flutter packages pub run build_runner build --delete-conflicting-outputs

# 运行应用
flutter run

# 构建应用
flutter build apk
flutter build ios
```

## 项目架构

### 数据生成系统架构

- **Resource/**: 主要数据生成目录，包含核心管道逻辑
  - `pipeline.py`: 核心词汇生成管道，支持断点续跑和批量处理
  - `words.json`: 生成的词汇数据存储
  - `words.db`: SQLite 格式的词汇数据库
  - `failed_permanent.json`: 永久失败词汇记录
  - `function_words_custom.txt`: 自定义功能词白名单
  - `state.json`: 断点续跑状态文件

- **Resource2/, Resource3/, Resource4/**: 并行数据处理目录
  - 独立的 API key 配置和偏移量设置
  - 用于分布式处理大量词汇数据

- **核心脚本**:
  - `validate_words.py`: 独立的词汇数据验证工具
  - `merge_resources.py`: 整合多个 Resource 目录的数据
  - `fix_ipa.py`: 批量修复 ARPABET 到 IPA 音标转换
  - `stats.py`: 全局数据统计工具
  - `check_deps.py`: 依赖检查和自动安装

### 移动应用架构

- **APP/**: Flutter 移动应用
  - 使用 Riverpod 进行状态管理
  - Go_router 用于导航
  - Drift (SQLite) 用于本地数据存储
  - 支持离线优先的学习体验
  - 全文搜索基于 SQLite FTS5

### 数据流程

1. **词汇生成**: `pipeline.py` 从 wordfreq 获取词汇 → 使用 GLM-4.6 API 生成数据 → 验证和质量检查
2. **数据整合**: `merge_resources.py` 合并多个 Resource 目录的数据
3. **数据验证**: `validate_words.py` 验证 JSON 格式和数据质量
4. **数据部署**: 通过 `deploy_to_app.py` 将数据部署到移动应用
5. **音标修复**: `fix_ipa.py` 修正 CMUdict 音标转换错误

## 重要配置

### 环境变量和配置
- **GLM API**: 在 `config.yaml` 中配置 GLM-4.6 API 密钥
- **并行处理**: 4 个 Resource 目录同时处理不同词汇区间 (0-999, 1000-1999, 2000-2999, 3000-3999)
- **断点续跑**: 通过 `state.json` 跟踪进度
- **自动重试**: 智能重试失败的词汇生成

### 关键文件位置
- **主配置**: `config.yaml` - 系统配置和 API 设置
- **词汇数据**: `Resource/words.json`
- **数据库文件**: `Resource/words.db` 和 `APP/assets/data/words.db`
- **失败词汇**: `Resource/failed_permanent.json`
- **功能词白名单**: `Resource/function_words_custom.txt`
- **AI 提示词模板**: `Prompt.txt`

### 数据格式规范
每个词汇条目必须包含：
- `word`: 词汇原文
- `parts_of_speech`: 词性数组
- `pos_meanings`: 词性对应的中文释义
- `phrases`: 短语和对话数组（功能词可为空）
- `sentences`: 例句数组（由脚本自动补充）
- `pronunciation`: 音标数据（美音 IPA）

## 开发注意事项

### 数据生成
- 使用 `AUTO_OFFSET = True` 可以基于现有词库长度自动设置偏移量
- 功能词（如冠词、介词等）不需要提供短语和对话
- 系统支持断点续跑，通过 `state.json` 跟踪进度
- 失败的词汇会记录到 `failed_permanent.json` 并可重试

### 应用开发
- 应用设计为离线优先，所有数据都存储在本地
- 使用 SQLite 全文搜索支持快速词汇查找
- 支持收藏和学习进度跟踪
- 遵循 Clean Architecture 架构模式

### 质量保证
- 运行 `test_functionality.py` 验证数据流转完整性
- 使用 `validate_words.py` 确保新数据符合格式规范
- 定期运行 `stats.py` 监控数据量和质量状态
- 使用 `check_deps.py` 确保依赖完整性

## 故障排除

- **Python 环境**: 使用 `check_deps.py` 检查和安装依赖
- **配置验证**: 运行 `python verify_word_ranges.py` 验证配置
- **音标问题**: 如果音标显示错误，运行 `python fix_ipa.py` 重新生成正确的 IPA 音标
- **数据生成失败**: 检查 `Resource/logs/` 目录下的日志文件
- **应用数据不同步**: 运行 `python test_functionality.py` 检查数据流转