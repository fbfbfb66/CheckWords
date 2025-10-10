# CheckWords APP 数据源替换需求文档

## 项目概述

本文档定义了 CheckWords 应用的数据源替换需求，目标是将现有的 AI 生成数据源完全替换为 kajweb/dict 项目的数据，并相应更新用户界面。

## 核心目标

1. **数据源替换**：完全替换当前 AI 生成的词汇数据为 kajweb/dict 项目数据
2. **UI 界面更新**：根据 kajweb/dict 项目的 JSON 数据格式要求更新用户界面
3. **分类存储与统一查询**：数据按分类单独存储，但提供统一的搜索查询体验

## 1. 数据源替换方案

### 1.1 当前数据结构
- 基于 GLM-4.6 AI 模型生成的复杂数据结构
- 包含对话、短语、例句等多层级内容
- 数据量有限（几千个词汇）

### 1.2 目标数据源特性
- **来源**：https://github.com/kajweb/dict
- **数据量**：60,000+ 词汇，400多本单词书
- **覆盖范围**：四级、六级、考研、雅思、托福、SAT、GMAT、TOEFL、GRE
- **格式**：标准化 JSON 格式

### 1.3 替换策略
- **完全替换**：删除当前所有 AI 生成的数据和相关代码
- **架构简化**：采用更标准的词典数据格式
- **向后兼容**：保持现有的用户数据和收藏功能

## 2. JSON 数据格式要求

### 2.1 标准 JSON 格式定义（基于 kajweb/dict 项目）

```json
{
  "wordRank": 1,
  "headWord": "cancel",
  "content": {
    "word": {
      "wordHead": "cancel",
      "wordId": "CET4_3_1",
      "content": {
        "exam": [
          {
            "question": "As we can no longer wait for the delivery of our order, we have to _______ it.",
            "answer": {
              "explain": " cancel order：  取消订单。 句意：  订购的货物尚未送到， 我们不能再等了， 不得不取消订单。 postpone：  推迟， 使延期； refuse：  拒绝， 谢绝； delay：  耽搁， 延迟， 延期。",
              "rightIndex": 4
            },
            "examType": 1,
            "choices": [
              {
                "choiceIndex": 1,
                "choice": "postpone"
              },
              {
                "choiceIndex": 2,
                "choice": "refuse"
              },
              {
                "choiceIndex": 3,
                "choice": "delay"
              },
              {
                "choiceIndex": 4,
                "choice": "cancel"
              }
            ]
          }
        ],
        "sentence": {
          "sentences": [
            {
              "sContent": "Our flight was cancelled.",
              "sCn": "我们的航班取消了。"
            },
            {
              "sContent": "I'm afraid I'll have to cancel our meeting tomorrow.",
              "sCn": "恐怕我得取消我们明天的会议。"
            }
          ],
          "desc": "例句"
        },
        "usphone": "'kænsl",
        "syno": {
          "synos": [
            {
              "pos": "vt",
              "tran": "[计]取消；删去",
              "hwds": [
                {
                  "w": "recall"
                },
                {
                  "w": "call it off"
                }
              ]
            }
          ],
          "desc": "同近"
        },
        "ukphone": "'kænsl",
        "ukspeech": "cancel&type=1",
        "phrase": {
          "phrases": [
            {
              "pContent": "cancel button",
              "pCn": "取消按钮"
            },
            {
              "pContent": "cancel out",
              "pCn": "取消；抵销"
            }
          ],
          "desc": "短语"
        },
        "relWord": {
          "rels": [
            {
              "pos": "n",
              "words": [
                {
                  "hwd": "cancellation",
                  "tran": " 取消；删除"
                }
              ]
            }
          ],
          "desc": "同根"
        },
        "usspeech": "cancel&type=2",
        "trans": [
          {
            "tranCn": " 取消， 撤销； 删去",
            "descOther": "英释",
            "pos": "vt",
            "descCn": "中释",
            "tranOther": "to decide that something that was officially planned will not happen"
          }
        ]
      }
    }
  },
  "bookId": "CET4_3"
}
```

