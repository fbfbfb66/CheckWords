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

Trans _$TransFromJson(Map<String, dynamic> json) {
  return _Trans.fromJson(json);
}

/// @nodoc
mixin _$Trans {
  String get tranCn => throw _privateConstructorUsedError; // 中文释义
  String? get descOther => throw _privateConstructorUsedError; // 英释描述
  String get pos => throw _privateConstructorUsedError; // 词性
  String? get descCn => throw _privateConstructorUsedError; // 中释描述
  String? get tranOther => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransCopyWith<Trans> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransCopyWith<$Res> {
  factory $TransCopyWith(Trans value, $Res Function(Trans) then) =
      _$TransCopyWithImpl<$Res, Trans>;
  @useResult
  $Res call(
      {String tranCn,
      String? descOther,
      String pos,
      String? descCn,
      String? tranOther});
}

/// @nodoc
class _$TransCopyWithImpl<$Res, $Val extends Trans>
    implements $TransCopyWith<$Res> {
  _$TransCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tranCn = null,
    Object? descOther = freezed,
    Object? pos = null,
    Object? descCn = freezed,
    Object? tranOther = freezed,
  }) {
    return _then(_value.copyWith(
      tranCn: null == tranCn
          ? _value.tranCn
          : tranCn // ignore: cast_nullable_to_non_nullable
              as String,
      descOther: freezed == descOther
          ? _value.descOther
          : descOther // ignore: cast_nullable_to_non_nullable
              as String?,
      pos: null == pos
          ? _value.pos
          : pos // ignore: cast_nullable_to_non_nullable
              as String,
      descCn: freezed == descCn
          ? _value.descCn
          : descCn // ignore: cast_nullable_to_non_nullable
              as String?,
      tranOther: freezed == tranOther
          ? _value.tranOther
          : tranOther // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransImplCopyWith<$Res> implements $TransCopyWith<$Res> {
  factory _$$TransImplCopyWith(
          _$TransImpl value, $Res Function(_$TransImpl) then) =
      __$$TransImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String tranCn,
      String? descOther,
      String pos,
      String? descCn,
      String? tranOther});
}

