import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'word_model.freezed.dart';
part 'word_model.g.dart';

/// 词性含义模型
@freezed
class PosMeaning with _$PosMeaning {
  const factory PosMeaning({
    required String pos,
    required String cn,
  }) = _PosMeaning;

  factory PosMeaning.fromJson(Map<String, dynamic> json) => _$PosMeaningFromJson(json);
}

/// 对话模型
@freezed
class Dialog with _$Dialog {
  const factory Dialog({
    required String A,
    required String B,
  }) = _Dialog;

  factory Dialog.fromJson(Map<String, dynamic> json) => _$DialogFromJson(json);
}

/// 短语模型
@freezed
class Phrase with _$Phrase {
  const factory Phrase({
    required String phrase,
    required Dialog dialog,
  }) = _Phrase;

  factory Phrase.fromJson(Map<String, dynamic> json) => _$PhraseFromJson(json);
}

/// 例句模型
@freezed
class Sentence with _$Sentence {
  const factory Sentence({
    required String en,
    required String cn,
  }) = _Sentence;

  factory Sentence.fromJson(Map<String, dynamic> json) => _$SentenceFromJson(json);
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

/// 单词模型
@freezed
class WordModel with _$WordModel {
  const factory WordModel({
    required int id,
    required String word,
    String? lemma,
    required List<String> partsOfSpeech,
    required List<PosMeaning> posMeanings,
    required List<Phrase> phrases,
    required List<Sentence> sentences,
    required PronunciationData pronunciation,
    String? level,
    @Default(0) int frequency,
    @Default([]) List<String> tags,
    @Default([]) List<String> synonyms,
    @Default([]) List<String> antonyms,
  }) = _WordModel;

  factory WordModel.fromJson(Map<String, dynamic> json) => _$WordModelFromJson(json);

  /// 从数据库记录创建WordModel
  factory WordModel.fromDatabaseRecord(Map<String, dynamic> record) {
    return WordModel(
      id: record['id'] as int,
      word: record['word'] as String,
      lemma: record['lemma'] as String?,
      partsOfSpeech: _parseStringList(record['parts_of_speech'] as String? ?? '[]'),
      posMeanings: _parsePosMeanings(record['pos_meanings'] as String? ?? '[]'),
      phrases: _parsePhrases(record['phrases'] as String? ?? '[]'),
      sentences: _parseSentences(record['sentences'] as String? ?? '[]'),
      pronunciation: _parsePronunciation(record['pronunciation'] as String? ?? '{}'),
      level: record['level'] as String?,
      frequency: record['frequency'] as int? ?? 0,
      tags: _parseStringList(record['tags'] as String? ?? '[]'),
      synonyms: _parseStringList(record['synonyms'] as String? ?? '[]'),
      antonyms: _parseStringList(record['antonyms'] as String? ?? '[]'),
    );
  }

  /// 解析字符串列表
  static List<String> _parseStringList(String jsonString) {
    try {
      final List<dynamic> list = json.decode(jsonString);
      return list.cast<String>();
    } catch (e) {
      return [];
    }
  }

  /// 解析词性含义列表
  static List<PosMeaning> _parsePosMeanings(String jsonString) {
    try {
      final List<dynamic> list = json.decode(jsonString);
      return list.map((item) => PosMeaning.fromJson(item)).toList();
    } catch (e) {
      return [];
    }
  }

  /// 解析短语列表
  static List<Phrase> _parsePhrases(String jsonString) {
    try {
      final List<dynamic> list = json.decode(jsonString);
      return list.map((item) => Phrase.fromJson(item)).toList();
    } catch (e) {
      return [];
    }
  }

  /// 解析例句列表
  static List<Sentence> _parseSentences(String jsonString) {
    try {
      final List<dynamic> list = json.decode(jsonString);
      return list.map((item) => Sentence.fromJson(item)).toList();
    } catch (e) {
      return [];
    }
  }

  /// 解析发音数据
  static PronunciationData _parsePronunciation(String jsonString) {
    try {
      final Map<String, dynamic> data = json.decode(jsonString);
      return PronunciationData.fromJson(data);
    } catch (e) {
      return const PronunciationData(
        US: Pronunciation(ipa: null, audio: null),
      );
    }
  }
}

/// WordModel 扩展方法
extension WordModelExtensions on WordModel {
  /// 获取主要词性含义
  String get primaryMeaning {
    if (posMeanings.isNotEmpty) {
      return posMeanings.first.cn;
    }
    return '';
  }

  /// 获取美式音标
  String? get usIpa {
    return pronunciation.US.ipa;
  }

  /// 是否有音频
  bool get hasAudio {
    return pronunciation.US.audio != null && pronunciation.US.audio!.isNotEmpty;
  }

  /// 获取第一个例句
  String? get firstSentence {
    if (sentences.isNotEmpty) {
      return sentences.first.en;
    }
    return null;
  }

  /// 检查是否有短语和对话
  bool get hasPhrases {
    return phrases.isNotEmpty;
  }

  /// 获取用于显示的内容（如果没有短语，则使用例句）
  List<dynamic> get displayContent {
    if (hasPhrases) {
      return phrases;
    } else {
      // 如果没有短语，返回例句作为显示内容
      return sentences;
    }
  }
}