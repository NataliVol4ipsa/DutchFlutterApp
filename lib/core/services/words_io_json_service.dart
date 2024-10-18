import 'dart:io';
import 'package:first_project/core/dtos/word_dto.dart';
import 'package:first_project/core/models/word.dart';
import 'package:first_project/core/dtos/words_collection_dto_v1.dart';
import 'package:first_project/core/services/io_service.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class WordsIoJsonService {
  final ioService = IoService();

  Future<String> exportV1(List<Word> words, String fileName) async {
    Directory directory = await getExportDirectory();

    var dataToSerialize = WordsCollectionDtoV1(
        words.map((word) => WordDto.fromWord(word)).toList());
    String jsonString = jsonEncode(dataToSerialize);

    final path = '${directory.path}/$fileName.json';
    final file = File(path);

    await ioService.writeToFileAsync(file, jsonString);

    print('File saved to: $path');

    return path;
  }

  Future<Directory> getExportDirectory() async {
    if (Platform.isAndroid) {
      return Directory('/storage/emulated/0/Download');
    } else if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    } else {
      throw Exception("Platform is not supported");
    }
  }
}
