enum AnkiGrade { again, hard, good, easy }

extension AnkiGradeExtension on AnkiGrade {
  String get label {
    switch (this) {
      case AnkiGrade.again:
        return 'Again';
      case AnkiGrade.hard:
        return 'Hard';
      case AnkiGrade.good:
        return 'Good';
      case AnkiGrade.easy:
        return 'Easy';
    }
  }

  String get reviewHint {
    switch (this) {
      case AnkiGrade.again:
        return '< 1 min';
      case AnkiGrade.hard:
        return '~5 min';
      case AnkiGrade.good:
        return '~1 day';
      case AnkiGrade.easy:
        return '4 days';
    }
  }

  int get quality {
    switch (this) {
      case AnkiGrade.again:
        return 1;
      case AnkiGrade.hard:
        return 2;
      case AnkiGrade.good:
        return 4;
      case AnkiGrade.easy:
        return 5;
    }
  }

  bool get isMistake {
    return this == AnkiGrade.again || this == AnkiGrade.hard;
  }
}
