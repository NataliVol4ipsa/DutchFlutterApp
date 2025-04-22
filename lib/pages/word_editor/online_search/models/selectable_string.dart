class SelectableString {
  bool isSelected = false;
  final String value;

  SelectableString({required this.value});

  void select() {
    isSelected = true;
  }

  void unselect() {
    isSelected = false;
  }
}
