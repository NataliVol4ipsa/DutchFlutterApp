import 'dart:io';
import 'package:dutch_app/core/models/word_collection.dart';
import 'package:dutch_app/io/io_service.dart';
import 'package:dutch_app/io/v1/mapping/words_io_mapper.dart';
import 'package:dutch_app/io/v1/models/export_package_v1.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class WordsIoJsonServiceV1 {
  final ioService = IoService();

  Future<String> exportAsync(
      List<WordCollection> collections, String fileName) async {
    Directory directory = await getExportDirectoryAsync();

    var dataToSerialize = WordsIoMapper.toExportPackageV1(collections);
    String jsonString = jsonEncode(dataToSerialize);

    final path = '${directory.path}/$fileName.json';
    final file = File(path);

    await ioService.writeToFileAsync(file, jsonString);

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

  Future<ExportPackageV1> importAsync(File file) async {
    if (!await file.exists()) {
      throw Exception("File not found: ${file.path}");
    }

    String jsonString = await file.readAsString();
    Map<String, dynamic> jsonData = jsonDecode(jsonString);
    var wordsCollection = ExportPackageV1.fromJson(jsonData);

    return wordsCollection;
  }
}
