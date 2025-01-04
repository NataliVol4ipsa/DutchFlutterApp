import 'package:xml/xml.dart' as xml;

extension XmlExtensionsNullable on xml.XmlElement? {
  xml.XmlElement? findFirst(String sectionName) {
    if (this == null) {
      return null;
    }
    var candidates = this!.findElements(sectionName);
    return candidates.isNotEmpty ? candidates.first : null;
  }

  String? findFirstText(String sectionName) {
    var section = this?.findFirst(sectionName);
    return section?.value;
  }

  xml.XmlElement? findFirstWithChildText(
      String sectionName, String childSectionName, String childSectionValue) {
    if (this == null) return null;

    var sections = this!.findAllElements(sectionName);
    var filteredSections = sections
        .where((element) =>
            element.findFirstText(childSectionName) == childSectionValue)
        .toList();
    if (filteredSections.isEmpty) {
      return null;
    }
    return filteredSections.first;
  }
}

extension XmlExtensions on xml.XmlElement {
  xml.XmlElement? findFirst(String sectionName) {
    var candidates = findElements(sectionName);
    return candidates.isNotEmpty ? candidates.first : null;
  }

  String? findFirstText(String sectionName) {
    var section = findFirst(sectionName);
    return section?.value;
  }

  xml.XmlElement? findFirstWithChildText(
      String sectionName, String childSectionName, String childSectionValue) {
    var sections = findAllElements(sectionName);
    var filteredSections = sections
        .where((element) =>
            element.findFirstText(childSectionName) == childSectionValue)
        .toList();
    if (filteredSections.isEmpty) {
      return null;
    }
    return filteredSections.first;
  }
}

extension XmlDocumentExtensions on xml.XmlDocument {
  xml.XmlElement? findFirstWithChildText(
      String sectionName, String childSectionName, String childSectionValue) {
    var filteredSections =
        findAllWithChildText(sectionName, childSectionName, childSectionValue);
    if (filteredSections.isEmpty) {
      return null;
    }
    return filteredSections.first;
  }

  List<xml.XmlElement> findAllWithChildText(
      String sectionName, String childSectionName, String childSectionValue) {
    var sections = findAllElements(sectionName);
    return sections
        .where((element) =>
            element.findFirstText(childSectionName) == childSectionValue)
        .toList();
  }
}
