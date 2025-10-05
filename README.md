# CheckWords

CheckWords 是一套面向英语词汇学习的完整工作流：上游通过 Python 脚本批量生成、验证并整理词汇数据，下游由 Flutter 应用离线展示和练习。仓库收录了数据生产流水线、质量控制脚本以及移动端客户端。

## 功能亮点
- 自动化词汇生成：`Resource/pipeline.py` 基于词频列表批量调用 LLM，自动补齐词性释义、短语与发音占位。
- 多阶段质量校验：`validate_words.py` 支持 JSON Schema 检查、语料质量审查、覆盖率评估，并可一键合并到主词库。
- 资源整合与回溯：`merge_resources.py`、`stats.py`、`word_stats.py` 等脚本帮助在多套资源目录之间去重、统计和回溯历史数据。
- Flutter 客户端：`APP/` 目录包含 Riverpod + Drift 实现的离线学习 App，启动时自动导入词库 SQLite。

## 目录总览
```
.
|-- APP/                 Flutter 客户端工程
|-- Resource/            主词库与自动化脚本
|-- Resource2~4/         并行跑批使用的备份资源目录
|-- merge_resources.py   多资源合并脚本
|-- validate_words.py    临时结果校验与入库脚本
|-- stats.py             全局词库统计脚本
|-- Prompt.txt           LLM 生成规范
|-- key.md               API Key 记录（建议本地保存，勿提交）
```

## 运行 Python 词库流水线
1. 准备环境（推荐 Python 3.10+）：
   ```bash
   python -m venv .venv
   .venv\Scripts\activate  # Windows
   pip install requests tqdm wordfreq cmudict jsonschema opencc-python-reimplemented
   ```
2. 拉取指定区间的词并生产数据：
   ```bash
   python Resource/pipeline.py
   ```
3. 使用临时文件进行校验（默认读取根目录 `temp_words.json`）：
   ```bash
   python validate_words.py temp_words.json --failed Resource/failed_permanent.json
   ```
   验证通过后可选择自动合并至 `Resource/words.json` 并清理失败记录。
4. 合并不同资源目录的数据：
   ```bash
   python merge_resources.py
   ```
5. 将最新词库部署到 App：
   ```bash
   python Resource/deploy_to_app.py
   ```
   脚本会同步生成 `APP/assets/data/words.db` 与 `words_seed.json` 供客户端导入。

## 运行 Flutter 客户端
1. 安装 Flutter 3.16+，并确保 `flutter doctor` 通过。
2. 进入 `APP/` 目录安装依赖：
   ```bash
   cd APP
   flutter pub get
   ```
3. 启动应用（示例）：
   ```bash
   flutter run -d chrome      # Web
   flutter run -d windows     # Windows 桌面
   flutter run -d emulator-id # 移动设备
   ```
   首次启动会自动导入 `assets/data/` 下的词库数据库。

## 数据与配置
- API Key：仓库中的 `key.md` 仅用于本地记录，推送到远端前请将该文件加入 `.gitignore` 或改用环境变量注入。
- Pipeline 脚本中的 `DEEPSEEK_API_KEY`、`GLM_API_KEY` 等占位值建议改为从环境变量或单独的配置文件读取，以防泄露敏感信息。
- 词库体积较大（`Resource/words.json` 与 `words.db`），提交时可以视情况拆分为 Git LFS 或发布二进制资产。

## 常用脚本速览
- `stats.py`：汇总各资源目录的词汇量、文件大小与更新时间。
- `Resource/json_to_sqlite.py`：将 `words.json` 导出为 SQLite，便于外部系统使用。
- `Resource/retry_permanent.py`：针对 `failed_permanent.json` 中的词执行补救重试。
- `Resource/auto_whitelist.py`：自动维护功能词白名单，降低误判。

## 后续建议
- 将凭证读取逻辑统一改为环境变量或 `.env` 文件，并确保 `.gitignore` 忽略相关配置。
- 为 Python 部分补充 `requirements.txt` 与单元测试，提升易用性与可维护性。
- 将 `APP/` 中的构建产物（`build/`、`.dart_tool/` 等）保持忽略状态，避免无关文件进入仓库。
