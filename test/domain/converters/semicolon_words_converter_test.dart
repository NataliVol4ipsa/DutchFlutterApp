// ignore_for_file: avoid_relative_lib_imports

import 'package:dutch_app/domain/converters/semicolon_words_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SemicolonWordsConverter.fromString', () {
    test('splits a semicolon-delimited string into a list', () {
      expect(SemicolonWordsConverter.fromString('hond;kat'), ['hond', 'kat']);
    });

    test('trims whitespace around each word', () {
      expect(
        SemicolonWordsConverter.fromString(' hond ; kat '),
        unorderedEquals(['hond', 'kat']),
      );
    });

    test('lowercases each word', () {
      expect(
        SemicolonWordsConverter.fromString('HOND;KAT'),
        unorderedEquals(['hond', 'kat']),
      );
    });

    test('strips "to " infinitive prefix', () {
      expect(
        SemicolonWordsConverter.fromString('to work;to play'),
        unorderedEquals(['work', 'play']),
      );
    });

    test('"to " prefix is stripped case-insensitively after lowercasing', () {
      expect(SemicolonWordsConverter.fromString('To Work'), ['work']);
    });

    test('deduplicates identical words', () {
      final result = SemicolonWordsConverter.fromString('kat;kat');
      expect(result.length, 1);
      expect(result.first, 'kat');
    });

    test('removes empty segments (consecutive semicolons)', () {
      expect(
        SemicolonWordsConverter.fromString('a;;b'),
        unorderedEquals(['a', 'b']),
      );
    });

    test('returns empty list for empty input', () {
      expect(SemicolonWordsConverter.fromString(''), isEmpty);
    });

    test('returns empty list for whitespace-only input', () {
      expect(SemicolonWordsConverter.fromString('   '), isEmpty);
    });

    test('handles single word with no delimiter', () {
      expect(SemicolonWordsConverter.fromString('hond'), ['hond']);
    });
  });

  group('SemicolonWordsConverter.toSingleString', () {
    test('joins a list with semicolons', () {
      expect(SemicolonWordsConverter.toSingleString(['a', 'b', 'c']), 'a;b;c');
    });

    test('returns empty string for empty list', () {
      expect(SemicolonWordsConverter.toSingleString([]), '');
    });

    test('returns single item unchanged', () {
      expect(SemicolonWordsConverter.toSingleString(['hond']), 'hond');
    });
  });

  group('round-trip', () {
    test('fromString(toSingleString(list)) is a no-op', () {
      final words = ['dog', 'puppy'];
      final encoded = SemicolonWordsConverter.toSingleString(words);
      final decoded = SemicolonWordsConverter.fromString(encoded);
      expect(decoded, unorderedEquals(words));
    });
  });
}
