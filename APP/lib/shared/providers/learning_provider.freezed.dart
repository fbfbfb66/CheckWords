// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'learning_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LearningSessionState {
  bool get isLoading => throw _privateConstructorUsedError;
  WordModel? get currentWord => throw _privateConstructorUsedError;
  List<WordModel> get remainingWords => throw _privateConstructorUsedError;
  int get currentIndex => throw _privateConstructorUsedError;
  int get completedCount => throw _privateConstructorUsedError;
  bool get showAnswer => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  bool get hasFavoritedWords => throw _privateConstructorUsedError;
  bool get allFavoritedMastered => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LearningSessionStateCopyWith<LearningSessionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LearningSessionStateCopyWith<$Res> {
  factory $LearningSessionStateCopyWith(LearningSessionState value,
          $Res Function(LearningSessionState) then) =
      _$LearningSessionStateCopyWithImpl<$Res, LearningSessionState>;
  @useResult
  $Res call(
      {bool isLoading,
      WordModel? currentWord,
      List<WordModel> remainingWords,
      int currentIndex,
      int completedCount,
      bool showAnswer,
      bool isCompleted,
      bool hasFavoritedWords,
      bool allFavoritedMastered});

  $WordModelCopyWith<$Res>? get currentWord;
}

/// @nodoc
class _$LearningSessionStateCopyWithImpl<$Res,
        $Val extends LearningSessionState>
    implements $LearningSessionStateCopyWith<$Res> {
  _$LearningSessionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? currentWord = freezed,
    Object? remainingWords = null,
    Object? currentIndex = null,
    Object? completedCount = null,
    Object? showAnswer = null,
    Object? isCompleted = null,
    Object? hasFavoritedWords = null,
    Object? allFavoritedMastered = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      currentWord: freezed == currentWord
          ? _value.currentWord
          : currentWord // ignore: cast_nullable_to_non_nullable
              as WordModel?,
      remainingWords: null == remainingWords
          ? _value.remainingWords
          : remainingWords // ignore: cast_nullable_to_non_nullable
              as List<WordModel>,
      currentIndex: null == currentIndex
          ? _value.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      completedCount: null == completedCount
          ? _value.completedCount
          : completedCount // ignore: cast_nullable_to_non_nullable
              as int,
      showAnswer: null == showAnswer
          ? _value.showAnswer
          : showAnswer // ignore: cast_nullable_to_non_nullable
              as bool,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      hasFavoritedWords: null == hasFavoritedWords
          ? _value.hasFavoritedWords
          : hasFavoritedWords // ignore: cast_nullable_to_non_nullable
              as bool,
      allFavoritedMastered: null == allFavoritedMastered
          ? _value.allFavoritedMastered
          : allFavoritedMastered // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $WordModelCopyWith<$Res>? get currentWord {
    if (_value.currentWord == null) {
      return null;
    }

    return $WordModelCopyWith<$Res>(_value.currentWord!, (value) {
      return _then(_value.copyWith(currentWord: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LearningSessionStateImplCopyWith<$Res>
    implements $LearningSessionStateCopyWith<$Res> {
  factory _$$LearningSessionStateImplCopyWith(_$LearningSessionStateImpl value,
          $Res Function(_$LearningSessionStateImpl) then) =
      __$$LearningSessionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      WordModel? currentWord,
      List<WordModel> remainingWords,
      int currentIndex,
      int completedCount,
      bool showAnswer,
      bool isCompleted,
      bool hasFavoritedWords,
      bool allFavoritedMastered});

  @override
  $WordModelCopyWith<$Res>? get currentWord;
}

/// @nodoc
class __$$LearningSessionStateImplCopyWithImpl<$Res>
    extends _$LearningSessionStateCopyWithImpl<$Res, _$LearningSessionStateImpl>
    implements _$$LearningSessionStateImplCopyWith<$Res> {
  __$$LearningSessionStateImplCopyWithImpl(_$LearningSessionStateImpl _value,
      $Res Function(_$LearningSessionStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? currentWord = freezed,
    Object? remainingWords = null,
    Object? currentIndex = null,
    Object? completedCount = null,
    Object? showAnswer = null,
    Object? isCompleted = null,
    Object? hasFavoritedWords = null,
    Object? allFavoritedMastered = null,
  }) {
    return _then(_$LearningSessionStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      currentWord: freezed == currentWord
          ? _value.currentWord
          : currentWord // ignore: cast_nullable_to_non_nullable
              as WordModel?,
      remainingWords: null == remainingWords
          ? _value._remainingWords
          : remainingWords // ignore: cast_nullable_to_non_nullable
              as List<WordModel>,
      currentIndex: null == currentIndex
          ? _value.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      completedCount: null == completedCount
          ? _value.completedCount
          : completedCount // ignore: cast_nullable_to_non_nullable
              as int,
      showAnswer: null == showAnswer
          ? _value.showAnswer
          : showAnswer // ignore: cast_nullable_to_non_nullable
              as bool,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      hasFavoritedWords: null == hasFavoritedWords
          ? _value.hasFavoritedWords
          : hasFavoritedWords // ignore: cast_nullable_to_non_nullable
              as bool,
      allFavoritedMastered: null == allFavoritedMastered
          ? _value.allFavoritedMastered
          : allFavoritedMastered // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$LearningSessionStateImpl extends _LearningSessionState {
  const _$LearningSessionStateImpl(
      {this.isLoading = false,
      this.currentWord,
      final List<WordModel> remainingWords = const [],
      this.currentIndex = 0,
      this.completedCount = 0,
      this.showAnswer = false,
      this.isCompleted = false,
      this.hasFavoritedWords = false,
      this.allFavoritedMastered = false})
      : _remainingWords = remainingWords,
        super._();

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final WordModel? currentWord;
  final List<WordModel> _remainingWords;
  @override
  @JsonKey()
  List<WordModel> get remainingWords {
    if (_remainingWords is EqualUnmodifiableListView) return _remainingWords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_remainingWords);
  }

  @override
  @JsonKey()
  final int currentIndex;
  @override
  @JsonKey()
  final int completedCount;
  @override
  @JsonKey()
  final bool showAnswer;
  @override
  @JsonKey()
  final bool isCompleted;
  @override
  @JsonKey()
  final bool hasFavoritedWords;
  @override
  @JsonKey()
  final bool allFavoritedMastered;

  @override
  String toString() {
    return 'LearningSessionState(isLoading: $isLoading, currentWord: $currentWord, remainingWords: $remainingWords, currentIndex: $currentIndex, completedCount: $completedCount, showAnswer: $showAnswer, isCompleted: $isCompleted, hasFavoritedWords: $hasFavoritedWords, allFavoritedMastered: $allFavoritedMastered)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LearningSessionStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.currentWord, currentWord) ||
                other.currentWord == currentWord) &&
            const DeepCollectionEquality()
                .equals(other._remainingWords, _remainingWords) &&
            (identical(other.currentIndex, currentIndex) ||
                other.currentIndex == currentIndex) &&
            (identical(other.completedCount, completedCount) ||
                other.completedCount == completedCount) &&
            (identical(other.showAnswer, showAnswer) ||
                other.showAnswer == showAnswer) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.hasFavoritedWords, hasFavoritedWords) ||
                other.hasFavoritedWords == hasFavoritedWords) &&
            (identical(other.allFavoritedMastered, allFavoritedMastered) ||
                other.allFavoritedMastered == allFavoritedMastered));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      currentWord,
      const DeepCollectionEquality().hash(_remainingWords),
      currentIndex,
      completedCount,
      showAnswer,
      isCompleted,
      hasFavoritedWords,
      allFavoritedMastered);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LearningSessionStateImplCopyWith<_$LearningSessionStateImpl>
      get copyWith =>
          __$$LearningSessionStateImplCopyWithImpl<_$LearningSessionStateImpl>(
              this, _$identity);
}

abstract class _LearningSessionState extends LearningSessionState {
  const factory _LearningSessionState(
      {final bool isLoading,
      final WordModel? currentWord,
      final List<WordModel> remainingWords,
      final int currentIndex,
      final int completedCount,
      final bool showAnswer,
      final bool isCompleted,
      final bool hasFavoritedWords,
      final bool allFavoritedMastered}) = _$LearningSessionStateImpl;
  const _LearningSessionState._() : super._();

  @override
  bool get isLoading;
  @override
  WordModel? get currentWord;
  @override
  List<WordModel> get remainingWords;
  @override
  int get currentIndex;
  @override
  int get completedCount;
  @override
  bool get showAnswer;
  @override
  bool get isCompleted;
  @override
  bool get hasFavoritedWords;
  @override
  bool get allFavoritedMastered;
  @override
  @JsonKey(ignore: true)
  _$$LearningSessionStateImplCopyWith<_$LearningSessionStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
