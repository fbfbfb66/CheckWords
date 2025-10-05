// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'word_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PosMeaning _$PosMeaningFromJson(Map<String, dynamic> json) {
  return _PosMeaning.fromJson(json);
}

/// @nodoc
mixin _$PosMeaning {
  String get pos => throw _privateConstructorUsedError;
  String get cn => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PosMeaningCopyWith<PosMeaning> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PosMeaningCopyWith<$Res> {
  factory $PosMeaningCopyWith(
          PosMeaning value, $Res Function(PosMeaning) then) =
      _$PosMeaningCopyWithImpl<$Res, PosMeaning>;
  @useResult
  $Res call({String pos, String cn});
}

/// @nodoc
class _$PosMeaningCopyWithImpl<$Res, $Val extends PosMeaning>
    implements $PosMeaningCopyWith<$Res> {
  _$PosMeaningCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pos = null,
    Object? cn = null,
  }) {
    return _then(_value.copyWith(
      pos: null == pos
          ? _value.pos
          : pos // ignore: cast_nullable_to_non_nullable
              as String,
      cn: null == cn
          ? _value.cn
          : cn // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PosMeaningImplCopyWith<$Res>
    implements $PosMeaningCopyWith<$Res> {
  factory _$$PosMeaningImplCopyWith(
          _$PosMeaningImpl value, $Res Function(_$PosMeaningImpl) then) =
      __$$PosMeaningImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String pos, String cn});
}

/// @nodoc
class __$$PosMeaningImplCopyWithImpl<$Res>
    extends _$PosMeaningCopyWithImpl<$Res, _$PosMeaningImpl>
    implements _$$PosMeaningImplCopyWith<$Res> {
  __$$PosMeaningImplCopyWithImpl(
      _$PosMeaningImpl _value, $Res Function(_$PosMeaningImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pos = null,
    Object? cn = null,
  }) {
    return _then(_$PosMeaningImpl(
      pos: null == pos
          ? _value.pos
          : pos // ignore: cast_nullable_to_non_nullable
              as String,
      cn: null == cn
          ? _value.cn
          : cn // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PosMeaningImpl implements _PosMeaning {
  const _$PosMeaningImpl({required this.pos, required this.cn});

  factory _$PosMeaningImpl.fromJson(Map<String, dynamic> json) =>
      _$$PosMeaningImplFromJson(json);

  @override
  final String pos;
  @override
  final String cn;

  @override
  String toString() {
    return 'PosMeaning(pos: $pos, cn: $cn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PosMeaningImpl &&
            (identical(other.pos, pos) || other.pos == pos) &&
            (identical(other.cn, cn) || other.cn == cn));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, pos, cn);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PosMeaningImplCopyWith<_$PosMeaningImpl> get copyWith =>
      __$$PosMeaningImplCopyWithImpl<_$PosMeaningImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PosMeaningImplToJson(
      this,
    );
  }
}

abstract class _PosMeaning implements PosMeaning {
  const factory _PosMeaning(
      {required final String pos, required final String cn}) = _$PosMeaningImpl;

  factory _PosMeaning.fromJson(Map<String, dynamic> json) =
      _$PosMeaningImpl.fromJson;

  @override
  String get pos;
  @override
  String get cn;
  @override
  @JsonKey(ignore: true)
  _$$PosMeaningImplCopyWith<_$PosMeaningImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Dialog _$DialogFromJson(Map<String, dynamic> json) {
  return _Dialog.fromJson(json);
}

/// @nodoc
mixin _$Dialog {
  String get A => throw _privateConstructorUsedError;
  String get B => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DialogCopyWith<Dialog> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DialogCopyWith<$Res> {
  factory $DialogCopyWith(Dialog value, $Res Function(Dialog) then) =
      _$DialogCopyWithImpl<$Res, Dialog>;
  @useResult
  $Res call({String A, String B});
}

/// @nodoc
class _$DialogCopyWithImpl<$Res, $Val extends Dialog>
    implements $DialogCopyWith<$Res> {
  _$DialogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? A = null,
    Object? B = null,
  }) {
    return _then(_value.copyWith(
      A: null == A
          ? _value.A
          : A // ignore: cast_nullable_to_non_nullable
              as String,
      B: null == B
          ? _value.B
          : B // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DialogImplCopyWith<$Res> implements $DialogCopyWith<$Res> {
  factory _$$DialogImplCopyWith(
          _$DialogImpl value, $Res Function(_$DialogImpl) then) =
      __$$DialogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String A, String B});
}

/// @nodoc
class __$$DialogImplCopyWithImpl<$Res>
    extends _$DialogCopyWithImpl<$Res, _$DialogImpl>
    implements _$$DialogImplCopyWith<$Res> {
  __$$DialogImplCopyWithImpl(
      _$DialogImpl _value, $Res Function(_$DialogImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? A = null,
    Object? B = null,
  }) {
    return _then(_$DialogImpl(
      A: null == A
          ? _value.A
          : A // ignore: cast_nullable_to_non_nullable
              as String,
      B: null == B
          ? _value.B
          : B // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DialogImpl implements _Dialog {
  const _$DialogImpl({required this.A, required this.B});

  factory _$DialogImpl.fromJson(Map<String, dynamic> json) =>
      _$$DialogImplFromJson(json);

  @override
  final String A;
  @override
  final String B;

  @override
  String toString() {
    return 'Dialog(A: $A, B: $B)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DialogImpl &&
            (identical(other.A, A) || other.A == A) &&
            (identical(other.B, B) || other.B == B));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, A, B);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DialogImplCopyWith<_$DialogImpl> get copyWith =>
      __$$DialogImplCopyWithImpl<_$DialogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DialogImplToJson(
      this,
    );
  }
}

abstract class _Dialog implements Dialog {
  const factory _Dialog({required final String A, required final String B}) =
      _$DialogImpl;

  factory _Dialog.fromJson(Map<String, dynamic> json) = _$DialogImpl.fromJson;

  @override
  String get A;
  @override
  String get B;
  @override
  @JsonKey(ignore: true)
  _$$DialogImplCopyWith<_$DialogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Phrase _$PhraseFromJson(Map<String, dynamic> json) {
  return _Phrase.fromJson(json);
}

/// @nodoc
mixin _$Phrase {
  String get phrase => throw _privateConstructorUsedError;
  Dialog get dialog => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PhraseCopyWith<Phrase> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhraseCopyWith<$Res> {
  factory $PhraseCopyWith(Phrase value, $Res Function(Phrase) then) =
      _$PhraseCopyWithImpl<$Res, Phrase>;
  @useResult
  $Res call({String phrase, Dialog dialog});

  $DialogCopyWith<$Res> get dialog;
}

/// @nodoc
class _$PhraseCopyWithImpl<$Res, $Val extends Phrase>
    implements $PhraseCopyWith<$Res> {
  _$PhraseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phrase = null,
    Object? dialog = null,
  }) {
    return _then(_value.copyWith(
      phrase: null == phrase
          ? _value.phrase
          : phrase // ignore: cast_nullable_to_non_nullable
              as String,
      dialog: null == dialog
          ? _value.dialog
          : dialog // ignore: cast_nullable_to_non_nullable
              as Dialog,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DialogCopyWith<$Res> get dialog {
    return $DialogCopyWith<$Res>(_value.dialog, (value) {
      return _then(_value.copyWith(dialog: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PhraseImplCopyWith<$Res> implements $PhraseCopyWith<$Res> {
  factory _$$PhraseImplCopyWith(
          _$PhraseImpl value, $Res Function(_$PhraseImpl) then) =
      __$$PhraseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String phrase, Dialog dialog});

  @override
  $DialogCopyWith<$Res> get dialog;
}

/// @nodoc
class __$$PhraseImplCopyWithImpl<$Res>
    extends _$PhraseCopyWithImpl<$Res, _$PhraseImpl>
    implements _$$PhraseImplCopyWith<$Res> {
  __$$PhraseImplCopyWithImpl(
      _$PhraseImpl _value, $Res Function(_$PhraseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phrase = null,
    Object? dialog = null,
  }) {
    return _then(_$PhraseImpl(
      phrase: null == phrase
          ? _value.phrase
          : phrase // ignore: cast_nullable_to_non_nullable
              as String,
      dialog: null == dialog
          ? _value.dialog
          : dialog // ignore: cast_nullable_to_non_nullable
              as Dialog,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PhraseImpl implements _Phrase {
  const _$PhraseImpl({required this.phrase, required this.dialog});

  factory _$PhraseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PhraseImplFromJson(json);

  @override
  final String phrase;
  @override
  final Dialog dialog;

  @override
  String toString() {
    return 'Phrase(phrase: $phrase, dialog: $dialog)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhraseImpl &&
            (identical(other.phrase, phrase) || other.phrase == phrase) &&
            (identical(other.dialog, dialog) || other.dialog == dialog));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, phrase, dialog);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PhraseImplCopyWith<_$PhraseImpl> get copyWith =>
      __$$PhraseImplCopyWithImpl<_$PhraseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PhraseImplToJson(
      this,
    );
  }
}

abstract class _Phrase implements Phrase {
  const factory _Phrase(
      {required final String phrase,
      required final Dialog dialog}) = _$PhraseImpl;

  factory _Phrase.fromJson(Map<String, dynamic> json) = _$PhraseImpl.fromJson;

  @override
  String get phrase;
  @override
  Dialog get dialog;
  @override
  @JsonKey(ignore: true)
  _$$PhraseImplCopyWith<_$PhraseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Sentence _$SentenceFromJson(Map<String, dynamic> json) {
  return _Sentence.fromJson(json);
}

/// @nodoc
mixin _$Sentence {
  String get en => throw _privateConstructorUsedError;
  String get cn => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SentenceCopyWith<Sentence> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SentenceCopyWith<$Res> {
  factory $SentenceCopyWith(Sentence value, $Res Function(Sentence) then) =
      _$SentenceCopyWithImpl<$Res, Sentence>;
  @useResult
  $Res call({String en, String cn});
}

/// @nodoc
class _$SentenceCopyWithImpl<$Res, $Val extends Sentence>
    implements $SentenceCopyWith<$Res> {
  _$SentenceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? en = null,
    Object? cn = null,
  }) {
    return _then(_value.copyWith(
      en: null == en
          ? _value.en
          : en // ignore: cast_nullable_to_non_nullable
              as String,
      cn: null == cn
          ? _value.cn
          : cn // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SentenceImplCopyWith<$Res>
    implements $SentenceCopyWith<$Res> {
  factory _$$SentenceImplCopyWith(
          _$SentenceImpl value, $Res Function(_$SentenceImpl) then) =
      __$$SentenceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String en, String cn});
}

/// @nodoc
class __$$SentenceImplCopyWithImpl<$Res>
    extends _$SentenceCopyWithImpl<$Res, _$SentenceImpl>
    implements _$$SentenceImplCopyWith<$Res> {
  __$$SentenceImplCopyWithImpl(
      _$SentenceImpl _value, $Res Function(_$SentenceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? en = null,
    Object? cn = null,
  }) {
    return _then(_$SentenceImpl(
      en: null == en
          ? _value.en
          : en // ignore: cast_nullable_to_non_nullable
              as String,
      cn: null == cn
          ? _value.cn
          : cn // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SentenceImpl implements _Sentence {
  const _$SentenceImpl({required this.en, required this.cn});

  factory _$SentenceImpl.fromJson(Map<String, dynamic> json) =>
      _$$SentenceImplFromJson(json);

  @override
  final String en;
  @override
  final String cn;

  @override
  String toString() {
    return 'Sentence(en: $en, cn: $cn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SentenceImpl &&
            (identical(other.en, en) || other.en == en) &&
            (identical(other.cn, cn) || other.cn == cn));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, en, cn);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SentenceImplCopyWith<_$SentenceImpl> get copyWith =>
      __$$SentenceImplCopyWithImpl<_$SentenceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SentenceImplToJson(
      this,
    );
  }
}

abstract class _Sentence implements Sentence {
  const factory _Sentence(
      {required final String en, required final String cn}) = _$SentenceImpl;

  factory _Sentence.fromJson(Map<String, dynamic> json) =
      _$SentenceImpl.fromJson;

  @override
  String get en;
  @override
  String get cn;
  @override
  @JsonKey(ignore: true)
  _$$SentenceImplCopyWith<_$SentenceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Pronunciation _$PronunciationFromJson(Map<String, dynamic> json) {
  return _Pronunciation.fromJson(json);
}

/// @nodoc
mixin _$Pronunciation {
  String? get ipa => throw _privateConstructorUsedError;
  String? get audio => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PronunciationCopyWith<Pronunciation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PronunciationCopyWith<$Res> {
  factory $PronunciationCopyWith(
          Pronunciation value, $Res Function(Pronunciation) then) =
      _$PronunciationCopyWithImpl<$Res, Pronunciation>;
  @useResult
  $Res call({String? ipa, String? audio});
}

/// @nodoc
class _$PronunciationCopyWithImpl<$Res, $Val extends Pronunciation>
    implements $PronunciationCopyWith<$Res> {
  _$PronunciationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ipa = freezed,
    Object? audio = freezed,
  }) {
    return _then(_value.copyWith(
      ipa: freezed == ipa
          ? _value.ipa
          : ipa // ignore: cast_nullable_to_non_nullable
              as String?,
      audio: freezed == audio
          ? _value.audio
          : audio // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PronunciationImplCopyWith<$Res>
    implements $PronunciationCopyWith<$Res> {
  factory _$$PronunciationImplCopyWith(
          _$PronunciationImpl value, $Res Function(_$PronunciationImpl) then) =
      __$$PronunciationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? ipa, String? audio});
}

/// @nodoc
class __$$PronunciationImplCopyWithImpl<$Res>
    extends _$PronunciationCopyWithImpl<$Res, _$PronunciationImpl>
    implements _$$PronunciationImplCopyWith<$Res> {
  __$$PronunciationImplCopyWithImpl(
      _$PronunciationImpl _value, $Res Function(_$PronunciationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ipa = freezed,
    Object? audio = freezed,
  }) {
    return _then(_$PronunciationImpl(
      ipa: freezed == ipa
          ? _value.ipa
          : ipa // ignore: cast_nullable_to_non_nullable
              as String?,
      audio: freezed == audio
          ? _value.audio
          : audio // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PronunciationImpl implements _Pronunciation {
  const _$PronunciationImpl({this.ipa, this.audio});

  factory _$PronunciationImpl.fromJson(Map<String, dynamic> json) =>
      _$$PronunciationImplFromJson(json);

  @override
  final String? ipa;
  @override
  final String? audio;

  @override
  String toString() {
    return 'Pronunciation(ipa: $ipa, audio: $audio)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PronunciationImpl &&
            (identical(other.ipa, ipa) || other.ipa == ipa) &&
            (identical(other.audio, audio) || other.audio == audio));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, ipa, audio);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PronunciationImplCopyWith<_$PronunciationImpl> get copyWith =>
      __$$PronunciationImplCopyWithImpl<_$PronunciationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PronunciationImplToJson(
      this,
    );
  }
}

abstract class _Pronunciation implements Pronunciation {
  const factory _Pronunciation({final String? ipa, final String? audio}) =
      _$PronunciationImpl;

  factory _Pronunciation.fromJson(Map<String, dynamic> json) =
      _$PronunciationImpl.fromJson;

  @override
  String? get ipa;
  @override
  String? get audio;
  @override
  @JsonKey(ignore: true)
  _$$PronunciationImplCopyWith<_$PronunciationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PronunciationData _$PronunciationDataFromJson(Map<String, dynamic> json) {
  return _PronunciationData.fromJson(json);
}

/// @nodoc
mixin _$PronunciationData {
  Pronunciation get US => throw _privateConstructorUsedError;
  Pronunciation? get UK => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PronunciationDataCopyWith<PronunciationData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PronunciationDataCopyWith<$Res> {
  factory $PronunciationDataCopyWith(
          PronunciationData value, $Res Function(PronunciationData) then) =
      _$PronunciationDataCopyWithImpl<$Res, PronunciationData>;
  @useResult
  $Res call({Pronunciation US, Pronunciation? UK});

  $PronunciationCopyWith<$Res> get US;
  $PronunciationCopyWith<$Res>? get UK;
}

/// @nodoc
class _$PronunciationDataCopyWithImpl<$Res, $Val extends PronunciationData>
    implements $PronunciationDataCopyWith<$Res> {
  _$PronunciationDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? US = null,
    Object? UK = freezed,
  }) {
    return _then(_value.copyWith(
      US: null == US
          ? _value.US
          : US // ignore: cast_nullable_to_non_nullable
              as Pronunciation,
      UK: freezed == UK
          ? _value.UK
          : UK // ignore: cast_nullable_to_non_nullable
              as Pronunciation?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PronunciationCopyWith<$Res> get US {
    return $PronunciationCopyWith<$Res>(_value.US, (value) {
      return _then(_value.copyWith(US: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PronunciationCopyWith<$Res>? get UK {
    if (_value.UK == null) {
      return null;
    }

    return $PronunciationCopyWith<$Res>(_value.UK!, (value) {
      return _then(_value.copyWith(UK: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PronunciationDataImplCopyWith<$Res>
    implements $PronunciationDataCopyWith<$Res> {
  factory _$$PronunciationDataImplCopyWith(_$PronunciationDataImpl value,
          $Res Function(_$PronunciationDataImpl) then) =
      __$$PronunciationDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Pronunciation US, Pronunciation? UK});

  @override
  $PronunciationCopyWith<$Res> get US;
  @override
  $PronunciationCopyWith<$Res>? get UK;
}

/// @nodoc
class __$$PronunciationDataImplCopyWithImpl<$Res>
    extends _$PronunciationDataCopyWithImpl<$Res, _$PronunciationDataImpl>
    implements _$$PronunciationDataImplCopyWith<$Res> {
  __$$PronunciationDataImplCopyWithImpl(_$PronunciationDataImpl _value,
      $Res Function(_$PronunciationDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? US = null,
    Object? UK = freezed,
  }) {
    return _then(_$PronunciationDataImpl(
      US: null == US
          ? _value.US
          : US // ignore: cast_nullable_to_non_nullable
              as Pronunciation,
      UK: freezed == UK
          ? _value.UK
          : UK // ignore: cast_nullable_to_non_nullable
              as Pronunciation?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PronunciationDataImpl implements _PronunciationData {
  const _$PronunciationDataImpl({required this.US, this.UK});

  factory _$PronunciationDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$PronunciationDataImplFromJson(json);

  @override
  final Pronunciation US;
  @override
  final Pronunciation? UK;

  @override
  String toString() {
    return 'PronunciationData(US: $US, UK: $UK)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PronunciationDataImpl &&
            (identical(other.US, US) || other.US == US) &&
            (identical(other.UK, UK) || other.UK == UK));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, US, UK);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PronunciationDataImplCopyWith<_$PronunciationDataImpl> get copyWith =>
      __$$PronunciationDataImplCopyWithImpl<_$PronunciationDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PronunciationDataImplToJson(
      this,
    );
  }
}

abstract class _PronunciationData implements PronunciationData {
  const factory _PronunciationData(
      {required final Pronunciation US,
      final Pronunciation? UK}) = _$PronunciationDataImpl;

  factory _PronunciationData.fromJson(Map<String, dynamic> json) =
      _$PronunciationDataImpl.fromJson;

  @override
  Pronunciation get US;
  @override
  Pronunciation? get UK;
  @override
  @JsonKey(ignore: true)
  _$$PronunciationDataImplCopyWith<_$PronunciationDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WordModel _$WordModelFromJson(Map<String, dynamic> json) {
  return _WordModel.fromJson(json);
}

/// @nodoc
mixin _$WordModel {
  int get id => throw _privateConstructorUsedError;
  String get word => throw _privateConstructorUsedError;
  String? get lemma => throw _privateConstructorUsedError;
  List<String> get partsOfSpeech => throw _privateConstructorUsedError;
  List<PosMeaning> get posMeanings => throw _privateConstructorUsedError;
  List<Phrase> get phrases => throw _privateConstructorUsedError;
  List<Sentence> get sentences => throw _privateConstructorUsedError;
  PronunciationData get pronunciation => throw _privateConstructorUsedError;
  String? get level => throw _privateConstructorUsedError;
  int get frequency => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  List<String> get synonyms => throw _privateConstructorUsedError;
  List<String> get antonyms => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WordModelCopyWith<WordModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WordModelCopyWith<$Res> {
  factory $WordModelCopyWith(WordModel value, $Res Function(WordModel) then) =
      _$WordModelCopyWithImpl<$Res, WordModel>;
  @useResult
  $Res call(
      {int id,
      String word,
      String? lemma,
      List<String> partsOfSpeech,
      List<PosMeaning> posMeanings,
      List<Phrase> phrases,
      List<Sentence> sentences,
      PronunciationData pronunciation,
      String? level,
      int frequency,
      List<String> tags,
      List<String> synonyms,
      List<String> antonyms});

  $PronunciationDataCopyWith<$Res> get pronunciation;
}

/// @nodoc
class _$WordModelCopyWithImpl<$Res, $Val extends WordModel>
    implements $WordModelCopyWith<$Res> {
  _$WordModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? word = null,
    Object? lemma = freezed,
    Object? partsOfSpeech = null,
    Object? posMeanings = null,
    Object? phrases = null,
    Object? sentences = null,
    Object? pronunciation = null,
    Object? level = freezed,
    Object? frequency = null,
    Object? tags = null,
    Object? synonyms = null,
    Object? antonyms = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      word: null == word
          ? _value.word
          : word // ignore: cast_nullable_to_non_nullable
              as String,
      lemma: freezed == lemma
          ? _value.lemma
          : lemma // ignore: cast_nullable_to_non_nullable
              as String?,
      partsOfSpeech: null == partsOfSpeech
          ? _value.partsOfSpeech
          : partsOfSpeech // ignore: cast_nullable_to_non_nullable
              as List<String>,
      posMeanings: null == posMeanings
          ? _value.posMeanings
          : posMeanings // ignore: cast_nullable_to_non_nullable
              as List<PosMeaning>,
      phrases: null == phrases
          ? _value.phrases
          : phrases // ignore: cast_nullable_to_non_nullable
              as List<Phrase>,
      sentences: null == sentences
          ? _value.sentences
          : sentences // ignore: cast_nullable_to_non_nullable
              as List<Sentence>,
      pronunciation: null == pronunciation
          ? _value.pronunciation
          : pronunciation // ignore: cast_nullable_to_non_nullable
              as PronunciationData,
      level: freezed == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String?,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as int,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      synonyms: null == synonyms
          ? _value.synonyms
          : synonyms // ignore: cast_nullable_to_non_nullable
              as List<String>,
      antonyms: null == antonyms
          ? _value.antonyms
          : antonyms // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PronunciationDataCopyWith<$Res> get pronunciation {
    return $PronunciationDataCopyWith<$Res>(_value.pronunciation, (value) {
      return _then(_value.copyWith(pronunciation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WordModelImplCopyWith<$Res>
    implements $WordModelCopyWith<$Res> {
  factory _$$WordModelImplCopyWith(
          _$WordModelImpl value, $Res Function(_$WordModelImpl) then) =
      __$$WordModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String word,
      String? lemma,
      List<String> partsOfSpeech,
      List<PosMeaning> posMeanings,
      List<Phrase> phrases,
      List<Sentence> sentences,
      PronunciationData pronunciation,
      String? level,
      int frequency,
      List<String> tags,
      List<String> synonyms,
      List<String> antonyms});

  @override
  $PronunciationDataCopyWith<$Res> get pronunciation;
}

/// @nodoc
class __$$WordModelImplCopyWithImpl<$Res>
    extends _$WordModelCopyWithImpl<$Res, _$WordModelImpl>
    implements _$$WordModelImplCopyWith<$Res> {
  __$$WordModelImplCopyWithImpl(
      _$WordModelImpl _value, $Res Function(_$WordModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? word = null,
    Object? lemma = freezed,
    Object? partsOfSpeech = null,
    Object? posMeanings = null,
    Object? phrases = null,
    Object? sentences = null,
    Object? pronunciation = null,
    Object? level = freezed,
    Object? frequency = null,
    Object? tags = null,
    Object? synonyms = null,
    Object? antonyms = null,
  }) {
    return _then(_$WordModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      word: null == word
          ? _value.word
          : word // ignore: cast_nullable_to_non_nullable
              as String,
      lemma: freezed == lemma
          ? _value.lemma
          : lemma // ignore: cast_nullable_to_non_nullable
              as String?,
      partsOfSpeech: null == partsOfSpeech
          ? _value._partsOfSpeech
          : partsOfSpeech // ignore: cast_nullable_to_non_nullable
              as List<String>,
      posMeanings: null == posMeanings
          ? _value._posMeanings
          : posMeanings // ignore: cast_nullable_to_non_nullable
              as List<PosMeaning>,
      phrases: null == phrases
          ? _value._phrases
          : phrases // ignore: cast_nullable_to_non_nullable
              as List<Phrase>,
      sentences: null == sentences
          ? _value._sentences
          : sentences // ignore: cast_nullable_to_non_nullable
              as List<Sentence>,
      pronunciation: null == pronunciation
          ? _value.pronunciation
          : pronunciation // ignore: cast_nullable_to_non_nullable
              as PronunciationData,
      level: freezed == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String?,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as int,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      synonyms: null == synonyms
          ? _value._synonyms
          : synonyms // ignore: cast_nullable_to_non_nullable
              as List<String>,
      antonyms: null == antonyms
          ? _value._antonyms
          : antonyms // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WordModelImpl implements _WordModel {
  const _$WordModelImpl(
      {required this.id,
      required this.word,
      this.lemma,
      required final List<String> partsOfSpeech,
      required final List<PosMeaning> posMeanings,
      required final List<Phrase> phrases,
      required final List<Sentence> sentences,
      required this.pronunciation,
      this.level,
      this.frequency = 0,
      final List<String> tags = const [],
      final List<String> synonyms = const [],
      final List<String> antonyms = const []})
      : _partsOfSpeech = partsOfSpeech,
        _posMeanings = posMeanings,
        _phrases = phrases,
        _sentences = sentences,
        _tags = tags,
        _synonyms = synonyms,
        _antonyms = antonyms;

  factory _$WordModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WordModelImplFromJson(json);

  @override
  final int id;
  @override
  final String word;
  @override
  final String? lemma;
  final List<String> _partsOfSpeech;
  @override
  List<String> get partsOfSpeech {
    if (_partsOfSpeech is EqualUnmodifiableListView) return _partsOfSpeech;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_partsOfSpeech);
  }

  final List<PosMeaning> _posMeanings;
  @override
  List<PosMeaning> get posMeanings {
    if (_posMeanings is EqualUnmodifiableListView) return _posMeanings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_posMeanings);
  }

  final List<Phrase> _phrases;
  @override
  List<Phrase> get phrases {
    if (_phrases is EqualUnmodifiableListView) return _phrases;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_phrases);
  }

  final List<Sentence> _sentences;
  @override
  List<Sentence> get sentences {
    if (_sentences is EqualUnmodifiableListView) return _sentences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sentences);
  }

  @override
  final PronunciationData pronunciation;
  @override
  final String? level;
  @override
  @JsonKey()
  final int frequency;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final List<String> _synonyms;
  @override
  @JsonKey()
  List<String> get synonyms {
    if (_synonyms is EqualUnmodifiableListView) return _synonyms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_synonyms);
  }

  final List<String> _antonyms;
  @override
  @JsonKey()
  List<String> get antonyms {
    if (_antonyms is EqualUnmodifiableListView) return _antonyms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_antonyms);
  }

  @override
  String toString() {
    return 'WordModel(id: $id, word: $word, lemma: $lemma, partsOfSpeech: $partsOfSpeech, posMeanings: $posMeanings, phrases: $phrases, sentences: $sentences, pronunciation: $pronunciation, level: $level, frequency: $frequency, tags: $tags, synonyms: $synonyms, antonyms: $antonyms)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WordModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.word, word) || other.word == word) &&
            (identical(other.lemma, lemma) || other.lemma == lemma) &&
            const DeepCollectionEquality()
                .equals(other._partsOfSpeech, _partsOfSpeech) &&
            const DeepCollectionEquality()
                .equals(other._posMeanings, _posMeanings) &&
            const DeepCollectionEquality().equals(other._phrases, _phrases) &&
            const DeepCollectionEquality()
                .equals(other._sentences, _sentences) &&
            (identical(other.pronunciation, pronunciation) ||
                other.pronunciation == pronunciation) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other._synonyms, _synonyms) &&
            const DeepCollectionEquality().equals(other._antonyms, _antonyms));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      word,
      lemma,
      const DeepCollectionEquality().hash(_partsOfSpeech),
      const DeepCollectionEquality().hash(_posMeanings),
      const DeepCollectionEquality().hash(_phrases),
      const DeepCollectionEquality().hash(_sentences),
      pronunciation,
      level,
      frequency,
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_synonyms),
      const DeepCollectionEquality().hash(_antonyms));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WordModelImplCopyWith<_$WordModelImpl> get copyWith =>
      __$$WordModelImplCopyWithImpl<_$WordModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WordModelImplToJson(
      this,
    );
  }
}

abstract class _WordModel implements WordModel {
  const factory _WordModel(
      {required final int id,
      required final String word,
      final String? lemma,
      required final List<String> partsOfSpeech,
      required final List<PosMeaning> posMeanings,
      required final List<Phrase> phrases,
      required final List<Sentence> sentences,
      required final PronunciationData pronunciation,
      final String? level,
      final int frequency,
      final List<String> tags,
      final List<String> synonyms,
      final List<String> antonyms}) = _$WordModelImpl;

  factory _WordModel.fromJson(Map<String, dynamic> json) =
      _$WordModelImpl.fromJson;

  @override
  int get id;
  @override
  String get word;
  @override
  String? get lemma;
  @override
  List<String> get partsOfSpeech;
  @override
  List<PosMeaning> get posMeanings;
  @override
  List<Phrase> get phrases;
  @override
  List<Sentence> get sentences;
  @override
  PronunciationData get pronunciation;
  @override
  String? get level;
  @override
  int get frequency;
  @override
  List<String> get tags;
  @override
  List<String> get synonyms;
  @override
  List<String> get antonyms;
  @override
  @JsonKey(ignore: true)
  _$$WordModelImplCopyWith<_$WordModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
