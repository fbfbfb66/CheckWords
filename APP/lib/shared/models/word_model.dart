import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../utils/app_logger.dart';

part 'word_model.freezed.dart';
part 'word_model.g.dart';

// ===== kajweb/dict 格式的数据模型 =====

/// 释义模型 (trans)
@freezed
class Trans with _$Trans {
  const factory Trans({
    required String tranCn,        // 中文释义
    String? descOther,            // 英释描述
    required String pos,           // 词性
    String? descCn,               // 中释描述
    String? tranOther,            // 英文释义
  }) = _Trans;

  factory Trans.fromJson(Map<String, dynamic> json) => _$TransFromJson(json);
}

/// 例句模型 (sentence)
@freezed
class KajSentence with _$KajSentence {
  const factory KajSentence({
    required String sContent,      // 英文例句
    required String sCn,          // 中文翻译
  }) = _KajSentence;

  factory KajSentence.fromJson(Map<String, dynamic> json) => _$KajSentenceFromJson(json);
}

/// 短语模型 (phrase)
@freezed
class KajPhrase with _$KajPhrase {
  const factory KajPhrase({
    required String pContent,      // 英文短语
    required String pCn,          // 中文释义
  }) = _KajPhrase;

  factory KajPhrase.fromJson(Map<String, dynamic> json) => _$KajPhraseFromJson(json);
}

/// 同近义词模型 (syno)
@freezed
class Syno with _$Syno {
  const factory Syno({
    required String pos,           // 词性
    required String tran,          // 释义
    @Default([]) List<Hwd> hwds,   // 同义词列表
  }) = _Syno;

  factory Syno.fromJson(Map<String, dynamic> json) => _$SynoFromJson(json);
}

/// 同义词词条
@freezed
class Hwd with _$Hwd {
  const factory Hwd({
    required String w,             // 同义词
  }) = _Hwd;

  factory Hwd.fromJson(Map<String, dynamic> json) => _$HwdFromJson(json);
}

/// 同根词模型 (relWord)
@freezed
class RelWord with _$RelWord {
  const factory RelWord({
    required String pos,           // 词性
    @Default([]) List<RelatedWord> words, // 相关词汇
  }) = _RelWord;

  factory RelWord.fromJson(Map<String, dynamic> json) => _$RelWordFromJson(json);
}

/// 相关词汇
@freezed
class RelatedWord with _$RelatedWord {
  const factory RelatedWord({
    required String hwd,           // 单词
    required String tran,          // 释义
  }) = _RelatedWord;

  factory RelatedWord.fromJson(Map<String, dynamic> json) => _$RelatedWordFromJson(json);
}

/// 考试题目模型 (exam)
@freezed
class Exam with _$Exam {
  const factory Exam({
    required String question,      // 题目
    required Answer answer,        // 答案
    required int examType,         // 题目类型
    @Default([]) List<Choice> choices, // 选项
  }) = _Exam;

  factory Exam.fromJson(Map<String, dynamic> json) => _$ExamFromJson(json);
}

/// 答案模型
@freezed
class Answer with _$Answer {
  const factory Answer({
    required String explain,       // 解释
    required int rightIndex,       // 正确答案索引
  }) = _Answer;

  factory Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);
}

/// 选项模型
@freezed
class Choice with _$Choice {
  const factory Choice({
    required int choiceIndex,      // 选项索引
    required String choice,        // 选项内容
  }) = _Choice;

  factory Choice.fromJson(Map<String, dynamic> json) => _$ChoiceFromJson(json);
}

/// 发音信息模型
@freezed
class PronunciationInfo with _$PronunciationInfo {
  const factory PronunciationInfo({
    String? usphone,              // 美式音标
    String? ukphone,              // 英式音标
    String? usspeech,             // 美式发音参数
    String? ukspeech,             // 英式发音参数
  }) = _PronunciationInfo;

  factory PronunciationInfo.fromJson(Map<String, dynamic> json) => _$PronunciationInfoFromJson(json);
}

/// 发音模型
@freezed
class Pronunciation with _$Pronunciation {
  const factory Pronunciation({
    String? ipa,
    String? audio,
  }) = _Pronunciation;

  factory Pronunciation.fromJson(Map<String, dynamic> json) => _$PronunciationFromJson(json);
}

/// 发音区域模型
@freezed
class PronunciationData with _$PronunciationData {
  const factory PronunciationData({
    required Pronunciation US,
    Pronunciation? UK,
  }) = _PronunciationData;

  factory PronunciationData.fromJson(Map<String, dynamic> json) => _$PronunciationDataFromJson(json);
}

/// 单词模型 (匹配kajweb/dict格式)
@freezed
class WordModel with _$WordModel {
  const factory WordModel({
    required int id,
    required String wordId,         // 单词唯一标识符
    required String bookId,         // 单词书ID
    required int wordRank,          // 单词序号
    required String headWord,       // 单词本身
    String? usphone,               // 美式音标
    String? ukphone,               // 英式音标
    String? usspeech,              // 美式发音参数
    String? ukspeech,              // 英式发音参数
    @Default([]) List<Trans> trans, // 释义列表
    @Default([]) List<KajSentence> sentences, // 例句列表
    @Default([]) List<KajPhrase> phrases, // 短语列表
    @Default([]) List<Syno> synonyms, // 同近义词列表
    @Default([]) List<RelWord> relWords, // 同根词列表
    @Default([]) List<Exam> exams, // 考试题目列表
  }) = _WordModel;