### 2.2 字段说明

| 字段路径 | 类型 | 必需 | 说明 |
|----------|------|------|------|
| wordRank | Integer | ✅ | 单词序号 |
| headWord | String | ✅ | 单词（根单词） |
| content.word.wordHead | String | ✅ | 单词本身 |
| content.word.wordId | String | ✅ | 单词唯一标识符 |
| content.word.content.usphone | String | ❌ | 美音音标 |
| content.word.content.ukphone | String | ❌ | 英音音标 |
| content.word.content.usspeech | String | ❌ | 美音发音参数 |
| content.word.content.ukspeech | String | ❌ | 英音发音参数 |
| content.word.content.trans | Array | ✅ | 释义数组 |
| content.word.content.sentence.sentences | Array | ✅ | 例句数组 |
| content.word.content.phrase.phrases | Array | ❌ | 短语数组 |
| content.word.content.syno.synos | Array | ❌ | 同近义词数组 |
| content.word.content.relWord.rels | Array | ❌ | 同根词数组 |
| content.word.content.exam | Array | ❌ | 测试题目数组 |
| bookId | String | ✅ | 单词书ID（用于分类） |

### 2.3 重要子字段说明

#### 释义 (trans)
- tranCn: 中文释义
- pos: 词性
- tranOther: 英英释义

#### 例句 (sentence.sentences)
- sContent: 英文例句
- sCn: 中文翻译

#### 短语 (phrase.phrases)
- pContent: 英文短语
- pCn: 中文翻译

#### 同近义词 (syno.synos)
- pos: 词性
- tran: 释义
- hwds: 近义词数组

#### 测试题 (exam)
- question: 题目
- choices: 选项数组
- answer: 答案和解释

### 2.3 分类标准

- **CET4**: 四级词汇 (Level 3-4)
- **CET6**: 六级词汇 (Level 4-5)
- **KAUYAN**: 考研词汇 (Level 4-5)
- **IELTS**: 雅思词汇 (Level 5-6)
- **TOEFL**: 托福词汇 (Level 5-6)
- **GRE**: GRE 词汇 (Level 6)
- **BASIC**: 基础词汇 (Level 1-2)

## 3. 数据存储架构

### 3.1 文件存储结构

```
assets/data/
├── cet4.json          # 四级词汇
├── cet6.json          # 六级词汇
├── kaoyan.json        # 考研词汇
├── ielts.json         # 雅思词汇
├── toefl.json         # 托福词汇
├── gre.json           # GRE 词汇
├── basic.json         # 基础词汇
└── deployment_info.json # 部署信息文件
```

### 3.2 数据库架构更新

```dart
class WordsTable extends Table {
  @override
  String get tableName => 'words_table';

  /// 主键ID
  IntColumn get id => integer().autoIncrement()();

  /// 单词序号
  IntColumn get wordRank => integer()();

  /// 单词本身 (headWord)
  TextColumn get word => text().withLength(min: 1, max: 50)();

  /// 单词唯一标识符
  TextColumn get wordId => text().withLength(min: 1, max: 50)();

  /// 美音音标
  TextColumn get usphone => text().nullable()();

  /// 英音音标
  TextColumn get ukphone => text().nullable()();

  /// 美音发音参数
  TextColumn get usspeech => text().nullable()();

  /// 英音发音参数
  TextColumn get ukspeech => text().nullable()();

  /// 释义 (JSON数组格式，包含中英文释义和词性)
  TextColumn get trans => text().withDefault(const Constant('[]'))();

  /// 例句 (JSON数组格式)
  TextColumn get sentences => text().withDefault(const Constant('[]'))();

  /// 短语 (JSON数组格式)
  TextColumn get phrases => text().withDefault(const Constant('[]'))();

  /// 同近义词 (JSON数组格式)
  TextColumn get synonyms => text().withDefault(const Constant('[]'))();

  /// 同根词 (JSON数组格式)
  TextColumn get relWords => text().withDefault(const Constant('[]'))();

  /// 测试题 (JSON数组格式)
  TextColumn get exams => text().withDefault(const Constant('[]'))();

  /// 数据来源分类 (从bookId提取：CET4, CET6, KAUYAN, IELTS等)
  TextColumn get category => text()();

  /// 单词书ID
  TextColumn get bookId => text()();

  /// 全文搜索内容 (单词 + 释义 + 例句 + 短语)
  TextColumn get searchContent => text()();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// 更新时间
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {word},
    {wordId},
  ];
}
```

