enum GenderType { none, mannelijk, vrouwelijk, onzijdig }

extension DeHetTypeExtension on GenderType {
  String get letter {
    switch (this) {
      case GenderType.mannelijk:
        return 'm';
      case GenderType.vrouwelijk:
        return 'v';
      case GenderType.onzijdig:
        return 'o';
      case GenderType.none:
        return '';
    }
  }

  String get label {
    switch (this) {
      case GenderType.mannelijk:
        return 'mannelijk';
      case GenderType.vrouwelijk:
        return 'vrouwelijk';
      case GenderType.onzijdig:
        return 'onzijdig';
      case GenderType.none:
        return 'none';
    }
  }

  String get emptyOnNone {
    switch (this) {
      case GenderType.mannelijk:
        return 'mannelijk';
      case GenderType.vrouwelijk:
        return 'vrouwelijk';
      case GenderType.onzijdig:
        return 'onzijdig';
      case GenderType.none:
        return '';
    }
  }
}