  factory WordModel.fromJson(Map<String, dynamic> json) => _$WordModelFromJson(json);

  /// 从数据库记录创建WordModel
  factory WordModel.fromDatabaseRecord(Map<String, dynamic> record) {
    try {
      // 安全获取基本字段
      final id = record['id'];
      final wordId = record['wordId'];
      final bookId = record['bookId'];
      final wordRank = record['wordRank'];
      final headWord = record['headWord'];

      // 验证必需字段
      if (id == null || wordId == null || bookId == null || headWord == null || headWord.toString().isEmpty) {
        throw ArgumentError('Missing required fields');
      }

      // 解析复杂字段
      final trans = _parseTrans(record['trans'] as String? ?? '[]');
      final sentences = _parseSentences(record['sentences'] as String? ?? '[]');
      final phrases = _parsePhrases(record['phrases'] as String? ?? '[]');
      final synonyms = _parseSynonyms(record['synonyms'] as String? ?? '[]');
      final relWords = _parseRelWords(record['relWords'] as String? ?? '[]');
      final exams = _parseExams(record['exams'] as String? ?? '[]');

      return WordModel(
        id: id is int ? id : int.tryParse(id.toString()) ?? 0,
        wordId: wordId.toString(),
        bookId: bookId.toString(),
        wordRank: wordRank is int ? wordRank : int.tryParse(wordRank.toString()) ?? 0,
        headWord: headWord.toString(),
        usphone: record['usphone'] as String?,
        ukphone: record['ukphone'] as String?,
        usspeech: record['usspeech'] as String?,
        ukspeech: record['ukspeech'] as String?,
        trans: trans,
        sentences: sentences,
        phrases: phrases,
        synonyms: synonyms,
        relWords: relWords,
        exams: exams,
      );

    } catch (e) {
      print('❌ WordModel创建失败: $e');
      // 创建一个最基本的WordModel作为fallback
      return WordModel(
        id: (record['id'] is int ? record['id'] as int :
             int.tryParse(record['id']?.toString() ?? '0') ?? 0),
        wordId: record['wordId']?.toString() ?? 'unknown',
        bookId: record['bookId']?.toString() ?? 'unknown',
        wordRank: (record['wordRank'] is int ? record['wordRank'] as int :
                  int.tryParse(record['wordRank']?.toString() ?? '0') ?? 0),
        headWord: record['headWord']?.toString() ?? '未知单词',
        usphone: record['usphone'] as String?,
        ukphone: record['ukphone'] as String?,
        usspeech: record['usspeech'] as String?,
        ukspeech: record['ukspeech'] as String?,
        trans: [],
        sentences: [],
        phrases: [],
        synonyms: [],
        relWords: [],
        exams: [],
      );
    }
  }

  
  /// 解析释义列表
  static List<Trans> _parseTrans(String jsonString) {
    try {
      final List<dynamic> list = json.decode(jsonString);
      final result = list.map((item) {
        try {
          final trans = Trans.fromJson(item);
          return trans;
        } catch (e) {
          print('❌ 解析单个释义失败: $e');
          // 创建一个默认的Trans对象
          return Trans(
            tranCn: item['tranCn']?.toString() ?? '释义解析失败',
            pos: item['pos']?.toString() ?? 'n',
            descOther: item['descOther']?.toString(),
            descCn: item['descCn']?.toString(),
            tranOther: item['tranOther']?.toString(),
          );
        }
      }).toList();

      return result;
    } catch (e) {
      print('❌ 解析释义列表失败: $e');
      return [];
    }
  }

  /// 解析例句列表
  static List<KajSentence> _parseSentences(String jsonString) {
    try {
      final List<dynamic> list = json.decode(jsonString);
      final result = list.map((item) {
        try {
          final sentence = KajSentence.fromJson(item);
          return sentence;
        } catch (e) {
          print('❌ 解析例句失败: $e');
          return KajSentence(
            sContent: item['sContent']?.toString() ?? '例句解析失败',
            sCn: item['sCn']?.toString() ?? '例句翻译解析失败',
          );
        }
      }).toList();

      return result;
    } catch (e) {
      print('❌ 解析例句列表失败: $e');
      return [];
    }
  }

  /// 解析短语列表
  static List<KajPhrase> _parsePhrases(String jsonString) {
    try {
      print('🔍 解析短语数据: ${jsonString.length > 100 ? jsonString.substring(0, 100) + '...' : jsonString}');
      final List<dynamic> list = json.decode(jsonString);
      print('🔍 短语列表长度: ${list.length}');

      final result = list.map((item) {
        try {
          final phrase = KajPhrase.fromJson(item);
          print('✅ 解析短语成功: ${phrase.pCn}');
          return phrase;
        } catch (e) {
          print('❌ 解析单个短语失败: $e');
          print('   问题数据: $item');
          // 创建一个默认的KajPhrase对象
          return KajPhrase(
            pContent: item['pContent']?.toString() ?? '短语解析失败',
            pCn: item['pCn']?.toString() ?? '短语释义解析失败',
          );
        }
      }).toList();

      print('✅ 短语解析完成，成功解析 ${result.length} 条');
      return result;
    } catch (e) {
      print('❌ 解析短语列表完全失败: $e');
      print('   原始数据: $jsonString');
      return [];
    }
  }

