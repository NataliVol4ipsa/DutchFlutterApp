import 'package:dutch_app/core/models/word_collection.dart';
import 'package:dutch_app/local_db/repositories/word_collections_repository.dart';
import 'package:dutch_app/reusable_widgets/dropdowns/generic_dropdown_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class WordCollectionDropdown extends StatefulWidget {
  final Function updateValueCallback;
  final WordCollection? initialValue;

  const WordCollectionDropdown(
      {super.key, required this.updateValueCallback, this.initialValue});

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

  @override
  Widget build(BuildContext context) {
    return GenericDropdownMenu(
        initialValue: widget.initialValue,
        onValueChanged: updateSelectedWordCollection,
        dropdownValues: wordCollectionDropdownValues,
        displayStringFunc: getCollectionName);
  }
}
