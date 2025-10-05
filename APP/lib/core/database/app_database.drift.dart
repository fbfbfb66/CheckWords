// ignore_for_file: type=lint
part of 'app_database.dart';

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
  static const VerificationMeta _wordMeta = const VerificationMeta('word');
  @override
  late final GeneratedColumn<String> word = GeneratedColumn<String>(
      'word', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _lemmaMeta = const VerificationMeta('lemma');
  @override
  late final GeneratedColumn<String> lemma = GeneratedColumn<String>(
      'lemma', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _partsOfSpeechMeta =
      const VerificationMeta('partsOfSpeech');
  @override
  late final GeneratedColumn<String> partsOfSpeech = GeneratedColumn<String>(
      'parts_of_speech', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _posMeaningsMeta =
      const VerificationMeta('posMeanings');
  @override
  late final GeneratedColumn<String> posMeanings = GeneratedColumn<String>(
      'pos_meanings', aliasedName, false,
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
  static const VerificationMeta _sentencesMeta =
      const VerificationMeta('sentences');
  @override
  late final GeneratedColumn<String> sentences = GeneratedColumn<String>(
      'sentences', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _pronunciationMeta =
      const VerificationMeta('pronunciation');
  @override
  late final GeneratedColumn<String> pronunciation = GeneratedColumn<String>(
      'pronunciation', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _frequencyMeta =
      const VerificationMeta('frequency');
  @override
  late final GeneratedColumn<int> frequency = GeneratedColumn<int>(
      'frequency', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
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
  static const VerificationMeta _antonymsMeta =
      const VerificationMeta('antonyms');
  @override
  late final GeneratedColumn<String> antonyms = GeneratedColumn<String>(
      'antonyms', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
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
        word,
        lemma,
        partsOfSpeech,
        posMeanings,
        phrases,
        sentences,
        pronunciation,
        level,
        frequency,
        tags,
        synonyms,
        antonyms,
        content,
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
    if (data.containsKey('word')) {
      context.handle(
          _wordMeta, word.isAcceptableOrUnknown(data['word']!, _wordMeta));
    } else if (isInserting) {
      context.missing(_wordMeta);
    }
    if (data.containsKey('lemma')) {
      context.handle(
          _lemmaMeta, lemma.isAcceptableOrUnknown(data['lemma']!, _lemmaMeta));
    }
    if (data.containsKey('parts_of_speech')) {
      context.handle(
          _partsOfSpeechMeta,
          partsOfSpeech.isAcceptableOrUnknown(
              data['parts_of_speech']!, _partsOfSpeechMeta));
    }
    if (data.containsKey('pos_meanings')) {
      context.handle(
          _posMeaningsMeta,
          posMeanings.isAcceptableOrUnknown(
              data['pos_meanings']!, _posMeaningsMeta));
    }
    if (data.containsKey('phrases')) {
      context.handle(_phrasesMeta,
          phrases.isAcceptableOrUnknown(data['phrases']!, _phrasesMeta));
    }
    if (data.containsKey('sentences')) {
      context.handle(_sentencesMeta,
          sentences.isAcceptableOrUnknown(data['sentences']!, _sentencesMeta));
    }
    if (data.containsKey('pronunciation')) {
      context.handle(
          _pronunciationMeta,
          pronunciation.isAcceptableOrUnknown(
              data['pronunciation']!, _pronunciationMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    }
    if (data.containsKey('frequency')) {
      context.handle(_frequencyMeta,
          frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    if (data.containsKey('synonyms')) {
      context.handle(_synonymsMeta,
          synonyms.isAcceptableOrUnknown(data['synonyms']!, _synonymsMeta));
    }
    if (data.containsKey('antonyms')) {
      context.handle(_antonymsMeta,
          antonyms.isAcceptableOrUnknown(data['antonyms']!, _antonymsMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
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
        {word},
      ];
  @override
  WordsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WordsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      word: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}word'])!,
      lemma: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lemma']),
      partsOfSpeech: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}parts_of_speech'])!,
      posMeanings: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pos_meanings'])!,
      phrases: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phrases'])!,
      sentences: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sentences'])!,
      pronunciation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pronunciation'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level']),
      frequency: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}frequency'])!,
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      synonyms: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}synonyms'])!,
      antonyms: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}antonyms'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
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

  /// 单词本身
  final String word;

  /// 词干/原形
  final String? lemma;

  /// 词性列表 (JSON: ["noun", "verb"])
  final String partsOfSpeech;

  /// 词性含义 (JSON格式)
  final String posMeanings;

  /// 例句短语 (JSON格式)
  final String phrases;

  /// 例句 (JSON格式)
  final String sentences;

  /// 音标和音频 (JSON格式)
  final String pronunciation;

  /// CEFR等级 (A1, A2, B1, B2, C1, C2)
  final String? level;

  /// 词频 (用于排序)
  final int frequency;

  /// 标签 (JSON数组: ["academic", "business"])
  final String tags;

  /// 同义词 (JSON数组)
  final String synonyms;

  /// 反义词 (JSON数组)
  final String antonyms;

  /// 搜索用的文本内容 (包含单词、含义、例句等)
  final String content;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;
  const WordsTableData(
      {required this.id,
      required this.word,
      this.lemma,
      required this.partsOfSpeech,
      required this.posMeanings,
      required this.phrases,
      required this.sentences,
      required this.pronunciation,
      this.level,
      required this.frequency,
      required this.tags,
      required this.synonyms,
      required this.antonyms,
      required this.content,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['word'] = Variable<String>(word);
    if (!nullToAbsent || lemma != null) {
      map['lemma'] = Variable<String>(lemma);
    }
    map['parts_of_speech'] = Variable<String>(partsOfSpeech);
    map['pos_meanings'] = Variable<String>(posMeanings);
    map['phrases'] = Variable<String>(phrases);
    map['sentences'] = Variable<String>(sentences);
    map['pronunciation'] = Variable<String>(pronunciation);
    if (!nullToAbsent || level != null) {
      map['level'] = Variable<String>(level);
    }
    map['frequency'] = Variable<int>(frequency);
    map['tags'] = Variable<String>(tags);
    map['synonyms'] = Variable<String>(synonyms);
    map['antonyms'] = Variable<String>(antonyms);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WordsTableCompanion toCompanion(bool nullToAbsent) {
    return WordsTableCompanion(
      id: Value(id),
      word: Value(word),
      lemma:
          lemma == null && nullToAbsent ? const Value.absent() : Value(lemma),
      partsOfSpeech: Value(partsOfSpeech),
      posMeanings: Value(posMeanings),
      phrases: Value(phrases),
      sentences: Value(sentences),
      pronunciation: Value(pronunciation),
      level:
          level == null && nullToAbsent ? const Value.absent() : Value(level),
      frequency: Value(frequency),
      tags: Value(tags),
      synonyms: Value(synonyms),
      antonyms: Value(antonyms),
      content: Value(content),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WordsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WordsTableData(
      id: serializer.fromJson<int>(json['id']),
      word: serializer.fromJson<String>(json['word']),
      lemma: serializer.fromJson<String?>(json['lemma']),
      partsOfSpeech: serializer.fromJson<String>(json['partsOfSpeech']),
      posMeanings: serializer.fromJson<String>(json['posMeanings']),
      phrases: serializer.fromJson<String>(json['phrases']),
      sentences: serializer.fromJson<String>(json['sentences']),
      pronunciation: serializer.fromJson<String>(json['pronunciation']),
      level: serializer.fromJson<String?>(json['level']),
      frequency: serializer.fromJson<int>(json['frequency']),
      tags: serializer.fromJson<String>(json['tags']),
      synonyms: serializer.fromJson<String>(json['synonyms']),
      antonyms: serializer.fromJson<String>(json['antonyms']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'word': serializer.toJson<String>(word),
      'lemma': serializer.toJson<String?>(lemma),
      'partsOfSpeech': serializer.toJson<String>(partsOfSpeech),
      'posMeanings': serializer.toJson<String>(posMeanings),
      'phrases': serializer.toJson<String>(phrases),
      'sentences': serializer.toJson<String>(sentences),
      'pronunciation': serializer.toJson<String>(pronunciation),
      'level': serializer.toJson<String?>(level),
      'frequency': serializer.toJson<int>(frequency),
      'tags': serializer.toJson<String>(tags),
      'synonyms': serializer.toJson<String>(synonyms),
      'antonyms': serializer.toJson<String>(antonyms),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WordsTableData copyWith(
          {int? id,
          String? word,
          Value<String?> lemma = const Value.absent(),
          String? partsOfSpeech,
          String? posMeanings,
          String? phrases,
          String? sentences,
          String? pronunciation,
          Value<String?> level = const Value.absent(),
          int? frequency,
          String? tags,
          String? synonyms,
          String? antonyms,
          String? content,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      WordsTableData(
        id: id ?? this.id,
        word: word ?? this.word,
        lemma: lemma.present ? lemma.value : this.lemma,
        partsOfSpeech: partsOfSpeech ?? this.partsOfSpeech,
        posMeanings: posMeanings ?? this.posMeanings,
        phrases: phrases ?? this.phrases,
        sentences: sentences ?? this.sentences,
        pronunciation: pronunciation ?? this.pronunciation,
        level: level.present ? level.value : this.level,
        frequency: frequency ?? this.frequency,
        tags: tags ?? this.tags,
        synonyms: synonyms ?? this.synonyms,
        antonyms: antonyms ?? this.antonyms,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  WordsTableData copyWithCompanion(WordsTableCompanion data) {
    return WordsTableData(
      id: data.id.present ? data.id.value : this.id,
      word: data.word.present ? data.word.value : this.word,
      lemma: data.lemma.present ? data.lemma.value : this.lemma,
      partsOfSpeech: data.partsOfSpeech.present
          ? data.partsOfSpeech.value
          : this.partsOfSpeech,
      posMeanings:
          data.posMeanings.present ? data.posMeanings.value : this.posMeanings,
      phrases: data.phrases.present ? data.phrases.value : this.phrases,
      sentences: data.sentences.present ? data.sentences.value : this.sentences,
      pronunciation: data.pronunciation.present
          ? data.pronunciation.value
          : this.pronunciation,
      level: data.level.present ? data.level.value : this.level,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      tags: data.tags.present ? data.tags.value : this.tags,
      synonyms: data.synonyms.present ? data.synonyms.value : this.synonyms,
      antonyms: data.antonyms.present ? data.antonyms.value : this.antonyms,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WordsTableData(')
          ..write('id: $id, ')
          ..write('word: $word, ')
          ..write('lemma: $lemma, ')
          ..write('partsOfSpeech: $partsOfSpeech, ')
          ..write('posMeanings: $posMeanings, ')
          ..write('phrases: $phrases, ')
          ..write('sentences: $sentences, ')
          ..write('pronunciation: $pronunciation, ')
          ..write('level: $level, ')
          ..write('frequency: $frequency, ')
          ..write('tags: $tags, ')
          ..write('synonyms: $synonyms, ')
          ..write('antonyms: $antonyms, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      word,
      lemma,
      partsOfSpeech,
      posMeanings,
      phrases,
      sentences,
      pronunciation,
      level,
      frequency,
      tags,
      synonyms,
      antonyms,
      content,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WordsTableData &&
          other.id == this.id &&
          other.word == this.word &&
          other.lemma == this.lemma &&
          other.partsOfSpeech == this.partsOfSpeech &&
          other.posMeanings == this.posMeanings &&
          other.phrases == this.phrases &&
          other.sentences == this.sentences &&
          other.pronunciation == this.pronunciation &&
          other.level == this.level &&
          other.frequency == this.frequency &&
          other.tags == this.tags &&
          other.synonyms == this.synonyms &&
          other.antonyms == this.antonyms &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WordsTableCompanion extends UpdateCompanion<WordsTableData> {
  final Value<int> id;
  final Value<String> word;
  final Value<String?> lemma;
  final Value<String> partsOfSpeech;
  final Value<String> posMeanings;
  final Value<String> phrases;
  final Value<String> sentences;
  final Value<String> pronunciation;
  final Value<String?> level;
  final Value<int> frequency;
  final Value<String> tags;
  final Value<String> synonyms;
  final Value<String> antonyms;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const WordsTableCompanion({
    this.id = const Value.absent(),
    this.word = const Value.absent(),
    this.lemma = const Value.absent(),
    this.partsOfSpeech = const Value.absent(),
    this.posMeanings = const Value.absent(),
    this.phrases = const Value.absent(),
    this.sentences = const Value.absent(),
    this.pronunciation = const Value.absent(),
    this.level = const Value.absent(),
    this.frequency = const Value.absent(),
    this.tags = const Value.absent(),
    this.synonyms = const Value.absent(),
    this.antonyms = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  WordsTableCompanion.insert({
    this.id = const Value.absent(),
    required String word,
    this.lemma = const Value.absent(),
    this.partsOfSpeech = const Value.absent(),
    this.posMeanings = const Value.absent(),
    this.phrases = const Value.absent(),
    this.sentences = const Value.absent(),
    this.pronunciation = const Value.absent(),
    this.level = const Value.absent(),
    this.frequency = const Value.absent(),
    this.tags = const Value.absent(),
    this.synonyms = const Value.absent(),
    this.antonyms = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : word = Value(word);
  static Insertable<WordsTableData> custom({
    Expression<int>? id,
    Expression<String>? word,
    Expression<String>? lemma,
    Expression<String>? partsOfSpeech,
    Expression<String>? posMeanings,
    Expression<String>? phrases,
    Expression<String>? sentences,
    Expression<String>? pronunciation,
    Expression<String>? level,
    Expression<int>? frequency,
    Expression<String>? tags,
    Expression<String>? synonyms,
    Expression<String>? antonyms,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (word != null) 'word': word,
      if (lemma != null) 'lemma': lemma,
      if (partsOfSpeech != null) 'parts_of_speech': partsOfSpeech,
      if (posMeanings != null) 'pos_meanings': posMeanings,
      if (phrases != null) 'phrases': phrases,
      if (sentences != null) 'sentences': sentences,
      if (pronunciation != null) 'pronunciation': pronunciation,
      if (level != null) 'level': level,
      if (frequency != null) 'frequency': frequency,
      if (tags != null) 'tags': tags,
      if (synonyms != null) 'synonyms': synonyms,
      if (antonyms != null) 'antonyms': antonyms,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  WordsTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? word,
      Value<String?>? lemma,
      Value<String>? partsOfSpeech,
      Value<String>? posMeanings,
      Value<String>? phrases,
      Value<String>? sentences,
      Value<String>? pronunciation,
      Value<String?>? level,
      Value<int>? frequency,
      Value<String>? tags,
      Value<String>? synonyms,
      Value<String>? antonyms,
      Value<String>? content,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return WordsTableCompanion(
      id: id ?? this.id,
      word: word ?? this.word,
      lemma: lemma ?? this.lemma,
      partsOfSpeech: partsOfSpeech ?? this.partsOfSpeech,
      posMeanings: posMeanings ?? this.posMeanings,
      phrases: phrases ?? this.phrases,
      sentences: sentences ?? this.sentences,
      pronunciation: pronunciation ?? this.pronunciation,
      level: level ?? this.level,
      frequency: frequency ?? this.frequency,
      tags: tags ?? this.tags,
      synonyms: synonyms ?? this.synonyms,
      antonyms: antonyms ?? this.antonyms,
      content: content ?? this.content,
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
    if (word.present) {
      map['word'] = Variable<String>(word.value);
    }
    if (lemma.present) {
      map['lemma'] = Variable<String>(lemma.value);
    }
    if (partsOfSpeech.present) {
      map['parts_of_speech'] = Variable<String>(partsOfSpeech.value);
    }
    if (posMeanings.present) {
      map['pos_meanings'] = Variable<String>(posMeanings.value);
    }
    if (phrases.present) {
      map['phrases'] = Variable<String>(phrases.value);
    }
    if (sentences.present) {
      map['sentences'] = Variable<String>(sentences.value);
    }
    if (pronunciation.present) {
      map['pronunciation'] = Variable<String>(pronunciation.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<int>(frequency.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (synonyms.present) {
      map['synonyms'] = Variable<String>(synonyms.value);
    }
    if (antonyms.present) {
      map['antonyms'] = Variable<String>(antonyms.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
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
          ..write('word: $word, ')
          ..write('lemma: $lemma, ')
          ..write('partsOfSpeech: $partsOfSpeech, ')
          ..write('posMeanings: $posMeanings, ')
          ..write('phrases: $phrases, ')
          ..write('sentences: $sentences, ')
          ..write('pronunciation: $pronunciation, ')
          ..write('level: $level, ')
          ..write('frequency: $frequency, ')
          ..write('tags: $tags, ')
          ..write('synonyms: $synonyms, ')
          ..write('antonyms: $antonyms, ')
          ..write('content: $content, ')
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
      requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 5, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _passwordHashMeta =
      const VerificationMeta('passwordHash');
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
      'password_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _avatarPathMeta =
      const VerificationMeta('avatarPath');
  @override
  late final GeneratedColumn<String> avatarPath = GeneratedColumn<String>(
      'avatar_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailVerifiedMeta =
      const VerificationMeta('emailVerified');
  @override
  late final GeneratedColumn<bool> emailVerified = GeneratedColumn<bool>(
      'email_verified', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("email_verified" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _preferencesMeta =
      const VerificationMeta('preferences');
  @override
  late final GeneratedColumn<String> preferences = GeneratedColumn<String>(
      'preferences', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
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
  static const VerificationMeta _lastLoginAtMeta =
      const VerificationMeta('lastLoginAt');
  @override
  late final GeneratedColumn<DateTime> lastLoginAt = GeneratedColumn<DateTime>(
      'last_login_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        email,
        passwordHash,
        avatarPath,
        emailVerified,
        preferences,
        createdAt,
        updatedAt,
        lastLoginAt
      ];
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
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
          _passwordHashMeta,
          passwordHash.isAcceptableOrUnknown(
              data['password_hash']!, _passwordHashMeta));
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    if (data.containsKey('avatar_path')) {
      context.handle(
          _avatarPathMeta,
          avatarPath.isAcceptableOrUnknown(
              data['avatar_path']!, _avatarPathMeta));
    }
    if (data.containsKey('email_verified')) {
      context.handle(
          _emailVerifiedMeta,
          emailVerified.isAcceptableOrUnknown(
              data['email_verified']!, _emailVerifiedMeta));
    }
    if (data.containsKey('preferences')) {
      context.handle(
          _preferencesMeta,
          preferences.isAcceptableOrUnknown(
              data['preferences']!, _preferencesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('last_login_at')) {
      context.handle(
          _lastLoginAtMeta,
          lastLoginAt.isAcceptableOrUnknown(
              data['last_login_at']!, _lastLoginAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {email},
      ];
  @override
  UsersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsersTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      passwordHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password_hash'])!,
      avatarPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_path']),
      emailVerified: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}email_verified'])!,
      preferences: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}preferences'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      lastLoginAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_login_at']),
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

  /// 邮箱
  final String email;

  /// 密码哈希 (使用bcrypt等安全哈希)
  final String passwordHash;

  /// 头像路径 (本地文件路径或URL)
  final String? avatarPath;

  /// 是否已验证邮箱
  final bool emailVerified;

  /// 用户偏好设置 (JSON格式)
  final String preferences;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;

  /// 最后登录时间
  final DateTime? lastLoginAt;
  const UsersTableData(
      {required this.id,
      required this.name,
      required this.email,
      required this.passwordHash,
      this.avatarPath,
      required this.emailVerified,
      required this.preferences,
      required this.createdAt,
      required this.updatedAt,
      this.lastLoginAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    map['password_hash'] = Variable<String>(passwordHash);
    if (!nullToAbsent || avatarPath != null) {
      map['avatar_path'] = Variable<String>(avatarPath);
    }
    map['email_verified'] = Variable<bool>(emailVerified);
    map['preferences'] = Variable<String>(preferences);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lastLoginAt != null) {
      map['last_login_at'] = Variable<DateTime>(lastLoginAt);
    }
    return map;
  }

  UsersTableCompanion toCompanion(bool nullToAbsent) {
    return UsersTableCompanion(
      id: Value(id),
      name: Value(name),
      email: Value(email),
      passwordHash: Value(passwordHash),
      avatarPath: avatarPath == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarPath),
      emailVerified: Value(emailVerified),
      preferences: Value(preferences),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastLoginAt: lastLoginAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLoginAt),
    );
  }

  factory UsersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsersTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
      avatarPath: serializer.fromJson<String?>(json['avatarPath']),
      emailVerified: serializer.fromJson<bool>(json['emailVerified']),
      preferences: serializer.fromJson<String>(json['preferences']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastLoginAt: serializer.fromJson<DateTime?>(json['lastLoginAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'passwordHash': serializer.toJson<String>(passwordHash),
      'avatarPath': serializer.toJson<String?>(avatarPath),
      'emailVerified': serializer.toJson<bool>(emailVerified),
      'preferences': serializer.toJson<String>(preferences),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastLoginAt': serializer.toJson<DateTime?>(lastLoginAt),
    };
  }

  UsersTableData copyWith(
          {String? id,
          String? name,
          String? email,
          String? passwordHash,
          Value<String?> avatarPath = const Value.absent(),
          bool? emailVerified,
          String? preferences,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> lastLoginAt = const Value.absent()}) =>
      UsersTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        passwordHash: passwordHash ?? this.passwordHash,
        avatarPath: avatarPath.present ? avatarPath.value : this.avatarPath,
        emailVerified: emailVerified ?? this.emailVerified,
        preferences: preferences ?? this.preferences,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastLoginAt: lastLoginAt.present ? lastLoginAt.value : this.lastLoginAt,
      );
  UsersTableData copyWithCompanion(UsersTableCompanion data) {
    return UsersTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      avatarPath:
          data.avatarPath.present ? data.avatarPath.value : this.avatarPath,
      emailVerified: data.emailVerified.present
          ? data.emailVerified.value
          : this.emailVerified,
      preferences:
          data.preferences.present ? data.preferences.value : this.preferences,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastLoginAt:
          data.lastLoginAt.present ? data.lastLoginAt.value : this.lastLoginAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsersTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('emailVerified: $emailVerified, ')
          ..write('preferences: $preferences, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastLoginAt: $lastLoginAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, email, passwordHash, avatarPath,
      emailVerified, preferences, createdAt, updatedAt, lastLoginAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsersTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.passwordHash == this.passwordHash &&
          other.avatarPath == this.avatarPath &&
          other.emailVerified == this.emailVerified &&
          other.preferences == this.preferences &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastLoginAt == this.lastLoginAt);
}

class UsersTableCompanion extends UpdateCompanion<UsersTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> email;
  final Value<String> passwordHash;
  final Value<String?> avatarPath;
  final Value<bool> emailVerified;
  final Value<String> preferences;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> lastLoginAt;
  final Value<int> rowid;
  const UsersTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.emailVerified = const Value.absent(),
    this.preferences = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastLoginAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersTableCompanion.insert({
    required String id,
    required String name,
    required String email,
    required String passwordHash,
    this.avatarPath = const Value.absent(),
    this.emailVerified = const Value.absent(),
    this.preferences = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastLoginAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        email = Value(email),
        passwordHash = Value(passwordHash);
  static Insertable<UsersTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? passwordHash,
    Expression<String>? avatarPath,
    Expression<bool>? emailVerified,
    Expression<String>? preferences,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastLoginAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (avatarPath != null) 'avatar_path': avatarPath,
      if (emailVerified != null) 'email_verified': emailVerified,
      if (preferences != null) 'preferences': preferences,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastLoginAt != null) 'last_login_at': lastLoginAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? email,
      Value<String>? passwordHash,
      Value<String?>? avatarPath,
      Value<bool>? emailVerified,
      Value<String>? preferences,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? lastLoginAt,
      Value<int>? rowid}) {
    return UsersTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      avatarPath: avatarPath ?? this.avatarPath,
      emailVerified: emailVerified ?? this.emailVerified,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
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
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (avatarPath.present) {
      map['avatar_path'] = Variable<String>(avatarPath.value);
    }
    if (emailVerified.present) {
      map['email_verified'] = Variable<bool>(emailVerified.value);
    }
    if (preferences.present) {
      map['preferences'] = Variable<String>(preferences.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastLoginAt.present) {
      map['last_login_at'] = Variable<DateTime>(lastLoginAt.value);
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
          ..write('email: $email, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('emailVerified: $emailVerified, ')
          ..write('preferences: $preferences, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastLoginAt: $lastLoginAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserWordsTableTable extends UserWordsTable
    with TableInfo<$UserWordsTableTable, UserWordsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserWordsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
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
        userId,
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
        tags,
        createdAt,
        updatedAt,
        lastReviewedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_words_table';
  @override
  VerificationContext validateIntegrity(Insertable<UserWordsTableData> instance,
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
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
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
        {userId, wordId},
      ];
  @override
  UserWordsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserWordsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
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
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      lastReviewedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_reviewed_at']),
    );
  }

  @override
  $UserWordsTableTable createAlias(String alias) {
    return $UserWordsTableTable(attachedDatabase, alias);
  }
}

class UserWordsTableData extends DataClass
    implements Insertable<UserWordsTableData> {
  /// 主键ID
  final int id;

  /// 用户ID
  final String userId;

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

  /// 用户笔记
  final String notes;

  /// 标签 (JSON数组)
  final String tags;

  /// 添加到收藏的时间
  final DateTime createdAt;

  /// 最后更新时间
  final DateTime updatedAt;

  /// 最后复习时间
  final DateTime? lastReviewedAt;
  const UserWordsTableData(
      {required this.id,
      required this.userId,
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
      required this.tags,
      required this.createdAt,
      required this.updatedAt,
      this.lastReviewedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
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
    map['tags'] = Variable<String>(tags);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lastReviewedAt != null) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt);
    }
    return map;
  }

  UserWordsTableCompanion toCompanion(bool nullToAbsent) {
    return UserWordsTableCompanion(
      id: Value(id),
      userId: Value(userId),
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
      tags: Value(tags),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastReviewedAt: lastReviewedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewedAt),
    );
  }

  factory UserWordsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserWordsTableData(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
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
      tags: serializer.fromJson<String>(json['tags']),
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
      'userId': serializer.toJson<String>(userId),
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
      'tags': serializer.toJson<String>(tags),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastReviewedAt': serializer.toJson<DateTime?>(lastReviewedAt),
    };
  }

  UserWordsTableData copyWith(
          {int? id,
          String? userId,
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
          String? tags,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> lastReviewedAt = const Value.absent()}) =>
      UserWordsTableData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
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
        tags: tags ?? this.tags,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastReviewedAt:
            lastReviewedAt.present ? lastReviewedAt.value : this.lastReviewedAt,
      );
  UserWordsTableData copyWithCompanion(UserWordsTableCompanion data) {
    return UserWordsTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
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
      tags: data.tags.present ? data.tags.value : this.tags,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastReviewedAt: data.lastReviewedAt.present
          ? data.lastReviewedAt.value
          : this.lastReviewedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserWordsTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
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
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastReviewedAt: $lastReviewedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userId,
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
      tags,
      createdAt,
      updatedAt,
      lastReviewedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserWordsTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
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
          other.tags == this.tags &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastReviewedAt == this.lastReviewedAt);
}

class UserWordsTableCompanion extends UpdateCompanion<UserWordsTableData> {
  final Value<int> id;
  final Value<String> userId;
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
  final Value<String> tags;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> lastReviewedAt;
  const UserWordsTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
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
    this.tags = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
  });
  UserWordsTableCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
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
    this.tags = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
  })  : userId = Value(userId),
        wordId = Value(wordId);
  static Insertable<UserWordsTableData> custom({
    Expression<int>? id,
    Expression<String>? userId,
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
    Expression<String>? tags,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastReviewedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
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
      if (tags != null) 'tags': tags,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastReviewedAt != null) 'last_reviewed_at': lastReviewedAt,
    });
  }

  UserWordsTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? userId,
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
      Value<String>? tags,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? lastReviewedAt}) {
    return UserWordsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
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
      tags: tags ?? this.tags,
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
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
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
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
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
    return (StringBuffer('UserWordsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
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
          ..write('tags: $tags, ')
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
  late final $UserWordsTableTable userWordsTable = $UserWordsTableTable(this);
  late final $SearchHistoryTableTable searchHistoryTable =
      $SearchHistoryTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [wordsTable, usersTable, userWordsTable, searchHistoryTable];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('users_table',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('user_words_table', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('words_table',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('user_words_table', kind: UpdateKind.delete),
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
  required String word,
  Value<String?> lemma,
  Value<String> partsOfSpeech,
  Value<String> posMeanings,
  Value<String> phrases,
  Value<String> sentences,
  Value<String> pronunciation,
  Value<String?> level,
  Value<int> frequency,
  Value<String> tags,
  Value<String> synonyms,
  Value<String> antonyms,
  Value<String> content,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$WordsTableTableUpdateCompanionBuilder = WordsTableCompanion Function({
  Value<int> id,
  Value<String> word,
  Value<String?> lemma,
  Value<String> partsOfSpeech,
  Value<String> posMeanings,
  Value<String> phrases,
  Value<String> sentences,
  Value<String> pronunciation,
  Value<String?> level,
  Value<int> frequency,
  Value<String> tags,
  Value<String> synonyms,
  Value<String> antonyms,
  Value<String> content,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$WordsTableTableReferences
    extends BaseReferences<_$AppDatabase, $WordsTableTable, WordsTableData> {
  $$WordsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UserWordsTableTable, List<UserWordsTableData>>
      _userWordsTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.userWordsTable,
              aliasName: $_aliasNameGenerator(
                  db.wordsTable.id, db.userWordsTable.wordId));

  $$UserWordsTableTableProcessedTableManager get userWordsTableRefs {
    final manager = $$UserWordsTableTableTableManager($_db, $_db.userWordsTable)
        .filter((f) => f.wordId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_userWordsTableRefsTable($_db));
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

  ColumnFilters<String> get word => $composableBuilder(
      column: $table.word, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lemma => $composableBuilder(
      column: $table.lemma, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get partsOfSpeech => $composableBuilder(
      column: $table.partsOfSpeech, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get posMeanings => $composableBuilder(
      column: $table.posMeanings, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phrases => $composableBuilder(
      column: $table.phrases, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sentences => $composableBuilder(
      column: $table.sentences, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pronunciation => $composableBuilder(
      column: $table.pronunciation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get synonyms => $composableBuilder(
      column: $table.synonyms, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get antonyms => $composableBuilder(
      column: $table.antonyms, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> userWordsTableRefs(
      Expression<bool> Function($$UserWordsTableTableFilterComposer f) f) {
    final $$UserWordsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.userWordsTable,
        getReferencedColumn: (t) => t.wordId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UserWordsTableTableFilterComposer(
              $db: $db,
              $table: $db.userWordsTable,
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

  ColumnOrderings<String> get word => $composableBuilder(
      column: $table.word, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lemma => $composableBuilder(
      column: $table.lemma, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get partsOfSpeech => $composableBuilder(
      column: $table.partsOfSpeech,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get posMeanings => $composableBuilder(
      column: $table.posMeanings, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phrases => $composableBuilder(
      column: $table.phrases, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sentences => $composableBuilder(
      column: $table.sentences, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pronunciation => $composableBuilder(
      column: $table.pronunciation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get synonyms => $composableBuilder(
      column: $table.synonyms, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get antonyms => $composableBuilder(
      column: $table.antonyms, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

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

  GeneratedColumn<String> get word =>
      $composableBuilder(column: $table.word, builder: (column) => column);

  GeneratedColumn<String> get lemma =>
      $composableBuilder(column: $table.lemma, builder: (column) => column);

  GeneratedColumn<String> get partsOfSpeech => $composableBuilder(
      column: $table.partsOfSpeech, builder: (column) => column);

  GeneratedColumn<String> get posMeanings => $composableBuilder(
      column: $table.posMeanings, builder: (column) => column);

  GeneratedColumn<String> get phrases =>
      $composableBuilder(column: $table.phrases, builder: (column) => column);

  GeneratedColumn<String> get sentences =>
      $composableBuilder(column: $table.sentences, builder: (column) => column);

  GeneratedColumn<String> get pronunciation => $composableBuilder(
      column: $table.pronunciation, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get synonyms =>
      $composableBuilder(column: $table.synonyms, builder: (column) => column);

  GeneratedColumn<String> get antonyms =>
      $composableBuilder(column: $table.antonyms, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> userWordsTableRefs<T extends Object>(
      Expression<T> Function($$UserWordsTableTableAnnotationComposer a) f) {
    final $$UserWordsTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.userWordsTable,
        getReferencedColumn: (t) => t.wordId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UserWordsTableTableAnnotationComposer(
              $db: $db,
              $table: $db.userWordsTable,
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
    PrefetchHooks Function({bool userWordsTableRefs})> {
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
            Value<String> word = const Value.absent(),
            Value<String?> lemma = const Value.absent(),
            Value<String> partsOfSpeech = const Value.absent(),
            Value<String> posMeanings = const Value.absent(),
            Value<String> phrases = const Value.absent(),
            Value<String> sentences = const Value.absent(),
            Value<String> pronunciation = const Value.absent(),
            Value<String?> level = const Value.absent(),
            Value<int> frequency = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<String> synonyms = const Value.absent(),
            Value<String> antonyms = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              WordsTableCompanion(
            id: id,
            word: word,
            lemma: lemma,
            partsOfSpeech: partsOfSpeech,
            posMeanings: posMeanings,
            phrases: phrases,
            sentences: sentences,
            pronunciation: pronunciation,
            level: level,
            frequency: frequency,
            tags: tags,
            synonyms: synonyms,
            antonyms: antonyms,
            content: content,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String word,
            Value<String?> lemma = const Value.absent(),
            Value<String> partsOfSpeech = const Value.absent(),
            Value<String> posMeanings = const Value.absent(),
            Value<String> phrases = const Value.absent(),
            Value<String> sentences = const Value.absent(),
            Value<String> pronunciation = const Value.absent(),
            Value<String?> level = const Value.absent(),
            Value<int> frequency = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<String> synonyms = const Value.absent(),
            Value<String> antonyms = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              WordsTableCompanion.insert(
            id: id,
            word: word,
            lemma: lemma,
            partsOfSpeech: partsOfSpeech,
            posMeanings: posMeanings,
            phrases: phrases,
            sentences: sentences,
            pronunciation: pronunciation,
            level: level,
            frequency: frequency,
            tags: tags,
            synonyms: synonyms,
            antonyms: antonyms,
            content: content,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WordsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userWordsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (userWordsTableRefs) db.userWordsTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (userWordsTableRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$WordsTableTableReferences
                            ._userWordsTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WordsTableTableReferences(db, table, p0)
                                .userWordsTableRefs,
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
    PrefetchHooks Function({bool userWordsTableRefs})>;
typedef $$UsersTableTableCreateCompanionBuilder = UsersTableCompanion Function({
  required String id,
  required String name,
  required String email,
  required String passwordHash,
  Value<String?> avatarPath,
  Value<bool> emailVerified,
  Value<String> preferences,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> lastLoginAt,
  Value<int> rowid,
});
typedef $$UsersTableTableUpdateCompanionBuilder = UsersTableCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> email,
  Value<String> passwordHash,
  Value<String?> avatarPath,
  Value<bool> emailVerified,
  Value<String> preferences,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> lastLoginAt,
  Value<int> rowid,
});

final class $$UsersTableTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTableTable, UsersTableData> {
  $$UsersTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UserWordsTableTable, List<UserWordsTableData>>
      _userWordsTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.userWordsTable,
              aliasName: $_aliasNameGenerator(
                  db.usersTable.id, db.userWordsTable.userId));

  $$UserWordsTableTableProcessedTableManager get userWordsTableRefs {
    final manager = $$UserWordsTableTableTableManager($_db, $_db.userWordsTable)
        .filter((f) => f.userId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_userWordsTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

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

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get emailVerified => $composableBuilder(
      column: $table.emailVerified, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get preferences => $composableBuilder(
      column: $table.preferences, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastLoginAt => $composableBuilder(
      column: $table.lastLoginAt, builder: (column) => ColumnFilters(column));

  Expression<bool> userWordsTableRefs(
      Expression<bool> Function($$UserWordsTableTableFilterComposer f) f) {
    final $$UserWordsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.userWordsTable,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UserWordsTableTableFilterComposer(
              $db: $db,
              $table: $db.userWordsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

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

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get emailVerified => $composableBuilder(
      column: $table.emailVerified,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get preferences => $composableBuilder(
      column: $table.preferences, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastLoginAt => $composableBuilder(
      column: $table.lastLoginAt, builder: (column) => ColumnOrderings(column));
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

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash, builder: (column) => column);

  GeneratedColumn<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => column);

  GeneratedColumn<bool> get emailVerified => $composableBuilder(
      column: $table.emailVerified, builder: (column) => column);

  GeneratedColumn<String> get preferences => $composableBuilder(
      column: $table.preferences, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastLoginAt => $composableBuilder(
      column: $table.lastLoginAt, builder: (column) => column);

  Expression<T> userWordsTableRefs<T extends Object>(
      Expression<T> Function($$UserWordsTableTableAnnotationComposer a) f) {
    final $$UserWordsTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.userWordsTable,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UserWordsTableTableAnnotationComposer(
              $db: $db,
              $table: $db.userWordsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

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
    PrefetchHooks Function(
        {bool userWordsTableRefs, bool searchHistoryTableRefs})> {
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
            Value<String> email = const Value.absent(),
            Value<String> passwordHash = const Value.absent(),
            Value<String?> avatarPath = const Value.absent(),
            Value<bool> emailVerified = const Value.absent(),
            Value<String> preferences = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> lastLoginAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersTableCompanion(
            id: id,
            name: name,
            email: email,
            passwordHash: passwordHash,
            avatarPath: avatarPath,
            emailVerified: emailVerified,
            preferences: preferences,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastLoginAt: lastLoginAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String email,
            required String passwordHash,
            Value<String?> avatarPath = const Value.absent(),
            Value<bool> emailVerified = const Value.absent(),
            Value<String> preferences = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> lastLoginAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersTableCompanion.insert(
            id: id,
            name: name,
            email: email,
            passwordHash: passwordHash,
            avatarPath: avatarPath,
            emailVerified: emailVerified,
            preferences: preferences,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastLoginAt: lastLoginAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$UsersTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {userWordsTableRefs = false, searchHistoryTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (userWordsTableRefs) db.userWordsTable,
                if (searchHistoryTableRefs) db.searchHistoryTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (userWordsTableRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$UsersTableTableReferences
                            ._userWordsTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableTableReferences(db, table, p0)
                                .userWordsTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
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
    PrefetchHooks Function(
        {bool userWordsTableRefs, bool searchHistoryTableRefs})>;
typedef $$UserWordsTableTableCreateCompanionBuilder = UserWordsTableCompanion
    Function({
  Value<int> id,
  required String userId,
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
  Value<String> tags,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> lastReviewedAt,
});
typedef $$UserWordsTableTableUpdateCompanionBuilder = UserWordsTableCompanion
    Function({
  Value<int> id,
  Value<String> userId,
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
  Value<String> tags,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> lastReviewedAt,
});

final class $$UserWordsTableTableReferences extends BaseReferences<
    _$AppDatabase, $UserWordsTableTable, UserWordsTableData> {
  $$UserWordsTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $UsersTableTable _userIdTable(_$AppDatabase db) =>
      db.usersTable.createAlias(
          $_aliasNameGenerator(db.userWordsTable.userId, db.usersTable.id));

  $$UsersTableTableProcessedTableManager? get userId {
    if ($_item.userId == null) return null;
    final manager = $$UsersTableTableTableManager($_db, $_db.usersTable)
        .filter((f) => f.id($_item.userId!));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $WordsTableTable _wordIdTable(_$AppDatabase db) =>
      db.wordsTable.createAlias(
          $_aliasNameGenerator(db.userWordsTable.wordId, db.wordsTable.id));

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

class $$UserWordsTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserWordsTableTable> {
  $$UserWordsTableTableFilterComposer({
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

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastReviewedAt => $composableBuilder(
      column: $table.lastReviewedAt,
      builder: (column) => ColumnFilters(column));

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

class $$UserWordsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserWordsTableTable> {
  $$UserWordsTableTableOrderingComposer({
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

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastReviewedAt => $composableBuilder(
      column: $table.lastReviewedAt,
      builder: (column) => ColumnOrderings(column));

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

class $$UserWordsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserWordsTableTable> {
  $$UserWordsTableTableAnnotationComposer({
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

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReviewedAt => $composableBuilder(
      column: $table.lastReviewedAt, builder: (column) => column);

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

class $$UserWordsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserWordsTableTable,
    UserWordsTableData,
    $$UserWordsTableTableFilterComposer,
    $$UserWordsTableTableOrderingComposer,
    $$UserWordsTableTableAnnotationComposer,
    $$UserWordsTableTableCreateCompanionBuilder,
    $$UserWordsTableTableUpdateCompanionBuilder,
    (UserWordsTableData, $$UserWordsTableTableReferences),
    UserWordsTableData,
    PrefetchHooks Function({bool userId, bool wordId})> {
  $$UserWordsTableTableTableManager(
      _$AppDatabase db, $UserWordsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserWordsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserWordsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserWordsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
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
            Value<String> tags = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> lastReviewedAt = const Value.absent(),
          }) =>
              UserWordsTableCompanion(
            id: id,
            userId: userId,
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
            tags: tags,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastReviewedAt: lastReviewedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String userId,
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
            Value<String> tags = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> lastReviewedAt = const Value.absent(),
          }) =>
              UserWordsTableCompanion.insert(
            id: id,
            userId: userId,
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
            tags: tags,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastReviewedAt: lastReviewedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$UserWordsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false, wordId = false}) {
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
                        $$UserWordsTableTableReferences._userIdTable(db),
                    referencedColumn:
                        $$UserWordsTableTableReferences._userIdTable(db).id,
                  ) as T;
                }
                if (wordId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.wordId,
                    referencedTable:
                        $$UserWordsTableTableReferences._wordIdTable(db),
                    referencedColumn:
                        $$UserWordsTableTableReferences._wordIdTable(db).id,
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

typedef $$UserWordsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserWordsTableTable,
    UserWordsTableData,
    $$UserWordsTableTableFilterComposer,
    $$UserWordsTableTableOrderingComposer,
    $$UserWordsTableTableAnnotationComposer,
    $$UserWordsTableTableCreateCompanionBuilder,
    $$UserWordsTableTableUpdateCompanionBuilder,
    (UserWordsTableData, $$UserWordsTableTableReferences),
    UserWordsTableData,
    PrefetchHooks Function({bool userId, bool wordId})>;
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
  $$UserWordsTableTableTableManager get userWordsTable =>
      $$UserWordsTableTableTableManager(_db, _db.userWordsTable);
  $$SearchHistoryTableTableTableManager get searchHistoryTable =>
      $$SearchHistoryTableTableTableManager(_db, _db.searchHistoryTable);
}
