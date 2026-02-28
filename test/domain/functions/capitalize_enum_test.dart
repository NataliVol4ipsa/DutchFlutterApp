import 'package:dutch_app/domain/functions/capitalize_enum.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('capitalizeEnum', () {
    test('capitalizes single-word enum value', () {
      expect(capitalizeEnum(PartOfSpeech.noun), 'Noun');
    });

    test('capitalizes "unspecified"', () {
      expect(capitalizeEnum(PartOfSpeech.unspecified), 'Unspecified');
    });

    test('capitalizes every supported PartOfSpeech value', () {
      for (final value in PartOfSpeech.values) {
        final result = capitalizeEnum(value);
        // First character must be uppercase
        expect(result[0], result[0].toUpperCase(),
            reason: 'First char of $value should be uppercase');
        // Remaining characters must be unchanged (lowercase in these enums)
        expect(result.substring(1), value.name.substring(1),
            reason: 'Tail of $value should be unchanged');
      }
    });
  });
}