### 3.3 数据模型设计

```dart
@freezed
class WordModel with _$WordModel {
  const factory WordModel({
    required int id,
    required int wordRank,
    required String word,
    required String wordId,
    String? usphone,
    String? ukphone,
    String? usspeech,
    String? ukspeech,
    @Default([]) List<Translation> trans,
    @Default([]) List<Sentence> sentences,
    @Default([]) List<Phrase> phrases,
    @Default([]) List<Synonym> synonyms,
    @Default([]) List<RelWord> relWords,
    @Default([]) List<Exam> exams,
    required String category,
    required String bookId,
  }) = _WordModel;

  factory WordModel.fromJson(Map<String, dynamic> json) => _$WordModelFromJson(json);
}

@freezed
class Translation with _$Translation {
  const factory Translation({
    required String tranCn,
    required String pos,
    String? tranOther,
    String? descOther,
    String? descCn,
  }) = _Translation;
}

@freezed
class Sentence with _$Sentence {
  const factory Sentence({
    required String sContent,
    required String sCn,
  }) = _Sentence;
}

@freezed
class Phrase with _$Phrase {
  const factory Phrase({
    required String pContent,
    required String pCn,
  }) = _Phrase;
}

@freezed
class Synonym with _$Synonym {
  const factory Synonym({
    required String pos,
    required String tran,
    @Default([]) List<String> hwds,
  }) = _Synonym;
}

@freezed
class RelWord with _$RelWord {
  const factory RelWord({
    required String pos,
    @Default([]) List<WordItem> words,
  }) = _RelWord;
}

@freezed
class WordItem with _$WordItem {
  const factory WordItem({
    required String hwd,
    required String tran,
  }) = _WordItem;
}

@freezed
class Exam with _$Exam {
  const factory Exam({
    required String question,
    required List<Choice> choices,
    required ExamAnswer answer,
    required int examType,
  }) = _Exam;
}

@freezed
class Choice with _$Choice {
  const factory Choice({
    required int choiceIndex,
    required String choice,
  }) = _Choice;
}

@freezed
class ExamAnswer with _$ExamAnswer {
  const factory ExamAnswer({
    required String explain,
    required int rightIndex,
  }) = _ExamAnswer;
}
```

## 4. UI 界面更新要求

### 4.1 分类选择器

**位置**：主页面顶部，搜索栏下方
**功能**：允许用户按词汇分类筛选

```dart
class WordCategorySelector extends StatelessWidget {
  final List<String> categories = [
    '全部', 'CET4', 'CET6', '考研', '雅思', '托福', 'GRE', '基础'
  ];

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) =>
          FilterChip(
            label: Text(category),
            selected: selectedCategory == category,
            onSelected: (isSelected) => _selectCategory(category),
          )
        ).toList(),
      ),
    );
  }
}
```

### 4.2 单词列表界面更新

**显示内容**：
- 单词
- 音标
- 主要中文释义
- 分类标签
- 难度级别标识

### 4.3 单词详情页重新设计

