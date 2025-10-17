# CheckWords - 离线优先的词汇学习应用

[![Flutter](https://img.shields.io/badge/Flutter-3.16.0+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.2.0+-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

一个基于Flutter开发的离线优先词汇学习应用，支持多种词汇数据源，提供完整的单词学习体验。

## ✨ 功能特性

### 📚 词汇学习
- **多数据源支持**：CET4、CET6、TOEFL、IELTS、GRE等
- **完整词汇信息**：音标、释义、例句、短语、同近义词、同根词
- **智能分类**：基于bookId自动分类管理
- **离线优先**：本地数据库存储，无需网络连接

### 🎯 学习功能
- **单词详情**：全面的词汇信息展示
- **收藏管理**：收藏重要单词便于复习
- **搜索功能**：快速查找需要的单词
- **发音支持**：美音英音播放
- **学习进度**：记录学习状态

### 🌐 用户体验
- **现代化UI**：Material Design 3设计规范
- **响应式布局**：适配不同屏幕尺寸
- **多语言支持**：中英文界面切换
- **流畅动画**：丰富的交互动效

## 🛠 技术架构

### 核心技术栈
- **Flutter 3.16.0+** - 跨平台UI框架
- **Dart 3.2.0+** - 编程语言
- **Riverpod** - 状态管理
- **Drift** - 本地数据库ORM
- **GoRouter** - 路由管理

### 项目结构
```
lib/
├── app/                          # 应用核心
│   ├── router/                   # 路由配置
│   └── theme/                    # 主题配置
├── core/                         # 核心功能
│   ├── database/                 # 数据库
│   └── services/                 # 服务层
├── features/                     # 功能模块
│   └── words/                    # 词汇功能
├── shared/                       # 共享组件
│   ├── models/                   # 数据模型
│   ├── providers/                # 状态提供者
│   └── widgets/                  # 通用组件
└── l10n/                         # 国际化
```

### 数据库设计
- **独立数据库**：每个数据源生成独立数据库文件
- **汇总数据库**：统一的数据访问入口
- **FTS5搜索**：高性能全文搜索支持
- **智能去重**：基于单词名的去重机制

## 📱 安装使用

### 环境要求
- Flutter SDK >= 3.16.0
- Dart SDK >= 3.2.0
- Android SDK / Xcode (根据目标平台)

### 快速开始

1. **克隆项目**
```bash
git clone https://github.com/fbfbfb66/CheckWords.git
cd CheckWords/APP
```

2. **安装依赖**
```bash
flutter pub get
```

3. **运行应用**
```bash
flutter run
```

4. **构建发布版本**
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## 📖 数据处理

### 支持的数据格式
应用支持标准的词汇JSON格式，包含以下字段：
```json
{
  "headWord": "单词",
  "bookId": "数据源ID",
  "wordRank": 排序,
  "content": {
    "word": {
      "content": {
        "usphone": "美式音标",
        "ukphone": "英式音标",
        "trans": [{"pos": "词性", "tranCn": "中文释义"}],
        "sentence": {"sentences": [{"sContent": "例句", "sCn": "中文翻译"}]},
        "phrase": {"phrases": [{"pContent": "短语", "pCn": "中文释义"}]},
        "syno": {"synos": [{"pos": "词性", "tran": "释义", "hwds": [{"w": "同义词"}]}]},
        "relWord": {"rels": [{"pos": "词性", "words": [{"hwd": "相关词", "tran": "释义"}]}]},
        "exam": [{"question": "考题", "choices": [{"choice": "选项"}]}]
      }
    }
  }
}
```

### 数据导入流程

1. **准备JSON数据**：将词汇数据文件放入 `assets/data/json/` 目录
2. **运行处理脚本**：
```bash
python process_word_data.py
```
3. **自动处理**：脚本会自动：
   - 生成独立数据库到 `assets/data/db/`
   - 创建汇总数据库 `assets/data/main.db`
   - 实现数据去重和合并

### 数据管理
- **独立数据库**：`assets/data/db/{bookId}.db`
- **汇总数据库**：`assets/data/main.db`
- **备份机制**：自动备份现有数据
- **增量更新**：支持新增数据源而不影响现有数据

## 🔧 开发指南

### 添加新功能
1. 在 `lib/features/` 下创建功能模块
2. 使用 Riverpod 进行状态管理
3. 遵循 Material Design 设计规范
4. 编写单元测试和集成测试

### 代码规范
- 遵循 Dart 官方代码规范
- 使用 `flutter_lints` 进行代码检查
- 组件化开发，提高代码复用性
- 完善的错误处理和用户反馈

### 本地化
- 支持中英文界面
- 使用 `l10n` 进行国际化管理
- 文本资源位于 `lib/l10n/` 目录

## 📊 项目状态

### 已完成功能
- ✅ 基础词汇浏览和搜索
- ✅ 完整的单词详情展示
- ✅ 收藏和学习管理
- ✅ 离线数据存储
- ✅ 多数据源支持
- ✅ 响应式UI设计
- ✅ 国际化支持

### 开发计划
- 🚀 学习计划和进度跟踪
- 🚀 单词测试和评估
- 🚀 社交分享功能
- 🚀 云同步支持
- 🚀 AI辅助学习

## 🤝 贡献指南

欢迎贡献代码！请遵循以下步骤：

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建 Pull Request

### 开发规范
- 遵循现有代码风格
- 添加适当的测试
- 更新相关文档
- 确保CI/CD通过

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 📞 联系方式

- 项目主页：https://github.com/fbfbfb66/CheckWords
- 问题反馈：https://github.com/fbfbfb66/CheckWords/issues
- 邮箱：[your-email@example.com]

## 🙏 致谢

感谢以下开源项目的支持：
- [Flutter](https://flutter.dev/) - 跨平台UI框架
- [Riverpod](https://riverpod.dev/) - 状态管理
- [Drift](https://drift.simonbinder.eu/) - 数据库ORM
- [GoRouter](https://pub.dev/packages/go_router) - 路由管理

---

**CheckWords** - 让词汇学习更高效、更智能！ 🎯
