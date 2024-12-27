class SessionSummary {
  final int totalExercises;
  final int correctExercises;
  late double correctPercent;

  SessionSummary(
      {required this.totalExercises, required this.correctExercises}) {
    correctPercent = correctExercises * 100 / totalExercises;
  }
}
