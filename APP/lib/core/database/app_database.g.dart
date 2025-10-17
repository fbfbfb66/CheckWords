// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WordsTableTable extends WordsTable
    with TableInfo<$WordsTableTable, WordsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WordsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<String> wordId = GeneratedColumn<String>(
      'word_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
      'book_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _wordRankMeta =
      const VerificationMeta('wordRank');
  @override
  late final GeneratedColumn<int> wordRank = GeneratedColumn<int>(
      'word_rank', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _headWordMeta =
      const VerificationMeta('headWord');
  @override
  late final GeneratedColumn<String> headWord = GeneratedColumn<String>(
      'head_word', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _usphoneMeta =
      const VerificationMeta('usphone');
  @override
  late final GeneratedColumn<String> usphone = GeneratedColumn<String>(
      'usphone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ukphoneMeta =
      const VerificationMeta('ukphone');
  @override
  late final GeneratedColumn<String> ukphone = GeneratedColumn<String>(
      'ukphone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _usspeechMeta =
      const VerificationMeta('usspeech');
  @override
  late final GeneratedColumn<String> usspeech = GeneratedColumn<String>(
      'usspeech', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ukspeechMeta =
      const VerificationMeta('ukspeech');
  @override
  late final GeneratedColumn<String> ukspeech = GeneratedColumn<String>(
      'ukspeech', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _transMeta = const VerificationMeta('trans');
  @override
  late final GeneratedColumn<String> trans = GeneratedColumn<String>(
      'trans', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _sentencesMeta =
      const VerificationMeta('sentences');
  @override
  late final GeneratedColumn<String> sentences = GeneratedColumn<String>(
      'sentences', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _phrasesMeta =
      const VerificationMeta('phrases');
  @override
  late final GeneratedColumn<String> phrases = GeneratedColumn<String>(
      'phrases', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _synonymsMeta =
      const VerificationMeta('synonyms');
  @override
  late final GeneratedColumn<String> synonyms = GeneratedColumn<String>(
      'synonyms', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _relWordsMeta =
      const VerificationMeta('relWords');
  @override
  late final GeneratedColumn<String> relWords = GeneratedColumn<String>(
      'rel_words', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _examsMeta = const VerificationMeta('exams');
  @override
  late final GeneratedColumn<String> exams = GeneratedColumn<String>(
      'exams', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _searchContentMeta =
      const VerificationMeta('searchContent');
  @override
  late final GeneratedColumn<String> searchContent = GeneratedColumn<String>(
      'search_content', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        wordId,
        bookId,
        wordRank,
        headWord,
        usphone,
        ukphone,
        usspeech,
        ukspeech,
        trans,
        sentences,
        phrases,
        synonyms,
        relWords,
        exams,
        searchContent,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'words_table';
  @override
  VerificationContext validateIntegrity(Insertable<WordsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('word_id')) {
      context.handle(_wordIdMeta,
          wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta));
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(_bookIdMeta,
          bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta));
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('word_rank')) {
      context.handle(_wordRankMeta,
          wordRank.isAcceptableOrUnknown(data['word_rank']!, _wordRankMeta));
    } else if (isInserting) {
      context.missing(_wordRankMeta);
    }
    if (data.containsKey('head_word')) {
      context.handle(_headWordMeta,
          headWord.isAcceptableOrUnknown(data['head_word']!, _headWordMeta));
    } else if (isInserting) {
      context.missing(_headWordMeta);
    }
    if (data.containsKey('usphone')) {
      context.handle(_usphoneMeta,
          usphone.isAcceptableOrUnknown(data['usphone']!, _usphoneMeta));
    }
    if (data.containsKey('ukphone')) {
      context.handle(_ukphoneMeta,
          ukphone.isAcceptableOrUnknown(data['ukphone']!, _ukphoneMeta));
    }
    if (data.containsKey('usspeech')) {
      context.handle(_usspeechMeta,
          usspeech.isAcceptableOrUnknown(data['usspeech']!, _usspeechMeta));
    }
    if (data.containsKey('ukspeech')) {
      context.handle(_ukspeechMeta,
          ukspeech.isAcceptableOrUnknown(data['ukspeech']!, _ukspeechMeta));
    }
    if (data.containsKey('trans')) {
      context.handle(
          _transMeta, trans.isAcceptableOrUnknown(data['trans']!, _transMeta));
    }
    if (data.containsKey('sentences')) {
      context.handle(_sentencesMeta,
          sentences.isAcceptableOrUnknown(data['sentences']!, _sentencesMeta));
    }
    if (data.containsKey('phrases')) {
      context.handle(_phrasesMeta,
          phrases.isAcceptableOrUnknown(data['phrases']!, _phrasesMeta));
    }
    if (data.containsKey('synonyms')) {
      context.handle(_synonymsMeta,
          synonyms.isAcceptableOrUnknown(data['synonyms']!, _synonymsMeta));
    }
    if (data.containsKey('rel_words')) {
      context.handle(_relWordsMeta,
          relWords.isAcceptableOrUnknown(data['rel_words']!, _relWordsMeta));
    }
    if (data.containsKey('exams')) {
      context.handle(
          _examsMeta, exams.isAcceptableOrUnknown(data['exams']!, _examsMeta));
    }
    if (data.containsKey('search_content')) {
      context.handle(
          _searchContentMeta,
          searchContent.isAcceptableOrUnknown(
              data['search_content']!, _searchContentMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {wordId},
      ];
  @override
  WordsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WordsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      wordId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}word_id'])!,
      bookId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}book_id'])!,
      wordRank: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}word_rank'])!,
      headWord: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}head_word'])!,
      usphone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usphone']),
      ukphone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ukphone']),
      usspeech: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usspeech']),
      ukspeech: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ukspeech']),
      trans: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}trans'])!,
      sentences: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sentences'])!,
      phrases: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phrases'])!,
      synonyms: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}synonyms'])!,
      relWords: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rel_words'])!,
      exams: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exams'])!,
      searchContent: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}search_content'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $WordsTableTable createAlias(String alias) {
    return $WordsTableTable(attachedDatabase, alias);
  }
}

class WordsTableData extends DataClass implements Insertable<WordsTableData> {
  /// 主键ID
  final int id;

  /// 单词唯一标识符 (content.word.wordId)
  final String wordId;

  /// 单词书ID (用于分类)
  final String bookId;

  /// 单词序号 (wordRank)
  final int wordRank;

  /// 单词本身 (headWord/content.word.wordHead)
  final String headWord;

  /// 美式音标
  final String? usphone;

  /// 英式音标
  final String? ukphone;

  /// 美式发音参数
  final String? usspeech;

  /// 英式发音参数
  final String? ukspeech;

  /// 释义信息 (JSON格式, content.word.content.trans)
  final String trans;

  /// 例句 (JSON格式, content.word.content.sentence.sentences)
  final String sentences;

  /// 短语 (JSON格式, content.word.content.phrase.phrases)
  final String phrases;

  /// 同近义词 (JSON格式, content.word.content.syno.synos)
  final String synonyms;

  /// 同根词 (JSON格式, content.word.content.relWord.rels)
  final String relWords;

  /// 考试题目 (JSON格式, content.word.content.exam)
  final String exams;

  /// 搜索用的文本内容 (包含单词、释义、例句等)
  final String searchContent;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;
  const WordsTableData(
      {required this.id,
      required this.wordId,
      required this.bookId,
      required this.wordRank,
      required this.headWord,
      this.usphone,
      this.ukphone,
      this.usspeech,
      this.ukspeech,
      required this.trans,
      required this.sentences,
      required this.phrases,
      required this.synonyms,
      required this.relWords,
      required this.exams,
      required this.searchContent,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['word_id'] = Variable<String>(wordId);
    map['book_id'] = Variable<String>(bookId);
    map['word_rank'] = Variable<int>(wordRank);
    map['head_word'] = Variable<String>(headWord);
    if (!nullToAbsent || usphone != null) {
      map['usphone'] = Variable<String>(usphone);
    }
    if (!nullToAbsent || ukphone != null) {
      map['ukphone'] = Variable<String>(ukphone);
    }
    if (!nullToAbsent || usspeech != null) {
      map['usspeech'] = Variable<String>(usspeech);
    }
    if (!nullToAbsent || ukspeech != null) {
      map['ukspeech'] = Variable<String>(ukspeech);
    }
    map['trans'] = Variable<String>(trans);
    map['sentences'] = Variable<String>(sentences);
    map['phrases'] = Variable<String>(phrases);
    map['synonyms'] = Variable<String>(synonyms);
    map['rel_words'] = Variable<String>(relWords);
    map['exams'] = Variable<String>(exams);
    map['search_content'] = Variable<String>(searchContent);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WordsTableCompanion toCompanion(bool nullToAbsent) {
    return WordsTableCompanion(
      id: Value(id),
      wordId: Value(wordId),
      bookId: Value(bookId),
      wordRank: Value(wordRank),
      headWord: Value(headWord),
      usphone: usphone == null && nullToAbsent
          ? const Value.absent()
          : Value(usphone),
      ukphone: ukphone == null && nullToAbsent
          ? const Value.absent()
          : Value(ukphone),
      usspeech: usspeech == null && nullToAbsent
          ? const Value.absent()
          : Value(usspeech),
      ukspeech: ukspeech == null && nullToAbsent
          ? const Value.absent()
          : Value(ukspeech),
      trans: Value(trans),
      sentences: Value(sentences),
      phrases: Value(phrases),
      synonyms: Value(synonyms),
      relWords: Value(relWords),
      exams: Value(exams),
      searchContent: Value(searchContent),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WordsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WordsTableData(
      id: serializer.fromJson<int>(json['id']),
      wordId: serializer.fromJson<String>(json['wordId']),
      bookId: serializer.fromJson<String>(json['bookId']),
      wordRank: serializer.fromJson<int>(json['wordRank']),
      headWord: serializer.fromJson<String>(json['headWord']),
      usphone: serializer.fromJson<String?>(json['usphone']),
      ukphone: serializer.fromJson<String?>(json['ukphone']),
      usspeech: serializer.fromJson<String?>(json['usspeech']),
      ukspeech: serializer.fromJson<String?>(json['ukspeech']),
      trans: serializer.fromJson<String>(json['trans']),
      sentences: serializer.fromJson<String>(json['sentences']),
      phrases: serializer.fromJson<String>(json['phrases']),
      synonyms: serializer.fromJson<String>(json['synonyms']),
      relWords: serializer.fromJson<String>(json['relWords']),
      exams: serializer.fromJson<String>(json['exams']),
      searchContent: serializer.fromJson<String>(json['searchContent']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'wordId': serializer.toJson<String>(wordId),
      'bookId': serializer.toJson<String>(bookId),
      'wordRank': serializer.toJson<int>(wordRank),
      'headWord': serializer.toJson<String>(headWord),
      'usphone': serializer.toJson<String?>(usphone),
      'ukphone': serializer.toJson<String?>(ukphone),
      'usspeech': serializer.toJson<String?>(usspeech),
      'ukspeech': serializer.toJson<String?>(ukspeech),
      'trans': serializer.toJson<String>(trans),
      'sentences': serializer.toJson<String>(sentences),
      'phrases': serializer.toJson<String>(phrases),
      'synonyms': serializer.toJson<String>(synonyms),
      'relWords': serializer.toJson<String>(relWords),
      'exams': serializer.toJson<String>(exams),
      'searchContent': serializer.toJson<String>(searchContent),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WordsTableData copyWith(
          {int? id,
          String? wordId,
          String? bookId,
          int? wordRank,
          String? headWord,
          Value<String?> usphone = const Value.absent(),
          Value<String?> ukphone = const Value.absent(),
          Value<String?> usspeech = const Value.absent(),
          Value<String?> ukspeech = const Value.absent(),
          String? trans,
          String? sentences,
          String? phrases,
          String? synonyms,
          String? relWords,
          String? exams,
          String? searchContent,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      WordsTableData(
        id: id ?? this.id,
        wordId: wordId ?? this.wordId,
        bookId: bookId ?? this.bookId,
        wordRank: wordRank ?? this.wordRank,
        headWord: headWord ?? this.headWord,
        usphone: usphone.present ? usphone.value : this.usphone,
        ukphone: ukphone.present ? ukphone.value : this.ukphone,
        usspeech: usspeech.present ? usspeech.value : this.usspeech,
        ukspeech: ukspeech.present ? ukspeech.value : this.ukspeech,
        trans: trans ?? this.trans,
        sentences: sentences ?? this.sentences,
        phrases: phrases ?? this.phrases,
        synonyms: synonyms ?? this.synonyms,
        relWords: relWords ?? this.relWords,
        exams: exams ?? this.exams,
        searchContent: searchContent ?? this.searchContent,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  WordsTableData copyWithCompanion(WordsTableCompanion data) {
    return WordsTableData(
      id: data.id.present ? data.id.value : this.id,
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      wordRank: data.wordRank.present ? data.wordRank.value : this.wordRank,
      headWord: data.headWord.present ? data.headWord.value : this.headWord,
      usphone: data.usphone.present ? data.usphone.value : this.usphone,
      ukphone: data.ukphone.present ? data.ukphone.value : this.ukphone,
      usspeech: data.usspeech.present ? data.usspeech.value : this.usspeech,
      ukspeech: data.ukspeech.present ? data.ukspeech.value : this.ukspeech,
      trans: data.trans.present ? data.trans.value : this.trans,
      sentences: data.sentences.present ? data.sentences.value : this.sentences,
      phrases: data.phrases.present ? data.phrases.value : this.phrases,
      synonyms: data.synonyms.present ? data.synonyms.value : this.synonyms,
      relWords: data.relWords.present ? data.relWords.value : this.relWords,
      exams: data.exams.present ? data.exams.value : this.exams,
      searchContent: data.searchContent.present
          ? data.searchContent.value
          : this.searchContent,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WordsTableData(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('bookId: $bookId, ')
          ..write('wordRank: $wordRank, ')
          ..write('headWord: $headWord, ')
          ..write('usphone: $usphone, ')
          ..write('ukphone: $ukphone, ')
          ..write('usspeech: $usspeech, ')
          ..write('ukspeech: $ukspeech, ')
          ..write('trans: $trans, ')
          ..write('sentences: $sentences, ')
          ..write('phrases: $phrases, ')
          ..write('synonyms: $synonyms, ')
          ..write('relWords: $relWords, ')
          ..write('exams: $exams, ')
          ..write('searchContent: $searchContent, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      wordId,
      bookId,
      wordRank,
      headWord,
      usphone,
      ukphone,
      usspeech,
      ukspeech,
      trans,
      sentences,
      phrases,
      synonyms,
      relWords,
      exams,
      searchContent,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WordsTableData &&
          other.id == this.id &&
          other.wordId == this.wordId &&
          other.bookId == this.bookId &&
          other.wordRank == this.wordRank &&
          other.headWord == this.headWord &&
          other.usphone == this.usphone &&
          other.ukphone == this.ukphone &&
          other.usspeech == this.usspeech &&
          other.ukspeech == this.ukspeech &&
          other.trans == this.trans &&
          other.sentences == this.sentences &&
          other.phrases == this.phrases &&
          other.synonyms == this.synonyms &&
          other.relWords == this.relWords &&
          other.exams == this.exams &&
          other.searchContent == this.searchContent &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WordsTableCompanion extends UpdateCompanion<WordsTableData> {
  final Value<int> id;
  final Value<String> wordId;
  final Value<String> bookId;
  final Value<int> wordRank;
  final Value<String> headWord;
  final Value<String?> usphone;
  final Value<String?> ukphone;
  final Value<String?> usspeech;
  final Value<String?> ukspeech;
  final Value<String> trans;
  final Value<String> sentences;
  final Value<String> phrases;
  final Value<String> synonyms;
  final Value<String> relWords;
  final Value<String> exams;
  final Value<String> searchContent;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const WordsTableCompanion({
    this.id = const Value.absent(),
    this.wordId = const Value.absent(),
    this.bookId = const Value.absent(),
    this.wordRank = const Value.absent(),
    this.headWord = const Value.absent(),
    this.usphone = const Value.absent(),
    this.ukphone = const Value.absent(),
    this.usspeech = const Value.absent(),
    this.ukspeech = const Value.absent(),
    this.trans = const Value.absent(),
    this.sentences = const Value.absent(),
    this.phrases = const Value.absent(),
    this.synonyms = const Value.absent(),
    this.relWords = const Value.absent(),
    this.exams = const Value.absent(),
    this.searchContent = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  WordsTableCompanion.insert({
    this.id = const Value.absent(),
    required String wordId,
    required String bookId,
    required int wordRank,
    required String headWord,
    this.usphone = const Value.absent(),
    this.ukphone = const Value.absent(),
    this.usspeech = const Value.absent(),
    this.ukspeech = const Value.absent(),
    this.trans = const Value.absent(),
    this.sentences = const Value.absent(),
    this.phrases = const Value.absent(),
    this.synonyms = const Value.absent(),
    this.relWords = const Value.absent(),
    this.exams = const Value.absent(),
    this.searchContent = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : wordId = Value(wordId),
        bookId = Value(bookId),
        wordRank = Value(wordRank),
        headWord = Value(headWord);
  static Insertable<WordsTableData> custom({
    Expression<int>? id,
    Expression<String>? wordId,
    Expression<String>? bookId,
    Expression<int>? wordRank,
    Expression<String>? headWord,
    Expression<String>? usphone,
    Expression<String>? ukphone,
    Expression<String>? usspeech,
    Expression<String>? ukspeech,
    Expression<String>? trans,
    Expression<String>? sentences,
    Expression<String>? phrases,
    Expression<String>? synonyms,
    Expression<String>? relWords,
    Expression<String>? exams,
    Expression<String>? searchContent,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (wordId != null) 'word_id': wordId,
      if (bookId != null) 'book_id': bookId,
      if (wordRank != null) 'word_rank': wordRank,
      if (headWord != null) 'head_word': headWord,
      if (usphone != null) 'usphone': usphone,
      if (ukphone != null) 'ukphone': ukphone,
      if (usspeech != null) 'usspeech': usspeech,
      if (ukspeech != null) 'ukspeech': ukspeech,
      if (trans != null) 'trans': trans,
      if (sentences != null) 'sentences': sentences,
      if (phrases != null) 'phrases': phrases,
      if (synonyms != null) 'synonyms': synonyms,
      if (relWords != null) 'rel_words': relWords,
      if (exams != null) 'exams': exams,
      if (searchContent != null) 'search_content': searchContent,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  WordsTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? wordId,
      Value<String>? bookId,
      Value<int>? wordRank,
      Value<String>? headWord,
      Value<String?>? usphone,
      Value<String?>? ukphone,
      Value<String?>? usspeech,
      Value<String?>? ukspeech,
      Value<String>? trans,
      Value<String>? sentences,
      Value<String>? phrases,
      Value<String>? synonyms,
      Value<String>? relWords,
      Value<String>? exams,
      Value<String>? searchContent,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return WordsTableCompanion(
      id: id ?? this.id,
      wordId: wordId ?? this.wordId,
      bookId: bookId ?? this.bookId,
      wordRank: wordRank ?? this.wordRank,
      headWord: headWord ?? this.headWord,
      usphone: usphone ?? this.usphone,
      ukphone: ukphone ?? this.ukphone,
      usspeech: usspeech ?? this.usspeech,
      ukspeech: ukspeech ?? this.ukspeech,
      trans: trans ?? this.trans,
      sentences: sentences ?? this.sentences,
      phrases: phrases ?? this.phrases,
      synonyms: synonyms ?? this.synonyms,
      relWords: relWords ?? this.relWords,
      exams: exams ?? this.exams,
      searchContent: searchContent ?? this.searchContent,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (wordId.present) {
      map['word_id'] = Variable<String>(wordId.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (wordRank.present) {
      map['word_rank'] = Variable<int>(wordRank.value);
    }
    if (headWord.present) {
      map['head_word'] = Variable<String>(headWord.value);
    }
    if (usphone.present) {
      map['usphone'] = Variable<String>(usphone.value);
    }
    if (ukphone.present) {
      map['ukphone'] = Variable<String>(ukphone.value);
    }
    if (usspeech.present) {
      map['usspeech'] = Variable<String>(usspeech.value);
    }
    if (ukspeech.present) {
      map['ukspeech'] = Variable<String>(ukspeech.value);
    }
    if (trans.present) {
      map['trans'] = Variable<String>(trans.value);
    }
    if (sentences.present) {
      map['sentences'] = Variable<String>(sentences.value);
    }
    if (phrases.present) {
      map['phrases'] = Variable<String>(phrases.value);
    }
    if (synonyms.present) {
      map['synonyms'] = Variable<String>(synonyms.value);
    }
    if (relWords.present) {
      map['rel_words'] = Variable<String>(relWords.value);
    }
    if (exams.present) {
      map['exams'] = Variable<String>(exams.value);
    }
    if (searchContent.present) {
      map['search_content'] = Variable<String>(searchContent.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordsTableCompanion(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('bookId: $bookId, ')
          ..write('wordRank: $wordRank, ')
          ..write('headWord: $headWord, ')
          ..write('usphone: $usphone, ')
          ..write('ukphone: $ukphone, ')
          ..write('usspeech: $usspeech, ')
          ..write('ukspeech: $ukspeech, ')
          ..write('trans: $trans, ')
          ..write('sentences: $sentences, ')
          ..write('phrases: $phrases, ')
          ..write('synonyms: $synonyms, ')
          ..write('relWords: $relWords, ')
          ..write('exams: $exams, ')
          ..write('searchContent: $searchContent, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $UsersTableTable extends UsersTable
    with TableInfo<$UsersTableTable, UsersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 36, maxTextLength: 36),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('学习者'));
  static const VerificationMeta _avatarPathMeta =
      const VerificationMeta('avatarPath');
  @override
  late final GeneratedColumn<String> avatarPath = GeneratedColumn<String>(
      'avatar_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, name, avatarPath];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users_table';
  @override
  VerificationContext validateIntegrity(Insertable<UsersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('avatar_path')) {
      context.handle(
          _avatarPathMeta,
          avatarPath.isAcceptableOrUnknown(
              data['avatar_path']!, _avatarPathMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsersTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      avatarPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_path']),
    );
  }

  @override
  $UsersTableTable createAlias(String alias) {
    return $UsersTableTable(attachedDatabase, alias);
  }
}

class UsersTableData extends DataClass implements Insertable<UsersTableData> {
  /// 用户ID (UUID)
  final String id;

  /// 用户名/昵称
  final String name;

  /// 头像路径 (本地文件路径)
  final String? avatarPath;
  const UsersTableData({required this.id, required this.name, this.avatarPath});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || avatarPath != null) {
      map['avatar_path'] = Variable<String>(avatarPath);
    }
    return map;
  }

  UsersTableCompanion toCompanion(bool nullToAbsent) {
    return UsersTableCompanion(
      id: Value(id),
      name: Value(name),
      avatarPath: avatarPath == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarPath),
    );
  }

  factory UsersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsersTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      avatarPath: serializer.fromJson<String?>(json['avatarPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'avatarPath': serializer.toJson<String?>(avatarPath),
    };
  }

  UsersTableData copyWith(
          {String? id,
          String? name,
          Value<String?> avatarPath = const Value.absent()}) =>
      UsersTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        avatarPath: avatarPath.present ? avatarPath.value : this.avatarPath,
      );
  UsersTableData copyWithCompanion(UsersTableCompanion data) {
    return UsersTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      avatarPath:
          data.avatarPath.present ? data.avatarPath.value : this.avatarPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsersTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatarPath: $avatarPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, avatarPath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsersTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.avatarPath == this.avatarPath);
}

class UsersTableCompanion extends UpdateCompanion<UsersTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> avatarPath;
  final Value<int> rowid;
  const UsersTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersTableCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<UsersTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? avatarPath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (avatarPath != null) 'avatar_path': avatarPath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? avatarPath,
      Value<int>? rowid}) {
    return UsersTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarPath: avatarPath ?? this.avatarPath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (avatarPath.present) {
      map['avatar_path'] = Variable<String>(avatarPath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FavoritesTableTable extends FavoritesTable
    with TableInfo<$FavoritesTableTable, FavoritesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoritesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<int> wordId = GeneratedColumn<int>(
      'word_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES words_table (id) ON DELETE CASCADE'));
  static const VerificationMeta _isFavoritedMeta =
      const VerificationMeta('isFavorited');
  @override
  late final GeneratedColumn<bool> isFavorited = GeneratedColumn<bool>(
      'is_favorited', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_favorited" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _learningStatusMeta =
      const VerificationMeta('learningStatus');
  @override
  late final GeneratedColumn<int> learningStatus = GeneratedColumn<int>(
      'learning_status', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _reviewCountMeta =
      const VerificationMeta('reviewCount');
  @override
  late final GeneratedColumn<int> reviewCount = GeneratedColumn<int>(
      'review_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _correctCountMeta =
      const VerificationMeta('correctCount');
  @override
  late final GeneratedColumn<int> correctCount = GeneratedColumn<int>(
      'correct_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _incorrectCountMeta =
      const VerificationMeta('incorrectCount');
  @override
  late final GeneratedColumn<int> incorrectCount = GeneratedColumn<int>(
      'incorrect_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _memoryStrengthMeta =
      const VerificationMeta('memoryStrength');
  @override
  late final GeneratedColumn<double> memoryStrength = GeneratedColumn<double>(
      'memory_strength', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _nextReviewAtMeta =
      const VerificationMeta('nextReviewAt');
  @override
  late final GeneratedColumn<DateTime> nextReviewAt = GeneratedColumn<DateTime>(
      'next_review_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _reviewIntervalMeta =
      const VerificationMeta('reviewInterval');
  @override
  late final GeneratedColumn<int> reviewInterval = GeneratedColumn<int>(
      'review_interval', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _easeFactorMeta =
      const VerificationMeta('easeFactor');
  @override
  late final GeneratedColumn<double> easeFactor = GeneratedColumn<double>(
      'ease_factor', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(2.5));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _lastReviewedAtMeta =
      const VerificationMeta('lastReviewedAt');
  @override
  late final GeneratedColumn<DateTime> lastReviewedAt =
      GeneratedColumn<DateTime>('last_reviewed_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        wordId,
        isFavorited,
        learningStatus,
        reviewCount,
        correctCount,
        incorrectCount,
        memoryStrength,
        nextReviewAt,
        reviewInterval,
        easeFactor,
        notes,
        createdAt,
        updatedAt,
        lastReviewedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorites_table';
  @override
  VerificationContext validateIntegrity(Insertable<FavoritesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('word_id')) {
      context.handle(_wordIdMeta,
          wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta));
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('is_favorited')) {
      context.handle(
          _isFavoritedMeta,
          isFavorited.isAcceptableOrUnknown(
              data['is_favorited']!, _isFavoritedMeta));
    }
    if (data.containsKey('learning_status')) {
      context.handle(
          _learningStatusMeta,
          learningStatus.isAcceptableOrUnknown(
              data['learning_status']!, _learningStatusMeta));
    }
    if (data.containsKey('review_count')) {
      context.handle(
          _reviewCountMeta,
          reviewCount.isAcceptableOrUnknown(
              data['review_count']!, _reviewCountMeta));
    }
    if (data.containsKey('correct_count')) {
      context.handle(
          _correctCountMeta,
          correctCount.isAcceptableOrUnknown(
              data['correct_count']!, _correctCountMeta));
    }
    if (data.containsKey('incorrect_count')) {
      context.handle(
          _incorrectCountMeta,
          incorrectCount.isAcceptableOrUnknown(
              data['incorrect_count']!, _incorrectCountMeta));
    }
    if (data.containsKey('memory_strength')) {
      context.handle(
          _memoryStrengthMeta,
          memoryStrength.isAcceptableOrUnknown(
              data['memory_strength']!, _memoryStrengthMeta));
    }
    if (data.containsKey('next_review_at')) {
      context.handle(
          _nextReviewAtMeta,
          nextReviewAt.isAcceptableOrUnknown(
              data['next_review_at']!, _nextReviewAtMeta));
    }
    if (data.containsKey('review_interval')) {
      context.handle(
          _reviewIntervalMeta,
          reviewInterval.isAcceptableOrUnknown(
              data['review_interval']!, _reviewIntervalMeta));
    }
    if (data.containsKey('ease_factor')) {
      context.handle(
          _easeFactorMeta,
          easeFactor.isAcceptableOrUnknown(
              data['ease_factor']!, _easeFactorMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('last_reviewed_at')) {
      context.handle(
          _lastReviewedAtMeta,
          lastReviewedAt.isAcceptableOrUnknown(
              data['last_reviewed_at']!, _lastReviewedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {wordId},
      ];
  @override
  FavoritesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavoritesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      wordId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}word_id'])!,
      isFavorited: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_favorited'])!,
      learningStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}learning_status'])!,
      reviewCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}review_count'])!,
      correctCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}correct_count'])!,
      incorrectCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}incorrect_count'])!,
      memoryStrength: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}memory_strength'])!,
      nextReviewAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}next_review_at']),
      reviewInterval: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}review_interval'])!,
      easeFactor: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ease_factor'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      lastReviewedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_reviewed_at']),
    );
  }

  @override
  $FavoritesTableTable createAlias(String alias) {
    return $FavoritesTableTable(attachedDatabase, alias);
  }
}

class FavoritesTableData extends DataClass
    implements Insertable<FavoritesTableData> {
  /// 主键ID
  final int id;

  /// 单词ID
  final int wordId;

  /// 是否收藏
  final bool isFavorited;

  /// 学习状态 (0: 未学习, 1: 学习中, 2: 已掌握)
  final int learningStatus;

  /// 复习次数
  final int reviewCount;

  /// 正确次数
  final int correctCount;

  /// 错误次数
  final int incorrectCount;

  /// 记忆强度 (Spaced Repetition算法使用)
  final double memoryStrength;

  /// 下次复习时间
  final DateTime? nextReviewAt;

  /// 复习间隔 (天数)
  final int reviewInterval;

  /// 难度因子 (SuperMemo算法使用)
  final double easeFactor;

  /// 学习笔记
  final String notes;

  /// 添加到收藏的时间
  final DateTime createdAt;

  /// 最后更新时间
  final DateTime updatedAt;

  /// 最后复习时间
  final DateTime? lastReviewedAt;
  const FavoritesTableData(
      {required this.id,
      required this.wordId,
      required this.isFavorited,
      required this.learningStatus,
      required this.reviewCount,
      required this.correctCount,
      required this.incorrectCount,
      required this.memoryStrength,
      this.nextReviewAt,
      required this.reviewInterval,
      required this.easeFactor,
      required this.notes,
      required this.createdAt,
      required this.updatedAt,
      this.lastReviewedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['word_id'] = Variable<int>(wordId);
    map['is_favorited'] = Variable<bool>(isFavorited);
    map['learning_status'] = Variable<int>(learningStatus);
    map['review_count'] = Variable<int>(reviewCount);
    map['correct_count'] = Variable<int>(correctCount);
    map['incorrect_count'] = Variable<int>(incorrectCount);
    map['memory_strength'] = Variable<double>(memoryStrength);
    if (!nullToAbsent || nextReviewAt != null) {
      map['next_review_at'] = Variable<DateTime>(nextReviewAt);
    }
    map['review_interval'] = Variable<int>(reviewInterval);
    map['ease_factor'] = Variable<double>(easeFactor);
    map['notes'] = Variable<String>(notes);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lastReviewedAt != null) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt);
    }
    return map;
  }

  FavoritesTableCompanion toCompanion(bool nullToAbsent) {
    return FavoritesTableCompanion(
      id: Value(id),
      wordId: Value(wordId),
      isFavorited: Value(isFavorited),
      learningStatus: Value(learningStatus),
      reviewCount: Value(reviewCount),
      correctCount: Value(correctCount),
      incorrectCount: Value(incorrectCount),
      memoryStrength: Value(memoryStrength),
      nextReviewAt: nextReviewAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextReviewAt),
      reviewInterval: Value(reviewInterval),
      easeFactor: Value(easeFactor),
      notes: Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastReviewedAt: lastReviewedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewedAt),
    );
  }

  factory FavoritesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FavoritesTableData(
      id: serializer.fromJson<int>(json['id']),
      wordId: serializer.fromJson<int>(json['wordId']),
      isFavorited: serializer.fromJson<bool>(json['isFavorited']),
      learningStatus: serializer.fromJson<int>(json['learningStatus']),
      reviewCount: serializer.fromJson<int>(json['reviewCount']),
      correctCount: serializer.fromJson<int>(json['correctCount']),
      incorrectCount: serializer.fromJson<int>(json['incorrectCount']),
      memoryStrength: serializer.fromJson<double>(json['memoryStrength']),
      nextReviewAt: serializer.fromJson<DateTime?>(json['nextReviewAt']),
      reviewInterval: serializer.fromJson<int>(json['reviewInterval']),
      easeFactor: serializer.fromJson<double>(json['easeFactor']),
      notes: serializer.fromJson<String>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastReviewedAt: serializer.fromJson<DateTime?>(json['lastReviewedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'wordId': serializer.toJson<int>(wordId),
      'isFavorited': serializer.toJson<bool>(isFavorited),
      'learningStatus': serializer.toJson<int>(learningStatus),
      'reviewCount': serializer.toJson<int>(reviewCount),
      'correctCount': serializer.toJson<int>(correctCount),
      'incorrectCount': serializer.toJson<int>(incorrectCount),
      'memoryStrength': serializer.toJson<double>(memoryStrength),
      'nextReviewAt': serializer.toJson<DateTime?>(nextReviewAt),
      'reviewInterval': serializer.toJson<int>(reviewInterval),
      'easeFactor': serializer.toJson<double>(easeFactor),
      'notes': serializer.toJson<String>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastReviewedAt': serializer.toJson<DateTime?>(lastReviewedAt),
    };
  }

  FavoritesTableData copyWith(
          {int? id,
          int? wordId,
          bool? isFavorited,
          int? learningStatus,
          int? reviewCount,
          int? correctCount,
          int? incorrectCount,
          double? memoryStrength,
          Value<DateTime?> nextReviewAt = const Value.absent(),
          int? reviewInterval,
          double? easeFactor,
          String? notes,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> lastReviewedAt = const Value.absent()}) =>
      FavoritesTableData(
        id: id ?? this.id,
        wordId: wordId ?? this.wordId,
        isFavorited: isFavorited ?? this.isFavorited,
        learningStatus: learningStatus ?? this.learningStatus,
        reviewCount: reviewCount ?? this.reviewCount,
        correctCount: correctCount ?? this.correctCount,
        incorrectCount: incorrectCount ?? this.incorrectCount,
        memoryStrength: memoryStrength ?? this.memoryStrength,
        nextReviewAt:
            nextReviewAt.present ? nextReviewAt.value : this.nextReviewAt,
        reviewInterval: reviewInterval ?? this.reviewInterval,
        easeFactor: easeFactor ?? this.easeFactor,
        notes: notes ?? this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastReviewedAt:
            lastReviewedAt.present ? lastReviewedAt.value : this.lastReviewedAt,
      );
  FavoritesTableData copyWithCompanion(FavoritesTableCompanion data) {
    return FavoritesTableData(
      id: data.id.present ? data.id.value : this.id,
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      isFavorited:
          data.isFavorited.present ? data.isFavorited.value : this.isFavorited,
      learningStatus: data.learningStatus.present
          ? data.learningStatus.value
          : this.learningStatus,
      reviewCount:
          data.reviewCount.present ? data.reviewCount.value : this.reviewCount,
      correctCount: data.correctCount.present
          ? data.correctCount.value
          : this.correctCount,
      incorrectCount: data.incorrectCount.present
          ? data.incorrectCount.value
          : this.incorrectCount,
      memoryStrength: data.memoryStrength.present
          ? data.memoryStrength.value
          : this.memoryStrength,
      nextReviewAt: data.nextReviewAt.present
          ? data.nextReviewAt.value
          : this.nextReviewAt,
      reviewInterval: data.reviewInterval.present
          ? data.reviewInterval.value
          : this.reviewInterval,
      easeFactor:
          data.easeFactor.present ? data.easeFactor.value : this.easeFactor,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastReviewedAt: data.lastReviewedAt.present
          ? data.lastReviewedAt.value
          : this.lastReviewedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FavoritesTableData(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('isFavorited: $isFavorited, ')
          ..write('learningStatus: $learningStatus, ')
          ..write('reviewCount: $reviewCount, ')
          ..write('correctCount: $correctCount, ')
          ..write('incorrectCount: $incorrectCount, ')
          ..write('memoryStrength: $memoryStrength, ')
          ..write('nextReviewAt: $nextReviewAt, ')
          ..write('reviewInterval: $reviewInterval, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastReviewedAt: $lastReviewedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      wordId,
      isFavorited,
      learningStatus,
      reviewCount,
      correctCount,
      incorrectCount,
      memoryStrength,
      nextReviewAt,
      reviewInterval,
      easeFactor,
      notes,
      createdAt,
      updatedAt,
      lastReviewedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoritesTableData &&
          other.id == this.id &&
          other.wordId == this.wordId &&
          other.isFavorited == this.isFavorited &&
          other.learningStatus == this.learningStatus &&
          other.reviewCount == this.reviewCount &&
          other.correctCount == this.correctCount &&
          other.incorrectCount == this.incorrectCount &&
          other.memoryStrength == this.memoryStrength &&
          other.nextReviewAt == this.nextReviewAt &&
          other.reviewInterval == this.reviewInterval &&
          other.easeFactor == this.easeFactor &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastReviewedAt == this.lastReviewedAt);
}

class FavoritesTableCompanion extends UpdateCompanion<FavoritesTableData> {
  final Value<int> id;
  final Value<int> wordId;
  final Value<bool> isFavorited;
  final Value<int> learningStatus;
  final Value<int> reviewCount;
  final Value<int> correctCount;
  final Value<int> incorrectCount;
  final Value<double> memoryStrength;
  final Value<DateTime?> nextReviewAt;
  final Value<int> reviewInterval;
  final Value<double> easeFactor;
  final Value<String> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> lastReviewedAt;
  const FavoritesTableCompanion({
    this.id = const Value.absent(),
    this.wordId = const Value.absent(),
    this.isFavorited = const Value.absent(),
    this.learningStatus = const Value.absent(),
    this.reviewCount = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.incorrectCount = const Value.absent(),
    this.memoryStrength = const Value.absent(),
    this.nextReviewAt = const Value.absent(),
    this.reviewInterval = const Value.absent(),
    this.easeFactor = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
  });
  FavoritesTableCompanion.insert({
    this.id = const Value.absent(),
    required int wordId,
    this.isFavorited = const Value.absent(),
    this.learningStatus = const Value.absent(),
    this.reviewCount = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.incorrectCount = const Value.absent(),
    this.memoryStrength = const Value.absent(),
    this.nextReviewAt = const Value.absent(),
    this.reviewInterval = const Value.absent(),
    this.easeFactor = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
  }) : wordId = Value(wordId);
  static Insertable<FavoritesTableData> custom({
    Expression<int>? id,
    Expression<int>? wordId,
    Expression<bool>? isFavorited,
    Expression<int>? learningStatus,
    Expression<int>? reviewCount,
    Expression<int>? correctCount,
    Expression<int>? incorrectCount,
    Expression<double>? memoryStrength,
    Expression<DateTime>? nextReviewAt,
    Expression<int>? reviewInterval,
    Expression<double>? easeFactor,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastReviewedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (wordId != null) 'word_id': wordId,
      if (isFavorited != null) 'is_favorited': isFavorited,
      if (learningStatus != null) 'learning_status': learningStatus,
      if (reviewCount != null) 'review_count': reviewCount,
      if (correctCount != null) 'correct_count': correctCount,
      if (incorrectCount != null) 'incorrect_count': incorrectCount,
      if (memoryStrength != null) 'memory_strength': memoryStrength,
      if (nextReviewAt != null) 'next_review_at': nextReviewAt,
      if (reviewInterval != null) 'review_interval': reviewInterval,
      if (easeFactor != null) 'ease_factor': easeFactor,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastReviewedAt != null) 'last_reviewed_at': lastReviewedAt,
    });
  }

  FavoritesTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? wordId,
      Value<bool>? isFavorited,
      Value<int>? learningStatus,
      Value<int>? reviewCount,
      Value<int>? correctCount,
      Value<int>? incorrectCount,
      Value<double>? memoryStrength,
      Value<DateTime?>? nextReviewAt,
      Value<int>? reviewInterval,
      Value<double>? easeFactor,
      Value<String>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? lastReviewedAt}) {
    return FavoritesTableCompanion(
      id: id ?? this.id,
      wordId: wordId ?? this.wordId,
      isFavorited: isFavorited ?? this.isFavorited,
      learningStatus: learningStatus ?? this.learningStatus,
      reviewCount: reviewCount ?? this.reviewCount,
      correctCount: correctCount ?? this.correctCount,
      incorrectCount: incorrectCount ?? this.incorrectCount,
      memoryStrength: memoryStrength ?? this.memoryStrength,
      nextReviewAt: nextReviewAt ?? this.nextReviewAt,
      reviewInterval: reviewInterval ?? this.reviewInterval,
      easeFactor: easeFactor ?? this.easeFactor,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (wordId.present) {
      map['word_id'] = Variable<int>(wordId.value);
    }
    if (isFavorited.present) {
      map['is_favorited'] = Variable<bool>(isFavorited.value);
    }
    if (learningStatus.present) {
      map['learning_status'] = Variable<int>(learningStatus.value);
    }
    if (reviewCount.present) {
      map['review_count'] = Variable<int>(reviewCount.value);
    }
    if (correctCount.present) {
      map['correct_count'] = Variable<int>(correctCount.value);
    }
    if (incorrectCount.present) {
      map['incorrect_count'] = Variable<int>(incorrectCount.value);
    }
    if (memoryStrength.present) {
      map['memory_strength'] = Variable<double>(memoryStrength.value);
    }
    if (nextReviewAt.present) {
      map['next_review_at'] = Variable<DateTime>(nextReviewAt.value);
    }
    if (reviewInterval.present) {
      map['review_interval'] = Variable<int>(reviewInterval.value);
    }
    if (easeFactor.present) {
      map['ease_factor'] = Variable<double>(easeFactor.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastReviewedAt.present) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoritesTableCompanion(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('isFavorited: $isFavorited, ')
          ..write('learningStatus: $learningStatus, ')
          ..write('reviewCount: $reviewCount, ')
          ..write('correctCount: $correctCount, ')
          ..write('incorrectCount: $incorrectCount, ')
          ..write('memoryStrength: $memoryStrength, ')
          ..write('nextReviewAt: $nextReviewAt, ')
          ..write('reviewInterval: $reviewInterval, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastReviewedAt: $lastReviewedAt')
          ..write(')'))
        .toString();
  }
}

class $SearchHistoryTableTable extends SearchHistoryTable
    with TableInfo<$SearchHistoryTableTable, SearchHistoryTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SearchHistoryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES users_table (id) ON DELETE CASCADE'));
  static const VerificationMeta _queryMeta = const VerificationMeta('query');
  @override
  late final GeneratedColumn<String> query = GeneratedColumn<String>(
      'query', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _resultCountMeta =
      const VerificationMeta('resultCount');
  @override
  late final GeneratedColumn<int> resultCount = GeneratedColumn<int>(
      'result_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, query, resultCount, timestamp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'search_history_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<SearchHistoryTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('query')) {
      context.handle(
          _queryMeta, query.isAcceptableOrUnknown(data['query']!, _queryMeta));
    } else if (isInserting) {
      context.missing(_queryMeta);
    }
    if (data.containsKey('result_count')) {
      context.handle(
          _resultCountMeta,
          resultCount.isAcceptableOrUnknown(
              data['result_count']!, _resultCountMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {userId, query},
      ];
  @override
  SearchHistoryTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SearchHistoryTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      query: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}query'])!,
      resultCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}result_count'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
    );
  }

  @override
  $SearchHistoryTableTable createAlias(String alias) {
    return $SearchHistoryTableTable(attachedDatabase, alias);
  }
}

class SearchHistoryTableData extends DataClass
    implements Insertable<SearchHistoryTableData> {
  /// 主键ID
  final int id;

  /// 用户ID
  final String userId;

  /// 搜索查询词
  final String query;

  /// 搜索结果数量
  final int resultCount;

  /// 搜索时间戳
  final DateTime timestamp;
  const SearchHistoryTableData(
      {required this.id,
      required this.userId,
      required this.query,
      required this.resultCount,
      required this.timestamp});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['query'] = Variable<String>(query);
    map['result_count'] = Variable<int>(resultCount);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  SearchHistoryTableCompanion toCompanion(bool nullToAbsent) {
    return SearchHistoryTableCompanion(
      id: Value(id),
      userId: Value(userId),
      query: Value(query),
      resultCount: Value(resultCount),
      timestamp: Value(timestamp),
    );
  }

  factory SearchHistoryTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SearchHistoryTableData(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      query: serializer.fromJson<String>(json['query']),
      resultCount: serializer.fromJson<int>(json['resultCount']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'query': serializer.toJson<String>(query),
      'resultCount': serializer.toJson<int>(resultCount),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  SearchHistoryTableData copyWith(
          {int? id,
          String? userId,
          String? query,
          int? resultCount,
          DateTime? timestamp}) =>
      SearchHistoryTableData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        query: query ?? this.query,
        resultCount: resultCount ?? this.resultCount,
        timestamp: timestamp ?? this.timestamp,
      );
  SearchHistoryTableData copyWithCompanion(SearchHistoryTableCompanion data) {
    return SearchHistoryTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      query: data.query.present ? data.query.value : this.query,
      resultCount:
          data.resultCount.present ? data.resultCount.value : this.resultCount,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SearchHistoryTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('query: $query, ')
          ..write('resultCount: $resultCount, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, query, resultCount, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SearchHistoryTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.query == this.query &&
          other.resultCount == this.resultCount &&
          other.timestamp == this.timestamp);
}

class SearchHistoryTableCompanion
    extends UpdateCompanion<SearchHistoryTableData> {
  final Value<int> id;
  final Value<String> userId;
  final Value<String> query;
  final Value<int> resultCount;
  final Value<DateTime> timestamp;
  const SearchHistoryTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.query = const Value.absent(),
    this.resultCount = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  SearchHistoryTableCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required String query,
    this.resultCount = const Value.absent(),
    this.timestamp = const Value.absent(),
  })  : userId = Value(userId),
        query = Value(query);
  static Insertable<SearchHistoryTableData> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<String>? query,
    Expression<int>? resultCount,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (query != null) 'query': query,
      if (resultCount != null) 'result_count': resultCount,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  SearchHistoryTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? userId,
      Value<String>? query,
      Value<int>? resultCount,
      Value<DateTime>? timestamp}) {
    return SearchHistoryTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      query: query ?? this.query,
      resultCount: resultCount ?? this.resultCount,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (query.present) {
      map['query'] = Variable<String>(query.value);
    }
    if (resultCount.present) {
      map['result_count'] = Variable<int>(resultCount.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SearchHistoryTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('query: $query, ')
          ..write('resultCount: $resultCount, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WordsTableTable wordsTable = $WordsTableTable(this);
  late final $UsersTableTable usersTable = $UsersTableTable(this);
  late final $FavoritesTableTable favoritesTable = $FavoritesTableTable(this);
  late final $SearchHistoryTableTable searchHistoryTable =
      $SearchHistoryTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [wordsTable, usersTable, favoritesTable, searchHistoryTable];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('words_table',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('favorites_table', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('users_table',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('search_history_table', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$WordsTableTableCreateCompanionBuilder = WordsTableCompanion Function({
  Value<int> id,
  required String wordId,
  required String bookId,
  required int wordRank,
  required String headWord,
  Value<String?> usphone,
  Value<String?> ukphone,
  Value<String?> usspeech,
  Value<String?> ukspeech,
  Value<String> trans,
  Value<String> sentences,
  Value<String> phrases,
  Value<String> synonyms,
  Value<String> relWords,
  Value<String> exams,
  Value<String> searchContent,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$WordsTableTableUpdateCompanionBuilder = WordsTableCompanion Function({
  Value<int> id,
  Value<String> wordId,
  Value<String> bookId,
  Value<int> wordRank,
  Value<String> headWord,
  Value<String?> usphone,
  Value<String?> ukphone,
  Value<String?> usspeech,
  Value<String?> ukspeech,
  Value<String> trans,
  Value<String> sentences,
  Value<String> phrases,
  Value<String> synonyms,
  Value<String> relWords,
  Value<String> exams,
  Value<String> searchContent,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$WordsTableTableReferences
    extends BaseReferences<_$AppDatabase, $WordsTableTable, WordsTableData> {
  $$WordsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FavoritesTableTable, List<FavoritesTableData>>
      _favoritesTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.favoritesTable,
              aliasName: $_aliasNameGenerator(
                  db.wordsTable.id, db.favoritesTable.wordId));

  $$FavoritesTableTableProcessedTableManager get favoritesTableRefs {
    final manager = $$FavoritesTableTableTableManager($_db, $_db.favoritesTable)
        .filter((f) => f.wordId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_favoritesTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$WordsTableTableFilterComposer
    extends Composer<_$AppDatabase, $WordsTableTable> {
  $$WordsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get wordId => $composableBuilder(
      column: $table.wordId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bookId => $composableBuilder(
      column: $table.bookId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get wordRank => $composableBuilder(
      column: $table.wordRank, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get headWord => $composableBuilder(
      column: $table.headWord, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usphone => $composableBuilder(
      column: $table.usphone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ukphone => $composableBuilder(
      column: $table.ukphone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usspeech => $composableBuilder(
      column: $table.usspeech, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ukspeech => $composableBuilder(
      column: $table.ukspeech, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get trans => $composableBuilder(
      column: $table.trans, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sentences => $composableBuilder(
      column: $table.sentences, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phrases => $composableBuilder(
      column: $table.phrases, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get synonyms => $composableBuilder(
      column: $table.synonyms, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relWords => $composableBuilder(
      column: $table.relWords, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exams => $composableBuilder(
      column: $table.exams, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get searchContent => $composableBuilder(
      column: $table.searchContent, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> favoritesTableRefs(
      Expression<bool> Function($$FavoritesTableTableFilterComposer f) f) {
    final $$FavoritesTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.favoritesTable,
        getReferencedColumn: (t) => t.wordId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FavoritesTableTableFilterComposer(
              $db: $db,
              $table: $db.favoritesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WordsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $WordsTableTable> {
  $$WordsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get wordId => $composableBuilder(
      column: $table.wordId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bookId => $composableBuilder(
      column: $table.bookId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get wordRank => $composableBuilder(
      column: $table.wordRank, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get headWord => $composableBuilder(
      column: $table.headWord, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usphone => $composableBuilder(
      column: $table.usphone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ukphone => $composableBuilder(
      column: $table.ukphone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usspeech => $composableBuilder(
      column: $table.usspeech, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ukspeech => $composableBuilder(
      column: $table.ukspeech, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get trans => $composableBuilder(
      column: $table.trans, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sentences => $composableBuilder(
      column: $table.sentences, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phrases => $composableBuilder(
      column: $table.phrases, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get synonyms => $composableBuilder(
      column: $table.synonyms, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relWords => $composableBuilder(
      column: $table.relWords, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exams => $composableBuilder(
      column: $table.exams, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get searchContent => $composableBuilder(
      column: $table.searchContent,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$WordsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $WordsTableTable> {
  $$WordsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get wordId =>
      $composableBuilder(column: $table.wordId, builder: (column) => column);

  GeneratedColumn<String> get bookId =>
      $composableBuilder(column: $table.bookId, builder: (column) => column);

  GeneratedColumn<int> get wordRank =>
      $composableBuilder(column: $table.wordRank, builder: (column) => column);

  GeneratedColumn<String> get headWord =>
      $composableBuilder(column: $table.headWord, builder: (column) => column);

  GeneratedColumn<String> get usphone =>
      $composableBuilder(column: $table.usphone, builder: (column) => column);

  GeneratedColumn<String> get ukphone =>
      $composableBuilder(column: $table.ukphone, builder: (column) => column);

  GeneratedColumn<String> get usspeech =>
      $composableBuilder(column: $table.usspeech, builder: (column) => column);

  GeneratedColumn<String> get ukspeech =>
      $composableBuilder(column: $table.ukspeech, builder: (column) => column);

  GeneratedColumn<String> get trans =>
      $composableBuilder(column: $table.trans, builder: (column) => column);

  GeneratedColumn<String> get sentences =>
      $composableBuilder(column: $table.sentences, builder: (column) => column);

  GeneratedColumn<String> get phrases =>
      $composableBuilder(column: $table.phrases, builder: (column) => column);

  GeneratedColumn<String> get synonyms =>
      $composableBuilder(column: $table.synonyms, builder: (column) => column);

  GeneratedColumn<String> get relWords =>
      $composableBuilder(column: $table.relWords, builder: (column) => column);

  GeneratedColumn<String> get exams =>
      $composableBuilder(column: $table.exams, builder: (column) => column);

  GeneratedColumn<String> get searchContent => $composableBuilder(
      column: $table.searchContent, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> favoritesTableRefs<T extends Object>(
      Expression<T> Function($$FavoritesTableTableAnnotationComposer a) f) {
    final $$FavoritesTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.favoritesTable,
        getReferencedColumn: (t) => t.wordId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FavoritesTableTableAnnotationComposer(
              $db: $db,
              $table: $db.favoritesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WordsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WordsTableTable,
    WordsTableData,
    $$WordsTableTableFilterComposer,
    $$WordsTableTableOrderingComposer,
    $$WordsTableTableAnnotationComposer,
    $$WordsTableTableCreateCompanionBuilder,
    $$WordsTableTableUpdateCompanionBuilder,
    (WordsTableData, $$WordsTableTableReferences),
    WordsTableData,
    PrefetchHooks Function({bool favoritesTableRefs})> {
  $$WordsTableTableTableManager(_$AppDatabase db, $WordsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WordsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WordsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WordsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> wordId = const Value.absent(),
            Value<String> bookId = const Value.absent(),
            Value<int> wordRank = const Value.absent(),
            Value<String> headWord = const Value.absent(),
            Value<String?> usphone = const Value.absent(),
            Value<String?> ukphone = const Value.absent(),
            Value<String?> usspeech = const Value.absent(),
            Value<String?> ukspeech = const Value.absent(),
            Value<String> trans = const Value.absent(),
            Value<String> sentences = const Value.absent(),
            Value<String> phrases = const Value.absent(),
            Value<String> synonyms = const Value.absent(),
            Value<String> relWords = const Value.absent(),
            Value<String> exams = const Value.absent(),
            Value<String> searchContent = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              WordsTableCompanion(
            id: id,
            wordId: wordId,
            bookId: bookId,
            wordRank: wordRank,
            headWord: headWord,
            usphone: usphone,
            ukphone: ukphone,
            usspeech: usspeech,
            ukspeech: ukspeech,
            trans: trans,
            sentences: sentences,
            phrases: phrases,
            synonyms: synonyms,
            relWords: relWords,
            exams: exams,
            searchContent: searchContent,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String wordId,
            required String bookId,
            required int wordRank,
            required String headWord,
            Value<String?> usphone = const Value.absent(),
            Value<String?> ukphone = const Value.absent(),
            Value<String?> usspeech = const Value.absent(),
            Value<String?> ukspeech = const Value.absent(),
            Value<String> trans = const Value.absent(),
            Value<String> sentences = const Value.absent(),
            Value<String> phrases = const Value.absent(),
            Value<String> synonyms = const Value.absent(),
            Value<String> relWords = const Value.absent(),
            Value<String> exams = const Value.absent(),
            Value<String> searchContent = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              WordsTableCompanion.insert(
            id: id,
            wordId: wordId,
            bookId: bookId,
            wordRank: wordRank,
            headWord: headWord,
            usphone: usphone,
            ukphone: ukphone,
            usspeech: usspeech,
            ukspeech: ukspeech,
            trans: trans,
            sentences: sentences,
            phrases: phrases,
            synonyms: synonyms,
            relWords: relWords,
            exams: exams,
            searchContent: searchContent,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WordsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({favoritesTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (favoritesTableRefs) db.favoritesTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (favoritesTableRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$WordsTableTableReferences
                            ._favoritesTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WordsTableTableReferences(db, table, p0)
                                .favoritesTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.wordId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$WordsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WordsTableTable,
    WordsTableData,
    $$WordsTableTableFilterComposer,
    $$WordsTableTableOrderingComposer,
    $$WordsTableTableAnnotationComposer,
    $$WordsTableTableCreateCompanionBuilder,
    $$WordsTableTableUpdateCompanionBuilder,
    (WordsTableData, $$WordsTableTableReferences),
    WordsTableData,
    PrefetchHooks Function({bool favoritesTableRefs})>;
typedef $$UsersTableTableCreateCompanionBuilder = UsersTableCompanion Function({
  required String id,
  Value<String> name,
  Value<String?> avatarPath,
  Value<int> rowid,
});
typedef $$UsersTableTableUpdateCompanionBuilder = UsersTableCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> avatarPath,
  Value<int> rowid,
});

final class $$UsersTableTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTableTable, UsersTableData> {
  $$UsersTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SearchHistoryTableTable,
      List<SearchHistoryTableData>> _searchHistoryTableRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.searchHistoryTable,
          aliasName: $_aliasNameGenerator(
              db.usersTable.id, db.searchHistoryTable.userId));

  $$SearchHistoryTableTableProcessedTableManager get searchHistoryTableRefs {
    final manager =
        $$SearchHistoryTableTableTableManager($_db, $_db.searchHistoryTable)
            .filter((f) => f.userId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_searchHistoryTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$UsersTableTableFilterComposer
    extends Composer<_$AppDatabase, $UsersTableTable> {
  $$UsersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => ColumnFilters(column));

  Expression<bool> searchHistoryTableRefs(
      Expression<bool> Function($$SearchHistoryTableTableFilterComposer f) f) {
    final $$SearchHistoryTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.searchHistoryTable,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SearchHistoryTableTableFilterComposer(
              $db: $db,
              $table: $db.searchHistoryTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTableTable> {
  $$UsersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTableTable> {
  $$UsersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => column);

  Expression<T> searchHistoryTableRefs<T extends Object>(
      Expression<T> Function($$SearchHistoryTableTableAnnotationComposer a) f) {
    final $$SearchHistoryTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.searchHistoryTable,
            getReferencedColumn: (t) => t.userId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$SearchHistoryTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.searchHistoryTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$UsersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTableTable,
    UsersTableData,
    $$UsersTableTableFilterComposer,
    $$UsersTableTableOrderingComposer,
    $$UsersTableTableAnnotationComposer,
    $$UsersTableTableCreateCompanionBuilder,
    $$UsersTableTableUpdateCompanionBuilder,
    (UsersTableData, $$UsersTableTableReferences),
    UsersTableData,
    PrefetchHooks Function({bool searchHistoryTableRefs})> {
  $$UsersTableTableTableManager(_$AppDatabase db, $UsersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> avatarPath = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersTableCompanion(
            id: id,
            name: name,
            avatarPath: avatarPath,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String> name = const Value.absent(),
            Value<String?> avatarPath = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersTableCompanion.insert(
            id: id,
            name: name,
            avatarPath: avatarPath,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$UsersTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({searchHistoryTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (searchHistoryTableRefs) db.searchHistoryTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (searchHistoryTableRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$UsersTableTableReferences
                            ._searchHistoryTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableTableReferences(db, table, p0)
                                .searchHistoryTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$UsersTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTableTable,
    UsersTableData,
    $$UsersTableTableFilterComposer,
    $$UsersTableTableOrderingComposer,
    $$UsersTableTableAnnotationComposer,
    $$UsersTableTableCreateCompanionBuilder,
    $$UsersTableTableUpdateCompanionBuilder,
    (UsersTableData, $$UsersTableTableReferences),
    UsersTableData,
    PrefetchHooks Function({bool searchHistoryTableRefs})>;
typedef $$FavoritesTableTableCreateCompanionBuilder = FavoritesTableCompanion
    Function({
  Value<int> id,
  required int wordId,
  Value<bool> isFavorited,
  Value<int> learningStatus,
  Value<int> reviewCount,
  Value<int> correctCount,
  Value<int> incorrectCount,
  Value<double> memoryStrength,
  Value<DateTime?> nextReviewAt,
  Value<int> reviewInterval,
  Value<double> easeFactor,
  Value<String> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> lastReviewedAt,
});
typedef $$FavoritesTableTableUpdateCompanionBuilder = FavoritesTableCompanion
    Function({
  Value<int> id,
  Value<int> wordId,
  Value<bool> isFavorited,
  Value<int> learningStatus,
  Value<int> reviewCount,
  Value<int> correctCount,
  Value<int> incorrectCount,
  Value<double> memoryStrength,
  Value<DateTime?> nextReviewAt,
  Value<int> reviewInterval,
  Value<double> easeFactor,
  Value<String> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> lastReviewedAt,
});

final class $$FavoritesTableTableReferences extends BaseReferences<
    _$AppDatabase, $FavoritesTableTable, FavoritesTableData> {
  $$FavoritesTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $WordsTableTable _wordIdTable(_$AppDatabase db) =>
      db.wordsTable.createAlias(
          $_aliasNameGenerator(db.favoritesTable.wordId, db.wordsTable.id));

  $$WordsTableTableProcessedTableManager? get wordId {
    if ($_item.wordId == null) return null;
    final manager = $$WordsTableTableTableManager($_db, $_db.wordsTable)
        .filter((f) => f.id($_item.wordId!));
    final item = $_typedResult.readTableOrNull(_wordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$FavoritesTableTableFilterComposer
    extends Composer<_$AppDatabase, $FavoritesTableTable> {
  $$FavoritesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFavorited => $composableBuilder(
      column: $table.isFavorited, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get learningStatus => $composableBuilder(
      column: $table.learningStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reviewCount => $composableBuilder(
      column: $table.reviewCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get correctCount => $composableBuilder(
      column: $table.correctCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get incorrectCount => $composableBuilder(
      column: $table.incorrectCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get memoryStrength => $composableBuilder(
      column: $table.memoryStrength,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextReviewAt => $composableBuilder(
      column: $table.nextReviewAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reviewInterval => $composableBuilder(
      column: $table.reviewInterval,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get easeFactor => $composableBuilder(
      column: $table.easeFactor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastReviewedAt => $composableBuilder(
      column: $table.lastReviewedAt,
      builder: (column) => ColumnFilters(column));

  $$WordsTableTableFilterComposer get wordId {
    final $$WordsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.wordId,
        referencedTable: $db.wordsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordsTableTableFilterComposer(
              $db: $db,
              $table: $db.wordsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FavoritesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoritesTableTable> {
  $$FavoritesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFavorited => $composableBuilder(
      column: $table.isFavorited, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get learningStatus => $composableBuilder(
      column: $table.learningStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reviewCount => $composableBuilder(
      column: $table.reviewCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get correctCount => $composableBuilder(
      column: $table.correctCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get incorrectCount => $composableBuilder(
      column: $table.incorrectCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get memoryStrength => $composableBuilder(
      column: $table.memoryStrength,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextReviewAt => $composableBuilder(
      column: $table.nextReviewAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reviewInterval => $composableBuilder(
      column: $table.reviewInterval,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get easeFactor => $composableBuilder(
      column: $table.easeFactor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastReviewedAt => $composableBuilder(
      column: $table.lastReviewedAt,
      builder: (column) => ColumnOrderings(column));

  $$WordsTableTableOrderingComposer get wordId {
    final $$WordsTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.wordId,
        referencedTable: $db.wordsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordsTableTableOrderingComposer(
              $db: $db,
              $table: $db.wordsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FavoritesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoritesTableTable> {
  $$FavoritesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get isFavorited => $composableBuilder(
      column: $table.isFavorited, builder: (column) => column);

  GeneratedColumn<int> get learningStatus => $composableBuilder(
      column: $table.learningStatus, builder: (column) => column);

  GeneratedColumn<int> get reviewCount => $composableBuilder(
      column: $table.reviewCount, builder: (column) => column);

  GeneratedColumn<int> get correctCount => $composableBuilder(
      column: $table.correctCount, builder: (column) => column);

  GeneratedColumn<int> get incorrectCount => $composableBuilder(
      column: $table.incorrectCount, builder: (column) => column);

  GeneratedColumn<double> get memoryStrength => $composableBuilder(
      column: $table.memoryStrength, builder: (column) => column);

  GeneratedColumn<DateTime> get nextReviewAt => $composableBuilder(
      column: $table.nextReviewAt, builder: (column) => column);

  GeneratedColumn<int> get reviewInterval => $composableBuilder(
      column: $table.reviewInterval, builder: (column) => column);

  GeneratedColumn<double> get easeFactor => $composableBuilder(
      column: $table.easeFactor, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReviewedAt => $composableBuilder(
      column: $table.lastReviewedAt, builder: (column) => column);

  $$WordsTableTableAnnotationComposer get wordId {
    final $$WordsTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.wordId,
        referencedTable: $db.wordsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordsTableTableAnnotationComposer(
              $db: $db,
              $table: $db.wordsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FavoritesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FavoritesTableTable,
    FavoritesTableData,
    $$FavoritesTableTableFilterComposer,
    $$FavoritesTableTableOrderingComposer,
    $$FavoritesTableTableAnnotationComposer,
    $$FavoritesTableTableCreateCompanionBuilder,
    $$FavoritesTableTableUpdateCompanionBuilder,
    (FavoritesTableData, $$FavoritesTableTableReferences),
    FavoritesTableData,
    PrefetchHooks Function({bool wordId})> {
  $$FavoritesTableTableTableManager(
      _$AppDatabase db, $FavoritesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoritesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoritesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoritesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> wordId = const Value.absent(),
            Value<bool> isFavorited = const Value.absent(),
            Value<int> learningStatus = const Value.absent(),
            Value<int> reviewCount = const Value.absent(),
            Value<int> correctCount = const Value.absent(),
            Value<int> incorrectCount = const Value.absent(),
            Value<double> memoryStrength = const Value.absent(),
            Value<DateTime?> nextReviewAt = const Value.absent(),
            Value<int> reviewInterval = const Value.absent(),
            Value<double> easeFactor = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> lastReviewedAt = const Value.absent(),
          }) =>
              FavoritesTableCompanion(
            id: id,
            wordId: wordId,
            isFavorited: isFavorited,
            learningStatus: learningStatus,
            reviewCount: reviewCount,
            correctCount: correctCount,
            incorrectCount: incorrectCount,
            memoryStrength: memoryStrength,
            nextReviewAt: nextReviewAt,
            reviewInterval: reviewInterval,
            easeFactor: easeFactor,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastReviewedAt: lastReviewedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int wordId,
            Value<bool> isFavorited = const Value.absent(),
            Value<int> learningStatus = const Value.absent(),
            Value<int> reviewCount = const Value.absent(),
            Value<int> correctCount = const Value.absent(),
            Value<int> incorrectCount = const Value.absent(),
            Value<double> memoryStrength = const Value.absent(),
            Value<DateTime?> nextReviewAt = const Value.absent(),
            Value<int> reviewInterval = const Value.absent(),
            Value<double> easeFactor = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> lastReviewedAt = const Value.absent(),
          }) =>
              FavoritesTableCompanion.insert(
            id: id,
            wordId: wordId,
            isFavorited: isFavorited,
            learningStatus: learningStatus,
            reviewCount: reviewCount,
            correctCount: correctCount,
            incorrectCount: incorrectCount,
            memoryStrength: memoryStrength,
            nextReviewAt: nextReviewAt,
            reviewInterval: reviewInterval,
            easeFactor: easeFactor,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastReviewedAt: lastReviewedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$FavoritesTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({wordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (wordId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.wordId,
                    referencedTable:
                        $$FavoritesTableTableReferences._wordIdTable(db),
                    referencedColumn:
                        $$FavoritesTableTableReferences._wordIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$FavoritesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FavoritesTableTable,
    FavoritesTableData,
    $$FavoritesTableTableFilterComposer,
    $$FavoritesTableTableOrderingComposer,
    $$FavoritesTableTableAnnotationComposer,
    $$FavoritesTableTableCreateCompanionBuilder,
    $$FavoritesTableTableUpdateCompanionBuilder,
    (FavoritesTableData, $$FavoritesTableTableReferences),
    FavoritesTableData,
    PrefetchHooks Function({bool wordId})>;
typedef $$SearchHistoryTableTableCreateCompanionBuilder
    = SearchHistoryTableCompanion Function({
  Value<int> id,
  required String userId,
  required String query,
  Value<int> resultCount,
  Value<DateTime> timestamp,
});
typedef $$SearchHistoryTableTableUpdateCompanionBuilder
    = SearchHistoryTableCompanion Function({
  Value<int> id,
  Value<String> userId,
  Value<String> query,
  Value<int> resultCount,
  Value<DateTime> timestamp,
});

final class $$SearchHistoryTableTableReferences extends BaseReferences<
    _$AppDatabase, $SearchHistoryTableTable, SearchHistoryTableData> {
  $$SearchHistoryTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $UsersTableTable _userIdTable(_$AppDatabase db) =>
      db.usersTable.createAlias(
          $_aliasNameGenerator(db.searchHistoryTable.userId, db.usersTable.id));

  $$UsersTableTableProcessedTableManager? get userId {
    if ($_item.userId == null) return null;
    final manager = $$UsersTableTableTableManager($_db, $_db.usersTable)
        .filter((f) => f.id($_item.userId!));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SearchHistoryTableTableFilterComposer
    extends Composer<_$AppDatabase, $SearchHistoryTableTable> {
  $$SearchHistoryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get query => $composableBuilder(
      column: $table.query, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get resultCount => $composableBuilder(
      column: $table.resultCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  $$UsersTableTableFilterComposer get userId {
    final $$UsersTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.usersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableTableFilterComposer(
              $db: $db,
              $table: $db.usersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SearchHistoryTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SearchHistoryTableTable> {
  $$SearchHistoryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get query => $composableBuilder(
      column: $table.query, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get resultCount => $composableBuilder(
      column: $table.resultCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  $$UsersTableTableOrderingComposer get userId {
    final $$UsersTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.usersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableTableOrderingComposer(
              $db: $db,
              $table: $db.usersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SearchHistoryTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SearchHistoryTableTable> {
  $$SearchHistoryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get query =>
      $composableBuilder(column: $table.query, builder: (column) => column);

  GeneratedColumn<int> get resultCount => $composableBuilder(
      column: $table.resultCount, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  $$UsersTableTableAnnotationComposer get userId {
    final $$UsersTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.usersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableTableAnnotationComposer(
              $db: $db,
              $table: $db.usersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SearchHistoryTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SearchHistoryTableTable,
    SearchHistoryTableData,
    $$SearchHistoryTableTableFilterComposer,
    $$SearchHistoryTableTableOrderingComposer,
    $$SearchHistoryTableTableAnnotationComposer,
    $$SearchHistoryTableTableCreateCompanionBuilder,
    $$SearchHistoryTableTableUpdateCompanionBuilder,
    (SearchHistoryTableData, $$SearchHistoryTableTableReferences),
    SearchHistoryTableData,
    PrefetchHooks Function({bool userId})> {
  $$SearchHistoryTableTableTableManager(
      _$AppDatabase db, $SearchHistoryTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SearchHistoryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SearchHistoryTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SearchHistoryTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> query = const Value.absent(),
            Value<int> resultCount = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
          }) =>
              SearchHistoryTableCompanion(
            id: id,
            userId: userId,
            query: query,
            resultCount: resultCount,
            timestamp: timestamp,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String userId,
            required String query,
            Value<int> resultCount = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
          }) =>
              SearchHistoryTableCompanion.insert(
            id: id,
            userId: userId,
            query: query,
            resultCount: resultCount,
            timestamp: timestamp,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SearchHistoryTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$SearchHistoryTableTableReferences._userIdTable(db),
                    referencedColumn:
                        $$SearchHistoryTableTableReferences._userIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SearchHistoryTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SearchHistoryTableTable,
    SearchHistoryTableData,
    $$SearchHistoryTableTableFilterComposer,
    $$SearchHistoryTableTableOrderingComposer,
    $$SearchHistoryTableTableAnnotationComposer,
    $$SearchHistoryTableTableCreateCompanionBuilder,
    $$SearchHistoryTableTableUpdateCompanionBuilder,
    (SearchHistoryTableData, $$SearchHistoryTableTableReferences),
    SearchHistoryTableData,
    PrefetchHooks Function({bool userId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WordsTableTableTableManager get wordsTable =>
      $$WordsTableTableTableManager(_db, _db.wordsTable);
  $$UsersTableTableTableManager get usersTable =>
      $$UsersTableTableTableManager(_db, _db.usersTable);
  $$FavoritesTableTableTableManager get favoritesTable =>
      $$FavoritesTableTableTableManager(_db, _db.favoritesTable);
  $$SearchHistoryTableTableTableManager get searchHistoryTable =>
      $$SearchHistoryTableTableTableManager(_db, _db.searchHistoryTable);
}