**布局结构**：
```
┌─────────────────────────────────────────┐
│  cancel            [收藏] [美音] [英音]    │
│  /'kænsl/                                │
├─────────────────────────────────────────┤
│ CET4 • wordRank: 1                       │
├─────────────────────────────────────────┤
│ 词性释义                                │
│ vt. 取消， 撤销； 删去                   │
│   to decide that something was          │
│   officially planned will not happen     │
├─────────────────────────────────────────┤
│ 例句 (例句)                             │
│ • Our flight was cancelled.             │
│   我们的航班取消了。                     │
│ • I'm afraid I'll have to cancel...     │
│   恐怕我得取消我们明天的会议。           │
├─────────────────────────────────────────┤
│ 短语 (短语) [展开/收起]                  │
│ • cancel button - 取消按钮              │
│ • cancel out - 取消；抵销               │
├─────────────────────────────────────────┤
│ 同近义词 (同近) [展开/收起]              │
│ vt. [计]取消；删去: recall, call it off │
│ vi. [计]取消；相互抵销: call it off...   │
├─────────────────────────────────────────┤
│ 同根词 (同根) [展开/收起]                │
│ n. cancellation - 取消；删除            │
├─────────────────────────────────────────┤
│ [测试题] 开始测试                        │
└─────────────────────────────────────────┘
```

### 4.4 新增功能页面

#### 4.4.1 测试题页面
**功能**：显示选择题形式的词汇测试
**布局**：
- 题目显示区域
- 4个选项按钮
- 答案解释（选择后显示）
- 下一题/返回按钮

#### 4.4.2 短语详情页面
**功能**：展开显示所有短语内容
**布局**：列表形式展示英文短语和中文翻译

#### 4.4.3 同近义词页面
**功能**：展示同义词和近义词
**布局**：按词性分组显示

### 4.5 搜索界面优化

**搜索功能**：
- 支持英文单词搜索
- 支持中文释义搜索
- 支持分类筛选
- 实时搜索建议
- 搜索历史记录
- **新增**：支持短语搜索
- **新增**：支持同根词搜索

### 4.6 发音功能
**功能**：
- 美音发音（usspeech参数）
- 英音发音（ukspeech参数）
- 发音按钮支持点击播放
- 离线音频缓存（可选）

## 5. 数据导入和查询策略

### 5.1 数据导入流程

```dart
class DataImportService {
  /// 批量导入所有分类数据
  Future<void> importAllCategories() async {
    final categories = [
      {'file': 'cet4.json', 'category': 'CET4'},
      {'file': 'cet6.json', 'category': 'CET6'},
      {'file': 'kaoyan.json', 'category': 'KAUYAN'},
      {'file': 'ielts.json', 'category': 'IELTS'},
      {'file': 'toefl.json', 'category': 'TOEFL'},
      {'file': 'gre.json', 'category': 'GRE'},
      {'file': 'basic.json', 'category': 'BASIC'},
    ];

    for (final cat in categories) {
      await _importCategory(cat['file']!, cat['category']!, cat['level']!);
    }
  }

  Future<void> _importCategory(String fileName, String category, int level) async {
    try {
      // 1. 从 assets 读取 JSON 文件
      final String jsonString = await rootBundle.loadString('assets/data/$fileName');
      final List<dynamic> jsonData = json.decode(jsonString);

      // 2. 批量转换并插入数据库
      final List<WordModel> words = jsonData
          .map((item) => _convertToWordModel(item, category, level))
          .toList();

      await _batchInsertWords(words);

      print('Successfully imported ${words.length} words from $fileName');
    } catch (e) {
      print('Error importing $fileName: $e');
    }
  }
}
```

### 5.2 统一查询接口

```dart
class WordRepository {
  /// 根据条件搜索单词
  Future<List<WordModel>> searchWords({
    String? query,
    String? category,
    int? minLevel,
    int? maxLevel,
    int limit = 20,
    int offset = 0,
  }) async {
    final select = (database.select(database.wordsTable))
      ..where((tbl) {
        var conditions = [tbl.word.contains(query ?? '')];

        if (category != null && category != '全部') {
          conditions.add(tbl.category.equals(category));
        }

        if (minLevel != null) {
          conditions.add(tbl.level.isBiggerThanValue(minLevel - 1));
        }

        if (maxLevel != null) {
          conditions.add(tbl.level.isSmallerThanValue(maxLevel + 1));
        }

        return tbl.expression.buildAnd(conditions);
      })
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.frequency)])
      ..limit(limit, offset: offset);

    return await select.get();
  }
}
```

