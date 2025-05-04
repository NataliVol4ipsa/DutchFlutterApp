import 'package:dutch_app/domain/types/de_het_type.dart';

class GenderConverter {
  static DeHetType convert(String? genderCode) {
    switch (genderCode) {
      case 'm':
      case 'f':
        return DeHetType.de;
      case 'n':
        return DeHetType.het;
      default:
        return DeHetType.none;
    }
  }
}
