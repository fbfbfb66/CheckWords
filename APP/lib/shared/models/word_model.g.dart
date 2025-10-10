// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransImpl _$$TransImplFromJson(Map<String, dynamic> json) => _$TransImpl(
      tranCn: json['tranCn'] as String,
      descOther: json['descOther'] as String?,
      pos: json['pos'] as String,
      descCn: json['descCn'] as String?,
      tranOther: json['tranOther'] as String?,
    );

Map<String, dynamic> _$$TransImplToJson(_$TransImpl instance) =>
    <String, dynamic>{
      'tranCn': instance.tranCn,
      'descOther': instance.descOther,
      'pos': instance.pos,
      'descCn': instance.descCn,
      'tranOther': instance.tranOther,
    };

_$KajSentenceImpl _$$KajSentenceImplFromJson(Map<String, dynamic> json) =>
    _$KajSentenceImpl(
      sContent: json['sContent'] as String,
      sCn: json['sCn'] as String,
    );

Map<String, dynamic> _$$KajSentenceImplToJson(_$KajSentenceImpl instance) =>
    <String, dynamic>{
      'sContent': instance.sContent,
      'sCn': instance.sCn,
    };

_$KajPhraseImpl _$$KajPhraseImplFromJson(Map<String, dynamic> json) =>
    _$KajPhraseImpl(
      pContent: json['pContent'] as String,
      pCn: json['pCn'] as String,
    );

Map<String, dynamic> _$$KajPhraseImplToJson(_$KajPhraseImpl instance) =>
    <String, dynamic>{
      'pContent': instance.pContent,
      'pCn': instance.pCn,
    };

_$SynoImpl _$$SynoImplFromJson(Map<String, dynamic> json) => _$SynoImpl(
      pos: json['pos'] as String,
      tran: json['tran'] as String,
      hwds: (json['hwds'] as List<dynamic>?)
              ?.map((e) => Hwd.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$SynoImplToJson(_$SynoImpl instance) =>
    <String, dynamic>{
      'pos': instance.pos,
      'tran': instance.tran,
      'hwds': instance.hwds,
    };

_$HwdImpl _$$HwdImplFromJson(Map<String, dynamic> json) => _$HwdImpl(
      w: json['w'] as String,
    );

Map<String, dynamic> _$$HwdImplToJson(_$HwdImpl instance) => <String, dynamic>{
      'w': instance.w,
    };

_$RelWordImpl _$$RelWordImplFromJson(Map<String, dynamic> json) =>
    _$RelWordImpl(
      pos: json['pos'] as String,
      words: (json['words'] as List<dynamic>?)
              ?.map((e) => RelatedWord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$RelWordImplToJson(_$RelWordImpl instance) =>
    <String, dynamic>{
      'pos': instance.pos,
      'words': instance.words,
    };

_$RelatedWordImpl _$$RelatedWordImplFromJson(Map<String, dynamic> json) =>
    _$RelatedWordImpl(
      hwd: json['hwd'] as String,
      tran: json['tran'] as String,
    );

Map<String, dynamic> _$$RelatedWordImplToJson(_$RelatedWordImpl instance) =>
    <String, dynamic>{
      'hwd': instance.hwd,
      'tran': instance.tran,
    };

_$ExamImpl _$$ExamImplFromJson(Map<String, dynamic> json) => _$ExamImpl(
      question: json['question'] as String,
      answer: Answer.fromJson(json['answer'] as Map<String, dynamic>),
      examType: (json['examType'] as num).toInt(),
      choices: (json['choices'] as List<dynamic>?)
              ?.map((e) => Choice.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ExamImplToJson(_$ExamImpl instance) =>
    <String, dynamic>{
      'question': instance.question,
      'answer': instance.answer,
      'examType': instance.examType,
      'choices': instance.choices,
    };

_$AnswerImpl _$$AnswerImplFromJson(Map<String, dynamic> json) => _$AnswerImpl(
      explain: json['explain'] as String,
      rightIndex: (json['rightIndex'] as num).toInt(),
    );

Map<String, dynamic> _$$AnswerImplToJson(_$AnswerImpl instance) =>
    <String, dynamic>{
      'explain': instance.explain,
      'rightIndex': instance.rightIndex,
    };

_$ChoiceImpl _$$ChoiceImplFromJson(Map<String, dynamic> json) => _$ChoiceImpl(
      choiceIndex: (json['choiceIndex'] as num).toInt(),
      choice: json['choice'] as String,
    );

Map<String, dynamic> _$$ChoiceImplToJson(_$ChoiceImpl instance) =>
    <String, dynamic>{
      'choiceIndex': instance.choiceIndex,
      'choice': instance.choice,
    };

_$PronunciationInfoImpl _$$PronunciationInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$PronunciationInfoImpl(
      usphone: json['usphone'] as String?,
      ukphone: json['ukphone'] as String?,
      usspeech: json['usspeech'] as String?,
      ukspeech: json['ukspeech'] as String?,
    );

Map<String, dynamic> _$$PronunciationInfoImplToJson(
        _$PronunciationInfoImpl instance) =>
    <String, dynamic>{
      'usphone': instance.usphone,
      'ukphone': instance.ukphone,
      'usspeech': instance.usspeech,
      'ukspeech': instance.ukspeech,
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
      wordId: json['wordId'] as String,
      bookId: json['bookId'] as String,
      wordRank: (json['wordRank'] as num).toInt(),
      headWord: json['headWord'] as String,
      usphone: json['usphone'] as String?,
      ukphone: json['ukphone'] as String?,
      usspeech: json['usspeech'] as String?,
      ukspeech: json['ukspeech'] as String?,
      trans: (json['trans'] as List<dynamic>?)
              ?.map((e) => Trans.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      sentences: (json['sentences'] as List<dynamic>?)
              ?.map((e) => KajSentence.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      phrases: (json['phrases'] as List<dynamic>?)
              ?.map((e) => KajPhrase.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      synonyms: (json['synonyms'] as List<dynamic>?)
              ?.map((e) => Syno.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      relWords: (json['relWords'] as List<dynamic>?)
              ?.map((e) => RelWord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      exams: (json['exams'] as List<dynamic>?)
              ?.map((e) => Exam.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$WordModelImplToJson(_$WordModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'wordId': instance.wordId,
      'bookId': instance.bookId,
      'wordRank': instance.wordRank,
      'headWord': instance.headWord,
      'usphone': instance.usphone,
      'ukphone': instance.ukphone,
      'usspeech': instance.usspeech,
      'ukspeech': instance.ukspeech,
      'trans': instance.trans,
      'sentences': instance.sentences,
      'phrases': instance.phrases,
      'synonyms': instance.synonyms,
      'relWords': instance.relWords,
      'exams': instance.exams,
    };
