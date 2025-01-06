enum DeHetType { none, de, het }

extension DeHetTypeExtension on DeHetType {
  String get label {
    switch (this) {
      case DeHetType.de:
        return 'de';
      case DeHetType.het:
        return 'het';
      case DeHetType.none:
        return 'none';
    }
  }
}
