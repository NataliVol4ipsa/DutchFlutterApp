import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:dutch_app/core/http_clients/vertalennu/models/dutch_to_english_translation.dart';
import 'package:dutch_app/pages/word_editor/online_search/mapping/word_forms.dart';

class OnlineTranslationGroup {
  final List<DutchToEnglishTranslation> values;
  final WordForms? wordForms;
  final PartOfSpeech partOfSpeech;

  OnlineTranslationGroup(this.values, this.wordForms, this.partOfSpeech);
}
