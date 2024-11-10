import 'dart:io';
import 'package:first_project/core/models/word.dart';
import 'package:first_project/core/dtos/words_collection_dto_v1.dart';
import 'package:first_project/core/services/io_service.dart';
import 'package:first_project/core/mapping/words_io_mapper.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class WordsIoJsonV1Service {
  final ioService = IoService();

  Future<String> exportAsync(List<Word> words, String fileName) async {
    Directory directory = await getExportDirectoryAsync();

    var dataToSerialize = WordsIoMapper().toCollectionDto(words);
    String jsonString = jsonEncode(dataToSerialize);

    final path = '${directory.path}/$fileName.json';
    final file = File(path);

    await ioService.writeToFileAsync(file, jsonString);

    print('File saved to: $path');

    return path;
  }

  Future<Directory> getExportDirectoryAsync() async {
    if (Platform.isAndroid) {
      return Directory('/storage/emulated/0/Download');
    } else if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    } else {
      throw Exception("Platform is not supported");
    }
  }

  Future<WordsCollectionDtoV1> importAsync(File file) async {
    if (!await file.exists()) {
      throw Exception("File not found: ${file.path}");
    }

    String jsonString = await file.readAsString();
    Map<String, dynamic> jsonData = jsonDecode(jsonString);
    var wordsCollection = WordsCollectionDtoV1.fromJson(jsonData);

    return wordsCollection;
  }
}
