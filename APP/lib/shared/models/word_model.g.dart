// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PosMeaningImpl _$$PosMeaningImplFromJson(Map<String, dynamic> json) =>
    _$PosMeaningImpl(
      pos: json['pos'] as String,
      cn: json['cn'] as String,
    );

Map<String, dynamic> _$$PosMeaningImplToJson(_$PosMeaningImpl instance) =>
    <String, dynamic>{
      'pos': instance.pos,
      'cn': instance.cn,
    };

_$DialogImpl _$$DialogImplFromJson(Map<String, dynamic> json) => _$DialogImpl(
      A: json['A'] as String,
      B: json['B'] as String,
    );

Map<String, dynamic> _$$DialogImplToJson(_$DialogImpl instance) =>
    <String, dynamic>{
      'A': instance.A,
      'B': instance.B,
    };

_$PhraseImpl _$$PhraseImplFromJson(Map<String, dynamic> json) => _$PhraseImpl(
      phrase: json['phrase'] as String,
      dialog: Dialog.fromJson(json['dialog'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PhraseImplToJson(_$PhraseImpl instance) =>
    <String, dynamic>{
      'phrase': instance.phrase,
      'dialog': instance.dialog,
    };

_$SentenceImpl _$$SentenceImplFromJson(Map<String, dynamic> json) =>
    _$SentenceImpl(
      en: json['en'] as String,
      cn: json['cn'] as String,
    );

Map<String, dynamic> _$$SentenceImplToJson(_$SentenceImpl instance) =>
    <String, dynamic>{
      'en': instance.en,
      'cn': instance.cn,
    };

_$PronunciationImpl _$$PronunciationImplFromJson(Map<String, dynamic> json) =>
    _$PronunciationImpl(
      ipa: json['ipa'] as String?,
      audio: json['audio'] as String?,
    );

Map<String, dynamic> _$$PronunciationImplToJson(_$PronunciationImpl instance) =>
    <String, dynamic>{
      'ipa': instance.ipa,
      'audio': instance.audio,
    };

_$PronunciationDataImpl _$$PronunciationDataImplFromJson(
        Map<String, dynamic> json) =>
    _$PronunciationDataImpl(
      US: Pronunciation.fromJson(json['US'] as Map<String, dynamic>),
      UK: json['UK'] == null
          ? null
          : Pronunciation.fromJson(json['UK'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PronunciationDataImplToJson(
        _$PronunciationDataImpl instance) =>
    <String, dynamic>{
      'US': instance.US,
      'UK': instance.UK,
    };

_$WordModelImpl _$$WordModelImplFromJson(Map<String, dynamic> json) =>
    _$WordModelImpl(
      id: (json['id'] as num).toInt(),
      word: json['word'] as String,
      lemma: json['lemma'] as String?,
      partsOfSpeech: (json['partsOfSpeech'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      posMeanings: (json['posMeanings'] as List<dynamic>)
          .map((e) => PosMeaning.fromJson(e as Map<String, dynamic>))
          .toList(),
      phrases: (json['phrases'] as List<dynamic>)
          .map((e) => Phrase.fromJson(e as Map<String, dynamic>))
          .toList(),
      sentences: (json['sentences'] as List<dynamic>)
          .map((e) => Sentence.fromJson(e as Map<String, dynamic>))
          .toList(),
      pronunciation: PronunciationData.fromJson(
          json['pronunciation'] as Map<String, dynamic>),
      level: json['level'] as String?,
      frequency: (json['frequency'] as num?)?.toInt() ?? 0,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      synonyms: (json['synonyms'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      antonyms: (json['antonyms'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$WordModelImplToJson(_$WordModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'word': instance.word,
      'lemma': instance.lemma,
      'partsOfSpeech': instance.partsOfSpeech,
      'posMeanings': instance.posMeanings,
      'phrases': instance.phrases,
      'sentences': instance.sentences,
      'pronunciation': instance.pronunciation,
      'level': instance.level,
      'frequency': instance.frequency,
      'tags': instance.tags,
      'synonyms': instance.synonyms,
      'antonyms': instance.antonyms,
    };
