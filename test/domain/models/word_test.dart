import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/models/word_noun_details.dart';
import 'package:dutch_app/domain/types/de_het_type.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:flutter_test/flutter_test.dart';

// ── helper ───────────────────────────────────────────────────────────────────

Word _makeNoun(String dutch, {DeHetType deHet = DeHetType.none}) => Word(
  1,
  dutch,
  ['translation'],
  PartOfSpeech.noun,
  nounDetails: WordNounDetails(deHetType: deHet),
  verbDetails: null,
);

Word _makeWord(String dutch, PartOfSpeech pos) =>
    Word(2, dutch, ['translation'], pos, nounDetails: null, verbDetails: null);

// ── tests ─────────────────────────────────────────────────────────────────────

void main() {
  group('Word.toDutchWordString', () {
    test('noun with DeHetType.de returns "de <word>"', () {
      final word = _makeNoun('hond', deHet: DeHetType.de);
      expect(word.toDutchWordString(), 'de hond');
    });

    test('noun with DeHetType.het returns "het <word>"', () {
      final word = _makeNoun('huis', deHet: DeHetType.het);
      expect(word.toDutchWordString(), 'het huis');
    });

    test('noun with DeHetType.none returns just the word', () {
      final word = _makeNoun('kind', deHet: DeHetType.none);
      expect(word.toDutchWordString(), 'kind');
    });

    test('noun with null nounDetails returns just the word', () {
      final word = Word(
        3,
        'tafel',
        ['table'],
        PartOfSpeech.noun,
        nounDetails: null,
        verbDetails: null,
      );
      expect(word.toDutchWordString(), 'tafel');
    });

    test('non-noun returns just the dutch word regardless of details', () {
      final word = _makeWord('lopen', PartOfSpeech.verb);
      expect(word.toDutchWordString(), 'lopen');
    });

    test('unspecified part of speech returns just the dutch word', () {
      final word = _makeWord('snel', PartOfSpeech.unspecified);
      expect(word.toDutchWordString(), 'snel');
    });
  });
}
