String capitalizeEnum(Enum value) {
  final valueName = value.name;
  return '${valueName[0].toUpperCase()}${valueName.substring(1)}';
}