/// @nodoc
class __$$TransImplCopyWithImpl<$Res>
    extends _$TransCopyWithImpl<$Res, _$TransImpl>
    implements _$$TransImplCopyWith<$Res> {
  __$$TransImplCopyWithImpl(
      _$TransImpl _value, $Res Function(_$TransImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tranCn = null,
    Object? descOther = freezed,
    Object? pos = null,
    Object? descCn = freezed,
    Object? tranOther = freezed,
  }) {
    return _then(_$TransImpl(
      tranCn: null == tranCn
          ? _value.tranCn
          : tranCn // ignore: cast_nullable_to_non_nullable
              as String,
      descOther: freezed == descOther
          ? _value.descOther
          : descOther // ignore: cast_nullable_to_non_nullable
              as String?,
      pos: null == pos
          ? _value.pos
          : pos // ignore: cast_nullable_to_non_nullable
              as String,
      descCn: freezed == descCn
          ? _value.descCn
          : descCn // ignore: cast_nullable_to_non_nullable
              as String?,
      tranOther: freezed == tranOther
          ? _value.tranOther
          : tranOther // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransImpl implements _Trans {
  const _$TransImpl(
      {required this.tranCn,
      this.descOther,
      required this.pos,
      this.descCn,
      this.tranOther});

  factory _$TransImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransImplFromJson(json);

  @override
  final String tranCn;
// 中文释义
  @override
  final String? descOther;
// 英释描述
  @override
  final String pos;
// 词性
  @override
  final String? descCn;
// 中释描述
  @override
  final String? tranOther;

  @override
  String toString() {
    return 'Trans(tranCn: $tranCn, descOther: $descOther, pos: $pos, descCn: $descCn, tranOther: $tranOther)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransImpl &&
            (identical(other.tranCn, tranCn) || other.tranCn == tranCn) &&
            (identical(other.descOther, descOther) ||
                other.descOther == descOther) &&
            (identical(other.pos, pos) || other.pos == pos) &&
            (identical(other.descCn, descCn) || other.descCn == descCn) &&
            (identical(other.tranOther, tranOther) ||
                other.tranOther == tranOther));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, tranCn, descOther, pos, descCn, tranOther);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransImplCopyWith<_$TransImpl> get copyWith =>
      __$$TransImplCopyWithImpl<_$TransImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransImplToJson(
      this,
    );
  }
}

abstract class _Trans implements Trans {
  const factory _Trans(
      {required final String tranCn,
      final String? descOther,
      required final String pos,
      final String? descCn,
      final String? tranOther}) = _$TransImpl;

  factory _Trans.fromJson(Map<String, dynamic> json) = _$TransImpl.fromJson;

  @override
  String get tranCn;
  @override // 中文释义
  String? get descOther;
  @override // 英释描述
  String get pos;
  @override // 词性
  String? get descCn;
  @override // 中释描述
  String? get tranOther;
  @override
  @JsonKey(ignore: true)
  _$$TransImplCopyWith<_$TransImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

KajSentence _$KajSentenceFromJson(Map<String, dynamic> json) {
  return _KajSentence.fromJson(json);
}

/// @nodoc
mixin _$KajSentence {
  String get sContent => throw _privateConstructorUsedError; // 英文例句
  String get sCn => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $KajSentenceCopyWith<KajSentence> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KajSentenceCopyWith<$Res> {
  factory $KajSentenceCopyWith(
          KajSentence value, $Res Function(KajSentence) then) =
      _$KajSentenceCopyWithImpl<$Res, KajSentence>;
  @useResult
  $Res call({String sContent, String sCn});
}

/// @nodoc
class _$KajSentenceCopyWithImpl<$Res, $Val extends KajSentence>
    implements $KajSentenceCopyWith<$Res> {
  _$KajSentenceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sContent = null,
    Object? sCn = null,
  }) {
    return _then(_value.copyWith(
      sContent: null == sContent
          ? _value.sContent
          : sContent // ignore: cast_nullable_to_non_nullable
              as String,
      sCn: null == sCn
          ? _value.sCn
          : sCn // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$KajSentenceImplCopyWith<$Res>
    implements $KajSentenceCopyWith<$Res> {
  factory _$$KajSentenceImplCopyWith(
          _$KajSentenceImpl value, $Res Function(_$KajSentenceImpl) then) =
      __$$KajSentenceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String sContent, String sCn});
}

/// @nodoc
class __$$KajSentenceImplCopyWithImpl<$Res>
    extends _$KajSentenceCopyWithImpl<$Res, _$KajSentenceImpl>
    implements _$$KajSentenceImplCopyWith<$Res> {
  __$$KajSentenceImplCopyWithImpl(
      _$KajSentenceImpl _value, $Res Function(_$KajSentenceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sContent = null,
    Object? sCn = null,
  }) {
    return _then(_$KajSentenceImpl(
      sContent: null == sContent
          ? _value.sContent
          : sContent // ignore: cast_nullable_to_non_nullable
              as String,
      sCn: null == sCn
          ? _value.sCn
          : sCn // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$KajSentenceImpl implements _KajSentence {
  const _$KajSentenceImpl({required this.sContent, required this.sCn});

  factory _$KajSentenceImpl.fromJson(Map<String, dynamic> json) =>
      _$$KajSentenceImplFromJson(json);

  @override
  final String sContent;
// 英文例句
  @override
  final String sCn;

  @override
  String toString() {
    return 'KajSentence(sContent: $sContent, sCn: $sCn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KajSentenceImpl &&
            (identical(other.sContent, sContent) ||
                other.sContent == sContent) &&
            (identical(other.sCn, sCn) || other.sCn == sCn));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, sContent, sCn);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$KajSentenceImplCopyWith<_$KajSentenceImpl> get copyWith =>
      __$$KajSentenceImplCopyWithImpl<_$KajSentenceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KajSentenceImplToJson(
      this,
    );
  }
}

abstract class _KajSentence implements KajSentence {
  const factory _KajSentence(
      {required final String sContent,
      required final String sCn}) = _$KajSentenceImpl;

  factory _KajSentence.fromJson(Map<String, dynamic> json) =
      _$KajSentenceImpl.fromJson;

  @override
  String get sContent;
  @override // 英文例句
  String get sCn;
  @override
  @JsonKey(ignore: true)
  _$$KajSentenceImplCopyWith<_$KajSentenceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

KajPhrase _$KajPhraseFromJson(Map<String, dynamic> json) {
  return _KajPhrase.fromJson(json);
}

/// @nodoc
mixin _$KajPhrase {
  String get pContent => throw _privateConstructorUsedError; // 英文短语
  String get pCn => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $KajPhraseCopyWith<KajPhrase> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KajPhraseCopyWith<$Res> {
  factory $KajPhraseCopyWith(KajPhrase value, $Res Function(KajPhrase) then) =
      _$KajPhraseCopyWithImpl<$Res, KajPhrase>;
  @useResult
  $Res call({String pContent, String pCn});
}

/// @nodoc
class _$KajPhraseCopyWithImpl<$Res, $Val extends KajPhrase>
    implements $KajPhraseCopyWith<$Res> {
  _$KajPhraseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pContent = null,
    Object? pCn = null,
  }) {
    return _then(_value.copyWith(
      pContent: null == pContent
          ? _value.pContent
          : pContent // ignore: cast_nullable_to_non_nullable
              as String,
      pCn: null == pCn
          ? _value.pCn
          : pCn // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$KajPhraseImplCopyWith<$Res>
    implements $KajPhraseCopyWith<$Res> {
  factory _$$KajPhraseImplCopyWith(
          _$KajPhraseImpl value, $Res Function(_$KajPhraseImpl) then) =
      __$$KajPhraseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String pContent, String pCn});
}

/// @nodoc
class __$$KajPhraseImplCopyWithImpl<$Res>
    extends _$KajPhraseCopyWithImpl<$Res, _$KajPhraseImpl>
    implements _$$KajPhraseImplCopyWith<$Res> {
  __$$KajPhraseImplCopyWithImpl(
      _$KajPhraseImpl _value, $Res Function(_$KajPhraseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pContent = null,
    Object? pCn = null,
  }) {
    return _then(_$KajPhraseImpl(
      pContent: null == pContent
          ? _value.pContent
          : pContent // ignore: cast_nullable_to_non_nullable
              as String,
      pCn: null == pCn
          ? _value.pCn
          : pCn // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$KajPhraseImpl implements _KajPhrase {
  const _$KajPhraseImpl({required this.pContent, required this.pCn});

  factory _$KajPhraseImpl.fromJson(Map<String, dynamic> json) =>
      _$$KajPhraseImplFromJson(json);

  @override
  final String pContent;
// 英文短语
  @override
  final String pCn;

  @override
  String toString() {
    return 'KajPhrase(pContent: $pContent, pCn: $pCn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KajPhraseImpl &&
            (identical(other.pContent, pContent) ||
                other.pContent == pContent) &&
            (identical(other.pCn, pCn) || other.pCn == pCn));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, pContent, pCn);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$KajPhraseImplCopyWith<_$KajPhraseImpl> get copyWith =>
      __$$KajPhraseImplCopyWithImpl<_$KajPhraseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KajPhraseImplToJson(
      this,
    );
  }
}

abstract class _KajPhrase implements KajPhrase {
  const factory _KajPhrase(
      {required final String pContent,
      required final String pCn}) = _$KajPhraseImpl;

  factory _KajPhrase.fromJson(Map<String, dynamic> json) =
      _$KajPhraseImpl.fromJson;

  @override
  String get pContent;
  @override // 英文短语
  String get pCn;
  @override
  @JsonKey(ignore: true)
  _$$KajPhraseImplCopyWith<_$KajPhraseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Syno _$SynoFromJson(Map<String, dynamic> json) {
  return _Syno.fromJson(json);
}

/// @nodoc
mixin _$Syno {
  String get pos => throw _privateConstructorUsedError; // 词性
  String get tran => throw _privateConstructorUsedError; // 释义
  List<Hwd> get hwds => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SynoCopyWith<Syno> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SynoCopyWith<$Res> {
  factory $SynoCopyWith(Syno value, $Res Function(Syno) then) =
      _$SynoCopyWithImpl<$Res, Syno>;
  @useResult
  $Res call({String pos, String tran, List<Hwd> hwds});
}

/// @nodoc
class _$SynoCopyWithImpl<$Res, $Val extends Syno>
    implements $SynoCopyWith<$Res> {
  _$SynoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pos = null,
    Object? tran = null,
    Object? hwds = null,
  }) {
    return _then(_value.copyWith(
      pos: null == pos
          ? _value.pos
          : pos // ignore: cast_nullable_to_non_nullable
              as String,
      tran: null == tran
          ? _value.tran
          : tran // ignore: cast_nullable_to_non_nullable
              as String,
      hwds: null == hwds
          ? _value.hwds
          : hwds // ignore: cast_nullable_to_non_nullable
              as List<Hwd>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SynoImplCopyWith<$Res> implements $SynoCopyWith<$Res> {
  factory _$$SynoImplCopyWith(
          _$SynoImpl value, $Res Function(_$SynoImpl) then) =
      __$$SynoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String pos, String tran, List<Hwd> hwds});
}

/// @nodoc
class __$$SynoImplCopyWithImpl<$Res>
    extends _$SynoCopyWithImpl<$Res, _$SynoImpl>
    implements _$$SynoImplCopyWith<$Res> {
  __$$SynoImplCopyWithImpl(_$SynoImpl _value, $Res Function(_$SynoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pos = null,
    Object? tran = null,
    Object? hwds = null,
  }) {
    return _then(_$SynoImpl(
      pos: null == pos
          ? _value.pos
          : pos // ignore: cast_nullable_to_non_nullable
              as String,
      tran: null == tran
          ? _value.tran
          : tran // ignore: cast_nullable_to_non_nullable
              as String,
      hwds: null == hwds
          ? _value._hwds
          : hwds // ignore: cast_nullable_to_non_nullable
              as List<Hwd>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SynoImpl implements _Syno {
  const _$SynoImpl(
      {required this.pos, required this.tran, final List<Hwd> hwds = const []})
      : _hwds = hwds;

  factory _$SynoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SynoImplFromJson(json);

  @override
  final String pos;
// 词性
  @override
  final String tran;
// 释义
  final List<Hwd> _hwds;
// 释义
  @override
  @JsonKey()
  List<Hwd> get hwds {
    if (_hwds is EqualUnmodifiableListView) return _hwds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hwds);
  }

  @override
  String toString() {
    return 'Syno(pos: $pos, tran: $tran, hwds: $hwds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SynoImpl &&
            (identical(other.pos, pos) || other.pos == pos) &&
            (identical(other.tran, tran) || other.tran == tran) &&
            const DeepCollectionEquality().equals(other._hwds, _hwds));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, pos, tran, const DeepCollectionEquality().hash(_hwds));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SynoImplCopyWith<_$SynoImpl> get copyWith =>
      __$$SynoImplCopyWithImpl<_$SynoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SynoImplToJson(
      this,
    );
  }
}

abstract class _Syno implements Syno {
  const factory _Syno(
      {required final String pos,
      required final String tran,
      final List<Hwd> hwds}) = _$SynoImpl;

  factory _Syno.fromJson(Map<String, dynamic> json) = _$SynoImpl.fromJson;

  @override
  String get pos;
  @override // 词性
  String get tran;
  @override // 释义
  List<Hwd> get hwds;
  @override
  @JsonKey(ignore: true)
  _$$SynoImplCopyWith<_$SynoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Hwd _$HwdFromJson(Map<String, dynamic> json) {
  return _Hwd.fromJson(json);
}

/// @nodoc
mixin _$Hwd {
  String get w => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HwdCopyWith<Hwd> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HwdCopyWith<$Res> {
  factory $HwdCopyWith(Hwd value, $Res Function(Hwd) then) =
      _$HwdCopyWithImpl<$Res, Hwd>;
  @useResult
  $Res call({String w});
}

/// @nodoc
class _$HwdCopyWithImpl<$Res, $Val extends Hwd> implements $HwdCopyWith<$Res> {
  _$HwdCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? w = null,
  }) {
    return _then(_value.copyWith(
      w: null == w
          ? _value.w
          : w // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HwdImplCopyWith<$Res> implements $HwdCopyWith<$Res> {
  factory _$$HwdImplCopyWith(_$HwdImpl value, $Res Function(_$HwdImpl) then) =
      __$$HwdImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String w});
}

/// @nodoc
class __$$HwdImplCopyWithImpl<$Res> extends _$HwdCopyWithImpl<$Res, _$HwdImpl>
    implements _$$HwdImplCopyWith<$Res> {
  __$$HwdImplCopyWithImpl(_$HwdImpl _value, $Res Function(_$HwdImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? w = null,
  }) {
    return _then(_$HwdImpl(
      w: null == w
          ? _value.w
          : w // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HwdImpl implements _Hwd {
  const _$HwdImpl({required this.w});

  factory _$HwdImpl.fromJson(Map<String, dynamic> json) =>
      _$$HwdImplFromJson(json);

  @override
  final String w;

  @override
  String toString() {
    return 'Hwd(w: $w)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HwdImpl &&
            (identical(other.w, w) || other.w == w));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, w);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HwdImplCopyWith<_$HwdImpl> get copyWith =>
      __$$HwdImplCopyWithImpl<_$HwdImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HwdImplToJson(
      this,
    );
  }
}

abstract class _Hwd implements Hwd {
  const factory _Hwd({required final String w}) = _$HwdImpl;

  factory _Hwd.fromJson(Map<String, dynamic> json) = _$HwdImpl.fromJson;

  @override
  String get w;
  @override
  @JsonKey(ignore: true)
  _$$HwdImplCopyWith<_$HwdImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RelWord _$RelWordFromJson(Map<String, dynamic> json) {
  return _RelWord.fromJson(json);
}

/// @nodoc
mixin _$RelWord {
  String get pos => throw _privateConstructorUsedError; // 词性
  List<RelatedWord> get words => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RelWordCopyWith<RelWord> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RelWordCopyWith<$Res> {
  factory $RelWordCopyWith(RelWord value, $Res Function(RelWord) then) =
      _$RelWordCopyWithImpl<$Res, RelWord>;
  @useResult
  $Res call({String pos, List<RelatedWord> words});
}

/// @nodoc
class _$RelWordCopyWithImpl<$Res, $Val extends RelWord>
    implements $RelWordCopyWith<$Res> {
  _$RelWordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pos = null,
    Object? words = null,
  }) {
    return _then(_value.copyWith(
      pos: null == pos
          ? _value.pos
          : pos // ignore: cast_nullable_to_non_nullable
              as String,
      words: null == words
          ? _value.words
          : words // ignore: cast_nullable_to_non_nullable
              as List<RelatedWord>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RelWordImplCopyWith<$Res> implements $RelWordCopyWith<$Res> {
  factory _$$RelWordImplCopyWith(
          _$RelWordImpl value, $Res Function(_$RelWordImpl) then) =
      __$$RelWordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String pos, List<RelatedWord> words});
}

/// @nodoc
class __$$RelWordImplCopyWithImpl<$Res>
    extends _$RelWordCopyWithImpl<$Res, _$RelWordImpl>
    implements _$$RelWordImplCopyWith<$Res> {
  __$$RelWordImplCopyWithImpl(
      _$RelWordImpl _value, $Res Function(_$RelWordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pos = null,
    Object? words = null,
  }) {
    return _then(_$RelWordImpl(
      pos: null == pos
          ? _value.pos
          : pos // ignore: cast_nullable_to_non_nullable
              as String,
      words: null == words
          ? _value._words
          : words // ignore: cast_nullable_to_non_nullable
              as List<RelatedWord>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RelWordImpl implements _RelWord {
  const _$RelWordImpl(
      {required this.pos, final List<RelatedWord> words = const []})
      : _words = words;

  factory _$RelWordImpl.fromJson(Map<String, dynamic> json) =>
      _$$RelWordImplFromJson(json);

  @override
  final String pos;
// 词性
  final List<RelatedWord> _words;
// 词性
  @override
  @JsonKey()
  List<RelatedWord> get words {
    if (_words is EqualUnmodifiableListView) return _words;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_words);
  }

  @override
  String toString() {
    return 'RelWord(pos: $pos, words: $words)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RelWordImpl &&
            (identical(other.pos, pos) || other.pos == pos) &&
            const DeepCollectionEquality().equals(other._words, _words));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, pos, const DeepCollectionEquality().hash(_words));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RelWordImplCopyWith<_$RelWordImpl> get copyWith =>
      __$$RelWordImplCopyWithImpl<_$RelWordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RelWordImplToJson(
      this,
    );
  }
}

abstract class _RelWord implements RelWord {
  const factory _RelWord(
      {required final String pos,
      final List<RelatedWord> words}) = _$RelWordImpl;

  factory _RelWord.fromJson(Map<String, dynamic> json) = _$RelWordImpl.fromJson;

  @override
  String get pos;
  @override // 词性
  List<RelatedWord> get words;
  @override
  @JsonKey(ignore: true)
  _$$RelWordImplCopyWith<_$RelWordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RelatedWord _$RelatedWordFromJson(Map<String, dynamic> json) {
  return _RelatedWord.fromJson(json);
}

/// @nodoc
mixin _$RelatedWord {
  String get hwd => throw _privateConstructorUsedError; // 单词
  String get tran => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RelatedWordCopyWith<RelatedWord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RelatedWordCopyWith<$Res> {
  factory $RelatedWordCopyWith(
          RelatedWord value, $Res Function(RelatedWord) then) =
      _$RelatedWordCopyWithImpl<$Res, RelatedWord>;
  @useResult
  $Res call({String hwd, String tran});
}

/// @nodoc
class _$RelatedWordCopyWithImpl<$Res, $Val extends RelatedWord>
    implements $RelatedWordCopyWith<$Res> {
  _$RelatedWordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hwd = null,
    Object? tran = null,
  }) {
    return _then(_value.copyWith(
      hwd: null == hwd
          ? _value.hwd
          : hwd // ignore: cast_nullable_to_non_nullable
              as String,
      tran: null == tran
          ? _value.tran
          : tran // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RelatedWordImplCopyWith<$Res>
    implements $RelatedWordCopyWith<$Res> {
  factory _$$RelatedWordImplCopyWith(
          _$RelatedWordImpl value, $Res Function(_$RelatedWordImpl) then) =
      __$$RelatedWordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String hwd, String tran});
}

/// @nodoc
class __$$RelatedWordImplCopyWithImpl<$Res>
    extends _$RelatedWordCopyWithImpl<$Res, _$RelatedWordImpl>
    implements _$$RelatedWordImplCopyWith<$Res> {
  __$$RelatedWordImplCopyWithImpl(
      _$RelatedWordImpl _value, $Res Function(_$RelatedWordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hwd = null,
    Object? tran = null,
  }) {
    return _then(_$RelatedWordImpl(
      hwd: null == hwd
          ? _value.hwd
          : hwd // ignore: cast_nullable_to_non_nullable
              as String,
      tran: null == tran
          ? _value.tran
          : tran // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RelatedWordImpl implements _RelatedWord {
  const _$RelatedWordImpl({required this.hwd, required this.tran});

  factory _$RelatedWordImpl.fromJson(Map<String, dynamic> json) =>
      _$$RelatedWordImplFromJson(json);

  @override
  final String hwd;
// 单词
  @override
  final String tran;

  @override
  String toString() {
    return 'RelatedWord(hwd: $hwd, tran: $tran)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RelatedWordImpl &&
            (identical(other.hwd, hwd) || other.hwd == hwd) &&
            (identical(other.tran, tran) || other.tran == tran));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, hwd, tran);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RelatedWordImplCopyWith<_$RelatedWordImpl> get copyWith =>
      __$$RelatedWordImplCopyWithImpl<_$RelatedWordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RelatedWordImplToJson(
      this,
    );
  }
}

abstract class _RelatedWord implements RelatedWord {
  const factory _RelatedWord(
      {required final String hwd,
      required final String tran}) = _$RelatedWordImpl;

  factory _RelatedWord.fromJson(Map<String, dynamic> json) =
      _$RelatedWordImpl.fromJson;

  @override
  String get hwd;
  @override // 单词
  String get tran;
  @override
  @JsonKey(ignore: true)
  _$$RelatedWordImplCopyWith<_$RelatedWordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Exam _$ExamFromJson(Map<String, dynamic> json) {
  return _Exam.fromJson(json);
}

/// @nodoc
mixin _$Exam {
  String get question => throw _privateConstructorUsedError; // 题目
  Answer get answer => throw _privateConstructorUsedError; // 答案
  int get examType => throw _privateConstructorUsedError; // 题目类型
  List<Choice> get choices => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExamCopyWith<Exam> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExamCopyWith<$Res> {
  factory $ExamCopyWith(Exam value, $Res Function(Exam) then) =
      _$ExamCopyWithImpl<$Res, Exam>;
  @useResult
  $Res call(
      {String question, Answer answer, int examType, List<Choice> choices});

  $AnswerCopyWith<$Res> get answer;
}

/// @nodoc
class _$ExamCopyWithImpl<$Res, $Val extends Exam>
    implements $ExamCopyWith<$Res> {
  _$ExamCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? question = null,
    Object? answer = null,
    Object? examType = null,
    Object? choices = null,
  }) {
    return _then(_value.copyWith(
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      answer: null == answer
          ? _value.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as Answer,
      examType: null == examType
          ? _value.examType
          : examType // ignore: cast_nullable_to_non_nullable
              as int,
      choices: null == choices
          ? _value.choices
          : choices // ignore: cast_nullable_to_non_nullable
              as List<Choice>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AnswerCopyWith<$Res> get answer {
    return $AnswerCopyWith<$Res>(_value.answer, (value) {
      return _then(_value.copyWith(answer: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ExamImplCopyWith<$Res> implements $ExamCopyWith<$Res> {
  factory _$$ExamImplCopyWith(
          _$ExamImpl value, $Res Function(_$ExamImpl) then) =
      __$$ExamImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String question, Answer answer, int examType, List<Choice> choices});

  @override
  $AnswerCopyWith<$Res> get answer;
}

/// @nodoc
class __$$ExamImplCopyWithImpl<$Res>
    extends _$ExamCopyWithImpl<$Res, _$ExamImpl>
    implements _$$ExamImplCopyWith<$Res> {
  __$$ExamImplCopyWithImpl(_$ExamImpl _value, $Res Function(_$ExamImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? question = null,
    Object? answer = null,
    Object? examType = null,
    Object? choices = null,
  }) {
    return _then(_$ExamImpl(
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      answer: null == answer
          ? _value.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as Answer,
      examType: null == examType
          ? _value.examType
          : examType // ignore: cast_nullable_to_non_nullable
              as int,
      choices: null == choices
          ? _value._choices
          : choices // ignore: cast_nullable_to_non_nullable
              as List<Choice>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExamImpl implements _Exam {
  const _$ExamImpl(
      {required this.question,
      required this.answer,
      required this.examType,
      final List<Choice> choices = const []})
      : _choices = choices;

  factory _$ExamImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExamImplFromJson(json);

  @override
  final String question;
// 题目
  @override
  final Answer answer;
// 答案
  @override
  final int examType;
// 题目类型
  final List<Choice> _choices;
// 题目类型
  @override
  @JsonKey()
  List<Choice> get choices {
    if (_choices is EqualUnmodifiableListView) return _choices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_choices);
  }

  @override
  String toString() {
    return 'Exam(question: $question, answer: $answer, examType: $examType, choices: $choices)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExamImpl &&
            (identical(other.question, question) ||
                other.question == question) &&
            (identical(other.answer, answer) || other.answer == answer) &&
            (identical(other.examType, examType) ||
                other.examType == examType) &&
            const DeepCollectionEquality().equals(other._choices, _choices));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, question, answer, examType,
      const DeepCollectionEquality().hash(_choices));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExamImplCopyWith<_$ExamImpl> get copyWith =>
      __$$ExamImplCopyWithImpl<_$ExamImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExamImplToJson(
      this,
    );
  }
}

abstract class _Exam implements Exam {
  const factory _Exam(
      {required final String question,
      required final Answer answer,
      required final int examType,
      final List<Choice> choices}) = _$ExamImpl;

  factory _Exam.fromJson(Map<String, dynamic> json) = _$ExamImpl.fromJson;

  @override
  String get question;
  @override // 题目
  Answer get answer;
  @override // 答案
  int get examType;
  @override // 题目类型
  List<Choice> get choices;
  @override
  @JsonKey(ignore: true)
  _$$ExamImplCopyWith<_$ExamImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Answer _$AnswerFromJson(Map<String, dynamic> json) {
  return _Answer.fromJson(json);
}

/// @nodoc
mixin _$Answer {
  String get explain => throw _privateConstructorUsedError; // 解释
  int get rightIndex => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AnswerCopyWith<Answer> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnswerCopyWith<$Res> {
  factory $AnswerCopyWith(Answer value, $Res Function(Answer) then) =
      _$AnswerCopyWithImpl<$Res, Answer>;
  @useResult
  $Res call({String explain, int rightIndex});
}

/// @nodoc
class _$AnswerCopyWithImpl<$Res, $Val extends Answer>
    implements $AnswerCopyWith<$Res> {
  _$AnswerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? explain = null,
    Object? rightIndex = null,
  }) {
    return _then(_value.copyWith(
      explain: null == explain
          ? _value.explain
          : explain // ignore: cast_nullable_to_non_nullable
              as String,
      rightIndex: null == rightIndex
          ? _value.rightIndex
          : rightIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AnswerImplCopyWith<$Res> implements $AnswerCopyWith<$Res> {
  factory _$$AnswerImplCopyWith(
          _$AnswerImpl value, $Res Function(_$AnswerImpl) then) =
      __$$AnswerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String explain, int rightIndex});
}

/// @nodoc
class __$$AnswerImplCopyWithImpl<$Res>
    extends _$AnswerCopyWithImpl<$Res, _$AnswerImpl>
    implements _$$AnswerImplCopyWith<$Res> {
  __$$AnswerImplCopyWithImpl(
      _$AnswerImpl _value, $Res Function(_$AnswerImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? explain = null,
    Object? rightIndex = null,
  }) {
    return _then(_$AnswerImpl(
      explain: null == explain
          ? _value.explain
          : explain // ignore: cast_nullable_to_non_nullable
              as String,
      rightIndex: null == rightIndex
          ? _value.rightIndex
          : rightIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnswerImpl implements _Answer {
  const _$AnswerImpl({required this.explain, required this.rightIndex});

  factory _$AnswerImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnswerImplFromJson(json);

  @override
  final String explain;
// 解释
  @override
  final int rightIndex;

  @override
  String toString() {
    return 'Answer(explain: $explain, rightIndex: $rightIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnswerImpl &&
            (identical(other.explain, explain) || other.explain == explain) &&
            (identical(other.rightIndex, rightIndex) ||
                other.rightIndex == rightIndex));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, explain, rightIndex);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AnswerImplCopyWith<_$AnswerImpl> get copyWith =>
      __$$AnswerImplCopyWithImpl<_$AnswerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnswerImplToJson(
      this,
    );
  }
}

abstract class _Answer implements Answer {
  const factory _Answer(
      {required final String explain,
      required final int rightIndex}) = _$AnswerImpl;

  factory _Answer.fromJson(Map<String, dynamic> json) = _$AnswerImpl.fromJson;

  @override
  String get explain;
  @override // 解释
  int get rightIndex;
  @override
  @JsonKey(ignore: true)
  _$$AnswerImplCopyWith<_$AnswerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Choice _$ChoiceFromJson(Map<String, dynamic> json) {
  return _Choice.fromJson(json);
}

/// @nodoc
mixin _$Choice {
  int get choiceIndex => throw _privateConstructorUsedError; // 选项索引
  String get choice => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChoiceCopyWith<Choice> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChoiceCopyWith<$Res> {
  factory $ChoiceCopyWith(Choice value, $Res Function(Choice) then) =
      _$ChoiceCopyWithImpl<$Res, Choice>;
  @useResult
  $Res call({int choiceIndex, String choice});
}

/// @nodoc
class _$ChoiceCopyWithImpl<$Res, $Val extends Choice>
    implements $ChoiceCopyWith<$Res> {
  _$ChoiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? choiceIndex = null,
    Object? choice = null,
  }) {
    return _then(_value.copyWith(
      choiceIndex: null == choiceIndex
          ? _value.choiceIndex
          : choiceIndex // ignore: cast_nullable_to_non_nullable
              as int,
      choice: null == choice
          ? _value.choice
          : choice // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChoiceImplCopyWith<$Res> implements $ChoiceCopyWith<$Res> {
  factory _$$ChoiceImplCopyWith(
          _$ChoiceImpl value, $Res Function(_$ChoiceImpl) then) =
      __$$ChoiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int choiceIndex, String choice});
}

/// @nodoc
class __$$ChoiceImplCopyWithImpl<$Res>
    extends _$ChoiceCopyWithImpl<$Res, _$ChoiceImpl>
    implements _$$ChoiceImplCopyWith<$Res> {
  __$$ChoiceImplCopyWithImpl(
      _$ChoiceImpl _value, $Res Function(_$ChoiceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? choiceIndex = null,
    Object? choice = null,
  }) {
    return _then(_$ChoiceImpl(
      choiceIndex: null == choiceIndex
          ? _value.choiceIndex
          : choiceIndex // ignore: cast_nullable_to_non_nullable
              as int,
      choice: null == choice
          ? _value.choice
          : choice // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChoiceImpl implements _Choice {
  const _$ChoiceImpl({required this.choiceIndex, required this.choice});

  factory _$ChoiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChoiceImplFromJson(json);

  @override
  final int choiceIndex;
// 选项索引
  @override
  final String choice;

  @override
  String toString() {
    return 'Choice(choiceIndex: $choiceIndex, choice: $choice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChoiceImpl &&
            (identical(other.choiceIndex, choiceIndex) ||
                other.choiceIndex == choiceIndex) &&
            (identical(other.choice, choice) || other.choice == choice));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, choiceIndex, choice);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChoiceImplCopyWith<_$ChoiceImpl> get copyWith =>
      __$$ChoiceImplCopyWithImpl<_$ChoiceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChoiceImplToJson(
      this,
    );
  }
}

abstract class _Choice implements Choice {
  const factory _Choice(
      {required final int choiceIndex,
      required final String choice}) = _$ChoiceImpl;

  factory _Choice.fromJson(Map<String, dynamic> json) = _$ChoiceImpl.fromJson;

  @override
  int get choiceIndex;
  @override // 选项索引
  String get choice;
  @override
  @JsonKey(ignore: true)
  _$$ChoiceImplCopyWith<_$ChoiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PronunciationInfo _$PronunciationInfoFromJson(Map<String, dynamic> json) {
  return _PronunciationInfo.fromJson(json);
}

/// @nodoc
mixin _$PronunciationInfo {
  String? get usphone => throw _privateConstructorUsedError; // 美式音标
  String? get ukphone => throw _privateConstructorUsedError; // 英式音标
  String? get usspeech => throw _privateConstructorUsedError; // 美式发音参数
  String? get ukspeech => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PronunciationInfoCopyWith<PronunciationInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PronunciationInfoCopyWith<$Res> {
  factory $PronunciationInfoCopyWith(
          PronunciationInfo value, $Res Function(PronunciationInfo) then) =
      _$PronunciationInfoCopyWithImpl<$Res, PronunciationInfo>;
  @useResult
  $Res call(
      {String? usphone, String? ukphone, String? usspeech, String? ukspeech});
}

/// @nodoc
class _$PronunciationInfoCopyWithImpl<$Res, $Val extends PronunciationInfo>
    implements $PronunciationInfoCopyWith<$Res> {
  _$PronunciationInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? usphone = freezed,
    Object? ukphone = freezed,
    Object? usspeech = freezed,
    Object? ukspeech = freezed,
  }) {
    return _then(_value.copyWith(
      usphone: freezed == usphone
          ? _value.usphone
          : usphone // ignore: cast_nullable_to_non_nullable
              as String?,
      ukphone: freezed == ukphone
          ? _value.ukphone
          : ukphone // ignore: cast_nullable_to_non_nullable
              as String?,
      usspeech: freezed == usspeech
          ? _value.usspeech
          : usspeech // ignore: cast_nullable_to_non_nullable
              as String?,
      ukspeech: freezed == ukspeech
          ? _value.ukspeech
          : ukspeech // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PronunciationInfoImplCopyWith<$Res>
    implements $PronunciationInfoCopyWith<$Res> {
  factory _$$PronunciationInfoImplCopyWith(_$PronunciationInfoImpl value,
          $Res Function(_$PronunciationInfoImpl) then) =
      __$$PronunciationInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? usphone, String? ukphone, String? usspeech, String? ukspeech});
}

/// @nodoc
class __$$PronunciationInfoImplCopyWithImpl<$Res>
    extends _$PronunciationInfoCopyWithImpl<$Res, _$PronunciationInfoImpl>
    implements _$$PronunciationInfoImplCopyWith<$Res> {
  __$$PronunciationInfoImplCopyWithImpl(_$PronunciationInfoImpl _value,
      $Res Function(_$PronunciationInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? usphone = freezed,
    Object? ukphone = freezed,
    Object? usspeech = freezed,
    Object? ukspeech = freezed,
  }) {
    return _then(_$PronunciationInfoImpl(
      usphone: freezed == usphone
          ? _value.usphone
          : usphone // ignore: cast_nullable_to_non_nullable
              as String?,
      ukphone: freezed == ukphone
          ? _value.ukphone
          : ukphone // ignore: cast_nullable_to_non_nullable
              as String?,
      usspeech: freezed == usspeech
          ? _value.usspeech
          : usspeech // ignore: cast_nullable_to_non_nullable
              as String?,
      ukspeech: freezed == ukspeech
          ? _value.ukspeech
          : ukspeech // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PronunciationInfoImpl implements _PronunciationInfo {
  const _$PronunciationInfoImpl(
      {this.usphone, this.ukphone, this.usspeech, this.ukspeech});

  factory _$PronunciationInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PronunciationInfoImplFromJson(json);

  @override
  final String? usphone;
// 美式音标
  @override
  final String? ukphone;
// 英式音标
  @override
  final String? usspeech;
// 美式发音参数
  @override
  final String? ukspeech;

  @override
  String toString() {
    return 'PronunciationInfo(usphone: $usphone, ukphone: $ukphone, usspeech: $usspeech, ukspeech: $ukspeech)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PronunciationInfoImpl &&
            (identical(other.usphone, usphone) || other.usphone == usphone) &&
            (identical(other.ukphone, ukphone) || other.ukphone == ukphone) &&
            (identical(other.usspeech, usspeech) ||
                other.usspeech == usspeech) &&
            (identical(other.ukspeech, ukspeech) ||
                other.ukspeech == ukspeech));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, usphone, ukphone, usspeech, ukspeech);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PronunciationInfoImplCopyWith<_$PronunciationInfoImpl> get copyWith =>
      __$$PronunciationInfoImplCopyWithImpl<_$PronunciationInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PronunciationInfoImplToJson(
      this,
    );
  }
}

abstract class _PronunciationInfo implements PronunciationInfo {
  const factory _PronunciationInfo(
      {final String? usphone,
      final String? ukphone,
      final String? usspeech,
      final String? ukspeech}) = _$PronunciationInfoImpl;

  factory _PronunciationInfo.fromJson(Map<String, dynamic> json) =
      _$PronunciationInfoImpl.fromJson;

  @override
  String? get usphone;
  @override // 美式音标
  String? get ukphone;
  @override // 英式音标
  String? get usspeech;
  @override // 美式发音参数
  String? get ukspeech;
  @override
  @JsonKey(ignore: true)
  _$$PronunciationInfoImplCopyWith<_$PronunciationInfoImpl> get copyWith =>
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
  String get wordId => throw _privateConstructorUsedError; // 单词唯一标识符
  String get bookId => throw _privateConstructorUsedError; // 单词书ID
  int get wordRank => throw _privateConstructorUsedError; // 单词序号
  String get headWord => throw _privateConstructorUsedError; // 单词本身
  String? get usphone => throw _privateConstructorUsedError; // 美式音标
  String? get ukphone => throw _privateConstructorUsedError; // 英式音标
  String? get usspeech => throw _privateConstructorUsedError; // 美式发音参数
  String? get ukspeech => throw _privateConstructorUsedError; // 英式发音参数
  List<Trans> get trans => throw _privateConstructorUsedError; // 释义列表
  List<KajSentence> get sentences => throw _privateConstructorUsedError; // 例句列表
  List<KajPhrase> get phrases => throw _privateConstructorUsedError; // 短语列表
  List<Syno> get synonyms => throw _privateConstructorUsedError; // 同近义词列表
  List<RelWord> get relWords => throw _privateConstructorUsedError; // 同根词列表
  List<Exam> get exams => throw _privateConstructorUsedError;

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
      String wordId,
      String bookId,
      int wordRank,
      String headWord,
      String? usphone,
      String? ukphone,
      String? usspeech,
      String? ukspeech,
      List<Trans> trans,
      List<KajSentence> sentences,
      List<KajPhrase> phrases,
      List<Syno> synonyms,
      List<RelWord> relWords,
      List<Exam> exams});
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
    Object? wordId = null,
    Object? bookId = null,
    Object? wordRank = null,
    Object? headWord = null,
    Object? usphone = freezed,
    Object? ukphone = freezed,
    Object? usspeech = freezed,
    Object? ukspeech = freezed,
    Object? trans = null,
    Object? sentences = null,
    Object? phrases = null,
    Object? synonyms = null,
    Object? relWords = null,
    Object? exams = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      wordId: null == wordId
          ? _value.wordId
          : wordId // ignore: cast_nullable_to_non_nullable
              as String,
      bookId: null == bookId
          ? _value.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      wordRank: null == wordRank
          ? _value.wordRank
          : wordRank // ignore: cast_nullable_to_non_nullable
              as int,
      headWord: null == headWord
          ? _value.headWord
          : headWord // ignore: cast_nullable_to_non_nullable
              as String,
      usphone: freezed == usphone
          ? _value.usphone
          : usphone // ignore: cast_nullable_to_non_nullable
              as String?,
      ukphone: freezed == ukphone
          ? _value.ukphone
          : ukphone // ignore: cast_nullable_to_non_nullable
              as String?,
      usspeech: freezed == usspeech
          ? _value.usspeech
          : usspeech // ignore: cast_nullable_to_non_nullable
              as String?,
      ukspeech: freezed == ukspeech
          ? _value.ukspeech
          : ukspeech // ignore: cast_nullable_to_non_nullable
              as String?,
      trans: null == trans
          ? _value.trans
          : trans // ignore: cast_nullable_to_non_nullable
              as List<Trans>,
      sentences: null == sentences
          ? _value.sentences
          : sentences // ignore: cast_nullable_to_non_nullable
              as List<KajSentence>,
      phrases: null == phrases
          ? _value.phrases
          : phrases // ignore: cast_nullable_to_non_nullable
              as List<KajPhrase>,
      synonyms: null == synonyms
          ? _value.synonyms
          : synonyms // ignore: cast_nullable_to_non_nullable
              as List<Syno>,
      relWords: null == relWords
          ? _value.relWords
          : relWords // ignore: cast_nullable_to_non_nullable
              as List<RelWord>,
      exams: null == exams
          ? _value.exams
          : exams // ignore: cast_nullable_to_non_nullable
              as List<Exam>,
    ) as $Val);
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
      String wordId,
      String bookId,
      int wordRank,
      String headWord,
      String? usphone,
      String? ukphone,
      String? usspeech,
      String? ukspeech,
      List<Trans> trans,
      List<KajSentence> sentences,
      List<KajPhrase> phrases,
      List<Syno> synonyms,
      List<RelWord> relWords,
      List<Exam> exams});
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
    Object? wordId = null,
    Object? bookId = null,
    Object? wordRank = null,
    Object? headWord = null,
    Object? usphone = freezed,
    Object? ukphone = freezed,
    Object? usspeech = freezed,
    Object? ukspeech = freezed,
    Object? trans = null,
    Object? sentences = null,
    Object? phrases = null,
    Object? synonyms = null,
    Object? relWords = null,
    Object? exams = null,
  }) {
    return _then(_$WordModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      wordId: null == wordId
          ? _value.wordId
          : wordId // ignore: cast_nullable_to_non_nullable
              as String,
      bookId: null == bookId
          ? _value.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      wordRank: null == wordRank
          ? _value.wordRank
          : wordRank // ignore: cast_nullable_to_non_nullable
              as int,
      headWord: null == headWord
          ? _value.headWord
          : headWord // ignore: cast_nullable_to_non_nullable
              as String,
      usphone: freezed == usphone
          ? _value.usphone
          : usphone // ignore: cast_nullable_to_non_nullable
              as String?,
      ukphone: freezed == ukphone
          ? _value.ukphone
          : ukphone // ignore: cast_nullable_to_non_nullable
              as String?,
      usspeech: freezed == usspeech
          ? _value.usspeech
          : usspeech // ignore: cast_nullable_to_non_nullable
              as String?,
      ukspeech: freezed == ukspeech
          ? _value.ukspeech
          : ukspeech // ignore: cast_nullable_to_non_nullable
              as String?,
      trans: null == trans
          ? _value._trans
          : trans // ignore: cast_nullable_to_non_nullable
              as List<Trans>,
      sentences: null == sentences
          ? _value._sentences
          : sentences // ignore: cast_nullable_to_non_nullable
              as List<KajSentence>,
      phrases: null == phrases
          ? _value._phrases
          : phrases // ignore: cast_nullable_to_non_nullable
              as List<KajPhrase>,
      synonyms: null == synonyms
          ? _value._synonyms
          : synonyms // ignore: cast_nullable_to_non_nullable
              as List<Syno>,
      relWords: null == relWords
          ? _value._relWords
          : relWords // ignore: cast_nullable_to_non_nullable
              as List<RelWord>,
      exams: null == exams
          ? _value._exams
          : exams // ignore: cast_nullable_to_non_nullable
              as List<Exam>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WordModelImpl implements _WordModel {
  const _$WordModelImpl(
      {required this.id,
      required this.wordId,
      required this.bookId,
      required this.wordRank,
      required this.headWord,
      this.usphone,
      this.ukphone,
      this.usspeech,
      this.ukspeech,
      final List<Trans> trans = const [],
      final List<KajSentence> sentences = const [],
      final List<KajPhrase> phrases = const [],
      final List<Syno> synonyms = const [],
      final List<RelWord> relWords = const [],
      final List<Exam> exams = const []})
      : _trans = trans,
        _sentences = sentences,
        _phrases = phrases,
        _synonyms = synonyms,
        _relWords = relWords,
        _exams = exams;

  factory _$WordModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WordModelImplFromJson(json);

  @override
  final int id;
  @override
  final String wordId;
// 单词唯一标识符
  @override
  final String bookId;
// 单词书ID
  @override
  final int wordRank;
// 单词序号
  @override
  final String headWord;
// 单词本身
  @override
  final String? usphone;
// 美式音标
  @override
  final String? ukphone;
// 英式音标
  @override
  final String? usspeech;
// 美式发音参数
  @override
  final String? ukspeech;
// 英式发音参数
  final List<Trans> _trans;
// 英式发音参数
  @override
  @JsonKey()
  List<Trans> get trans {
    if (_trans is EqualUnmodifiableListView) return _trans;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_trans);
  }

// 释义列表
  final List<KajSentence> _sentences;
// 释义列表
  @override
  @JsonKey()
  List<KajSentence> get sentences {
    if (_sentences is EqualUnmodifiableListView) return _sentences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sentences);
  }

// 例句列表
  final List<KajPhrase> _phrases;
// 例句列表
  @override
  @JsonKey()
  List<KajPhrase> get phrases {
    if (_phrases is EqualUnmodifiableListView) return _phrases;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_phrases);
  }

// 短语列表
  final List<Syno> _synonyms;
// 短语列表
  @override
  @JsonKey()
  List<Syno> get synonyms {
    if (_synonyms is EqualUnmodifiableListView) return _synonyms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_synonyms);
  }

// 同近义词列表
  final List<RelWord> _relWords;
// 同近义词列表
  @override
  @JsonKey()
  List<RelWord> get relWords {
    if (_relWords is EqualUnmodifiableListView) return _relWords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_relWords);
  }

// 同根词列表
  final List<Exam> _exams;
// 同根词列表
  @override
  @JsonKey()
  List<Exam> get exams {
    if (_exams is EqualUnmodifiableListView) return _exams;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exams);
  }

  @override
  String toString() {
    return 'WordModel(id: $id, wordId: $wordId, bookId: $bookId, wordRank: $wordRank, headWord: $headWord, usphone: $usphone, ukphone: $ukphone, usspeech: $usspeech, ukspeech: $ukspeech, trans: $trans, sentences: $sentences, phrases: $phrases, synonyms: $synonyms, relWords: $relWords, exams: $exams)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WordModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.wordId, wordId) || other.wordId == wordId) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.wordRank, wordRank) ||
                other.wordRank == wordRank) &&
            (identical(other.headWord, headWord) ||
                other.headWord == headWord) &&
            (identical(other.usphone, usphone) || other.usphone == usphone) &&
            (identical(other.ukphone, ukphone) || other.ukphone == ukphone) &&
            (identical(other.usspeech, usspeech) ||
                other.usspeech == usspeech) &&
            (identical(other.ukspeech, ukspeech) ||
                other.ukspeech == ukspeech) &&
            const DeepCollectionEquality().equals(other._trans, _trans) &&
            const DeepCollectionEquality()
                .equals(other._sentences, _sentences) &&
            const DeepCollectionEquality().equals(other._phrases, _phrases) &&
            const DeepCollectionEquality().equals(other._synonyms, _synonyms) &&
            const DeepCollectionEquality().equals(other._relWords, _relWords) &&
            const DeepCollectionEquality().equals(other._exams, _exams));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      wordId,
      bookId,
      wordRank,
      headWord,
      usphone,
      ukphone,
      usspeech,
      ukspeech,
      const DeepCollectionEquality().hash(_trans),
      const DeepCollectionEquality().hash(_sentences),
      const DeepCollectionEquality().hash(_phrases),
      const DeepCollectionEquality().hash(_synonyms),
      const DeepCollectionEquality().hash(_relWords),
      const DeepCollectionEquality().hash(_exams));

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
      required final String wordId,
      required final String bookId,
      required final int wordRank,
      required final String headWord,
      final String? usphone,
      final String? ukphone,
      final String? usspeech,
      final String? ukspeech,
      final List<Trans> trans,
      final List<KajSentence> sentences,
      final List<KajPhrase> phrases,
      final List<Syno> synonyms,
      final List<RelWord> relWords,
      final List<Exam> exams}) = _$WordModelImpl;

  factory _WordModel.fromJson(Map<String, dynamic> json) =
      _$WordModelImpl.fromJson;

  @override
  int get id;
  @override
  String get wordId;
  @override // 单词唯一标识符
  String get bookId;
  @override // 单词书ID
  int get wordRank;
  @override // 单词序号
  String get headWord;
  @override // 单词本身
  String? get usphone;
  @override // 美式音标
  String? get ukphone;
  @override // 英式音标
  String? get usspeech;
  @override // 美式发音参数
  String? get ukspeech;
  @override // 英式发音参数
  List<Trans> get trans;
  @override // 释义列表
  List<KajSentence> get sentences;
  @override // 例句列表
  List<KajPhrase> get phrases;
  @override // 短语列表
  List<Syno> get synonyms;
  @override // 同近义词列表
  List<RelWord> get relWords;
  @override // 同根词列表
  List<Exam> get exams;
  @override
  @JsonKey(ignore: true)
  _$$WordModelImplCopyWith<_$WordModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