## 6. 实施计划

### 6.1 第一阶段：数据准备 (1-2周)
- [√] 克隆并分析 kajweb/dict 项目数据
- [√] 数据清洗和格式标准化
- [√] 按分类拆分 JSON 文件
- [√] 数据质量验证和测试

### 6.2 第二阶段：数据库迁移 (1-2周)
- [ ] 更新数据库架构定义
- [ ] 简化 WordModel 数据模型
- [ ] 编写数据导入和转换脚本
- [ ] 测试数据导入功能

### 6.3 第三阶段：UI 界面更新 (2-3周)
- [ ] 添加分类选择器组件
- [ ] 更新单词列表展示逻辑
- [ ] 重新设计单词详情页面
- [ ] 优化搜索和筛选功能
- [ ] 适配不同屏幕尺寸

### 6.4 第四阶段：集成测试 (1周)
- [ ] 功能完整性测试
- [ ] 性能测试和优化
- [ ] 用户体验测试
- [ ] 修复发现的问题

**总预计时间：5-8周**

## 7. 技术要求

### 7.1 依赖库更新
```yaml
dependencies:
  # 现有依赖保持不变

dev_dependencies:
  # 可能需要添加
  json_annotation: ^4.8.1
  json_serializable: ^6.7.1
```

### 7.2 代码生成
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 7.3 数据验证
- JSON 格式验证
- 数据完整性检查
- 重复数据检测
- 性能基准测试

## 8. 风险评估

### 8.1 技术风险
- **数据格式兼容性**：kajweb/dict 的数据格式可能与预期不符
- **性能问题**：大量数据可能影响搜索性能
- **应用包大小**：60,000+ 词汇可能显著增加应用大小

### 8.2 缓解措施
- **数据预处理**：编写数据验证和转换脚本
- **性能优化**：使用 FTS5 全文搜索，实现分页加载
- **按需加载**：初始只安装基础词汇，其他分类按需下载

## 9. 验收标准

### 9.1 功能验收
- [ ] 成功导入所有分类的词汇数据
- [ ] 分类选择器正常工作
- [ ] 搜索功能覆盖所有分类
- [ ] 单词详情页正确显示新格式数据
- [ ] 用户收藏功能正常工作

### 9.2 性能验收
- [ ] 应用启动时间不超过 3 秒
- [ ] 搜索响应时间不超过 500ms
- [ ] 应用包大小控制在合理范围内

### 9.3 用户体验验收
- [ ] 界面布局美观，符合 Material Design 规范
- [ ] 操作流程简单直观
- [ ] 数据展示清晰易读

---
注释（关键）
自己先写脚本按行读取预处理一遍。先把自己需要的内容写进数据库，再从数据库获取。
filename = "CET4luan_1.json";

import json;

file = open( filename,'r',encoding='utf-8' );
for line in file.readlines():
    words = line.strip();
    word_json = json.loads( words );
    print( word_json["headWord"] );
    
file.close()

部分字典混入了少量法语字母，可以使用以下代码对文本进行处理

def replaceFran(str):
    fr_en = [['é', 'e'], ['ê', 'e'], ['è', 'e'], ['ë', 'e'], ['à', 'a'], ['â', 'a'], ['ç', 'c'], ['î', 'i'], ['ï', 'i'],
             ['ô', 'o'], ['ù', 'u'], ['û', 'u'], ['ü', 'u'], ['ÿ', 'y']
             ]
    for i in fr_en:
        str = str.replace(i[0], i[1])
    return str
---
🎙 发音请求
有道英语发音接口

https://dict.youdao.com/dictvoice?audio={word}&type={1|2}
type 1 为英音 2 为美音

**文档版本**：1.0
**创建日期**：2025-10-10
**作者**：Claude Assistant
**最后更新**：2025-10-10