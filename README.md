# CheckWords

CheckWords 是一款面向中文学习者的多端词汇学习应用，支持单词检索、离线数据浏览、收藏管理与个性化主题等功能。项目基于 Flutter 构建，目前聚焦 Android 与 iOS 端的体验。

## 功能特点
- 邮箱登录、注册与重置密码流程，结合 Riverpod 状态管理保障认证状态一致性
- 词汇主页支持关键词搜索、历史记录管理与 SQLite 本地离线词库加载
- Drift 数据层提供增删改查接口，并含批量导入脚本与资源初始化能力
- 单词详情页支持收藏与取消收藏，登录拦截提示与 SnackBar 反馈
- 展示音标、短语对话、双语例句等多维度学习内容
- 提供亮色 / 暗色主题与字体切换，配合自定义设计规范

## 技术栈
- Flutter 3.16+ / Dart 3.2+
- Riverpod 与 riverpod_generator 管理全局状态
- Drift 与 sqlite3_flutter_libs 构建本地数据库
- go_router 实现声明式路由导航
- SharedPreferences 保留搜索历史与轻量设置
- freezed / json_serializable 负责不可变数据模型

## 环境要求
- Flutter SDK >= 3.16.0（stable 通道）
- Dart SDK >= 3.2.0
- Android Studio 或 VS Code（可选）
- Xcode 15+（如需在 iOS 上调试）

## 快速开始
1. 安装 Flutter 并通过 `flutter doctor` 确认环境无误。
2. 克隆或下载本仓库后，进入应用目录：`cd APP`。
3. 安装依赖：`flutter pub get`。
4. 首次运行前执行代码生成（详见下节），确保 `.g.dart` 与 `.freezed.dart` 文件已更新。
5. 运行应用：`flutter run`（可指定 `-d` 目标设备）。

## 代码生成与本地数据
- 运行所有代码生成器：`dart run build_runner build --delete-conflicting-outputs`
- 持续监听生成：`dart run build_runner watch`
- 默认词库位于 `assets/data/words.db`，`DataImportService` 支持从 JSON 种子数据初始化数据库（详见 `lib/core/services/data_import_service.dart`）。
- 项目同级目录提供 `Resource*` 及 `merge_resources.py` 脚本，用于同步词库资源。

## 项目结构概览
```
CheckWords/
├── APP/                # Flutter 应用主体
│   ├── lib/            # 路由、主题、数据库、功能域等源码
│   ├── assets/         # 词库数据库与静态资源
│   ├── android/ ios/   # 平台工程
│   └── test/           # 测试用例
├── Resource*/          # 原始 JSON/词库资源（用于批处理脚本）
├── merge_resources.py  # 资源合并脚本
├── stats.py / validate_words.py
└── README.md / key.md / Prompt.txt 等文档
```

## 测试与质量保障
- 单元与 Widget 测试：`flutter test`
- 静态分析：`flutter analyze`
- Widgetbook 预览：`flutter run -d chrome --dart-define=widgetbook=true`

## 参考文档
- `Requests.md`：功能清单与交互细节
- `Fault.md`：已知问题与排查记录
- `start.md`：环境搭建备忘

## 许可证
本项目尚未指定开源许可证，若需开源发布请先补充 LICENSE 并确认权限。
