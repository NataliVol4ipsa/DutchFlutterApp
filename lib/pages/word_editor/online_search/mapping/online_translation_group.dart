import 'package:dutch_app/core/types/word_type.dart';
import 'package:dutch_app/http_clients/vertalennu/models/dutch_to_english_translation.dart';
import 'package:dutch_app/pages/word_editor/online_search/mapping/word_forms.dart';

class OnlineTranslationGroup {
  final List<DutchToEnglishTranslation> values;
  final WordForms? wordForms;
  final WordType partOfSpeech;

  OnlineTranslationGroup(this.values, this.wordForms, this.partOfSpeech);
}
