class SpacedRepetitionAlgorithm {
  static const double minEasinessFactor = 1.3;
  static const double maxEasinessFactor = 2.5;
  static const double defaultEasinessFactor = 2.5;

  static double calculateNewEasinessFactor(
    double currentEasinessFactor,
    int quality,
  ) {
    final easinessFactorDelta =
        0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02);

    var newEasinessFactor = currentEasinessFactor + easinessFactorDelta;

    if (newEasinessFactor < 1.3) newEasinessFactor = 1.3;
    if (newEasinessFactor > 2.5) newEasinessFactor = 2.5;

    return newEasinessFactor;
  }

  static int calculateNewIntervalDays(
    bool isMistake,
    int consecutiveCorrectAnswers,
    double newEasinessFactor,
    int currentIntervalDays, {
    bool isAnkiEasy = false,
  }) {
    if (isMistake) return 1;
    if (consecutiveCorrectAnswers == 1) return 1;
    if (consecutiveCorrectAnswers == 2) return 6;

    final multiplier = isAnkiEasy ? newEasinessFactor * 1.3 : newEasinessFactor;
    return (currentIntervalDays * multiplier).round().clamp(1, 365);
  }
}
