import 'package:first_project/core/types/de_het_type.dart';

class GenderConverter {
  static DeHetType convert(String? genderCode) {
    switch (genderCode) {
      case 'm':
        return DeHetType.de;
      case 'n':
        return DeHetType.het;
      default:
        return DeHetType.none;
    }
  }
}
