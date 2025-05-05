// import 'package:dutch_app/core/local_db/db_context.dart';
// import 'package:dutch_app/core/local_db/entities/db_dutch_word.dart';
// import 'package:dutch_app/core/local_db/entities/db_english_word.dart';
// import 'package:dutch_app/core/local_db/entities/db_word.dart';
// import 'package:isar/isar.dart';

// class DbWordMigrationPhase2 {
//   static Future<void> runAsync() async {
//     final isar = DbContext.isar;

//     final words = await isar.dbWords.where().findAll();

//     for (final word in words) {
//       // Lookup Dutch word
//       final dutch = await isar.dbDutchWords
//           .where()
//           .wordEqualTo(word.dutchWord.toLowerCase().trim())
//           .findFirst();

//       if (dutch != null) {
//         word.dutchWordLink.value = dutch;
//       }

//       // Lookup English words (may be multiple)
//       final englishWords = word.englishWord
//           .split(';')
//           .map((w) => _cleanEnglishWord(w.trim().toLowerCase()))
//           .toSet();

//       final englishMatches = <DbEnglishWord>[];
//       for (final ew in englishWords) {
//         final english =
//             await isar.dbEnglishWords.where().wordEqualTo(ew).findFirst();
//         if (english != null) {
//           englishMatches.add(english);
//         }
//       }

//       word.englishWordLinks.clear();
//       word.englishWordLinks.addAll(englishMatches);
//     }

//     await isar.writeTxn(() async {
//       for (final word in words) {
//         await word.dutchWordLink.save();
//         await word.englishWordLinks.save();
//         await isar.dbWords.put(word);
//       }
//     });
//   }

//   static String _cleanEnglishWord(String word) {
//     final isInfinitive = word.startsWith('to ');
//     final cleanedWord = isInfinitive ? word.substring(3).trim() : word;
//     return cleanedWord;
//   }
// }