  /// 解析同近义词列表
  static List<Syno> _parseSynonyms(String jsonString) {
    try {
      print('🔍 解析同近义词数据: ${jsonString.length > 100 ? jsonString.substring(0, 100) + '...' : jsonString}');
      final List<dynamic> list = json.decode(jsonString);
      print('🔍 同近义词列表长度: ${list.length}');

      final result = list.map((item) {
        try {
          final syno = Syno.fromJson(item);
          print('✅ 解析同近义词成功: ${syno.tran}');
          return syno;
        } catch (e) {
          print('❌ 解析单个同近义词失败: $e');
          print('   问题数据: $item');
          // 创建一个默认的Syno对象
          return Syno(
            pos: item['pos']?.toString() ?? 'n',
            tran: item['tran']?.toString() ?? '同近义词解析失败',
            hwds: [], // 使用空列表而不是字符串
          );
        }
      }).toList();

      print('✅ 同近义词解析完成，成功解析 ${result.length} 条');
      return result;
    } catch (e) {
      print('❌ 解析同近义词列表完全失败: $e');
      print('   原始数据: $jsonString');
      return [];
    }
  }

  /// 解析同根词列表
  static List<RelWord> _parseRelWords(String jsonString) {
    try {
      print('🔍 解析同根词数据: ${jsonString.length > 100 ? jsonString.substring(0, 100) + '...' : jsonString}');
      final List<dynamic> list = json.decode(jsonString);
      print('🔍 同根词列表长度: ${list.length}');

      final result = list.map((item) {
        try {
          final relWord = RelWord.fromJson(item);
          print('✅ 解析同根词成功');
          return relWord;
        } catch (e) {
          print('❌ 解析单个同根词失败: $e');
          print('   问题数据: $item');
          // 创建一个默认的RelWord对象
          return RelWord(
            pos: item['pos']?.toString() ?? 'n',
            words: [], // 使用空列表而不是不存在的字段
          );
        }
      }).toList();

      print('✅ 同根词解析完成，成功解析 ${result.length} 条');
      return result;
    } catch (e) {
      print('❌ 解析同根词列表完全失败: $e');
      print('   原始数据: $jsonString');
      return [];
    }
  }

  /// 解析考试题目列表
  static List<Exam> _parseExams(String jsonString) {
    try {
      print('🔍 解析考试题目数据: ${jsonString.length > 100 ? jsonString.substring(0, 100) + '...' : jsonString}');
      final List<dynamic> list = json.decode(jsonString);
      print('🔍 考试题目列表长度: ${list.length}');

      final result = list.map((item) {
        try {
          final exam = Exam.fromJson(item);
          print('✅ 解析考试题目成功');
          return exam;
        } catch (e) {
          print('❌ 解析单个考试题目失败: $e');
          print('   问题数据: $item');
          // 创建一个默认的Exam对象
          return Exam(
            question: item['question']?.toString() ?? '考试题目解析失败',
            answer: const Answer(explain: '', rightIndex: 0), // 创建默认的Answer对象
            examType: item['examType'] is int ? item['examType'] as int :
                     int.tryParse(item['examType']?.toString() ?? '0') ?? 0,
            choices: [], // 使用空列表
          );
        }
      }).toList();

      print('✅ 考试题目解析完成，成功解析 ${result.length} 条');
      return result;
    } catch (e) {
      print('❌ 解析考试题目列表完全失败: $e');
      print('   原始数据: $jsonString');
      return [];
    }
  }
}

/// WordModel 扩展方法
extension WordModelExtensions on WordModel {
  /// 获取主要释义
  String get primaryMeaning {
    if (trans.isEmpty) return '';
    return trans.first.tranCn;
  }

  /// 获取美式音标
  String? get usPhone => usphone;

  /// 获取英式音标
  String? get ukPhone => ukphone;

  /// 获取第一个例句
  String? get firstSentence {
    if (sentences.isEmpty) return null;
    return sentences.first.sContent;
  }

  /// 获取词性列表
  List<String> get partsOfSpeech {
    return trans.map((t) => t.pos).toList();
  }

  /// 获取中文释义列表
  List<String> get chineseMeanings {
    return trans.map((t) => t.tranCn).toList();
  }

  /// 检查是否有短语
  bool get hasPhrases => phrases.isNotEmpty;

  /// 检查是否有同近义词
  bool get hasSynonyms => synonyms.isNotEmpty;

  /// 检查是否有同根词
  bool get hasRelWords => relWords.isNotEmpty;

  /// 检查是否有考试题目
  bool get hasExams => exams.isNotEmpty;
}
