import 'package:dutch_app/domain/models/word_collection.dart';
import 'package:dutch_app/domain/services/collection_permission_service.dart';
import 'package:dutch_app/domain/services/word_collection_sorter.dart';
import 'package:dutch_app/core/local_db/repositories/word_collections_repository.dart';
import 'package:dutch_app/reusable_widgets/dropdowns/generic_dropdown_menu.dart';
import 'package:dutch_app/styles/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WordCollectionDropdown extends StatefulWidget {
  final Function updateValueCallback;
  final WordCollection? initialValue;
  final Widget? prefixIcon;
  final Color? dropdownArrowColor;
  final bool firstOptionGrey;

  const WordCollectionDropdown(
      {super.key,
      required this.updateValueCallback,
      this.initialValue,
      this.prefixIcon,
      this.dropdownArrowColor,
      this.firstOptionGrey = false});

  @override
  State<WordCollectionDropdown> createState() => _WordCollectionDropdownState();
}

class _WordCollectionDropdownState extends State<WordCollectionDropdown> {
  late List<WordCollection> wordCollectionDropdownValues = [];
  late WordCollectionsRepository wordCollectionsRepository;
  WordCollection? selectedWordCollection;

  @override
  void initState() {
    super.initState();
    wordCollectionsRepository = context.read<WordCollectionsRepository>();
    _loadCollections();
  }

  void _loadCollections() async {
    var dbCollections = await wordCollectionsRepository.getAsync();
    WordCollectionSorter.sortCollections(dbCollections);
    setState(() {
      wordCollectionDropdownValues = dbCollections;
    });
  }

  void updateSelectedWordCollection(WordCollection? value) {
    setState(() {
      selectedWordCollection = value;
    });
    widget.updateValueCallback(value);
  }

  String getCollectionName(WordCollection collection) {
    return collection.name;
  }

  static Color? _firstOptionGrey(
      WordCollection collection, BuildContext context) {
    return collection.name == CollectionPermissionService.defaultCollectionName
        ? TextStyles.dropdownGreyTextColor(context)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return GenericDropdownMenu(
      prefixIcon: widget.prefixIcon,
      initialValue: widget.initialValue,
      onValueChanged: updateSelectedWordCollection,
      dropdownValues: wordCollectionDropdownValues,
      displayStringFunc: getCollectionName,
      dropdownArrowColor: widget.dropdownArrowColor,
      dropdownOptionColorGenerator: widget.firstOptionGrey
          ? (WordCollection collection) => _firstOptionGrey(collection, context)
          : null,
    );
  }
}
