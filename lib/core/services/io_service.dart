import 'dart:io';

import 'package:permission_handler/permission_handler.dart'; //todo move out

class IoService {
  Future<void> requestStoragePermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
    }
  }

  Future<void> writeToFileAsync(File file, String content) async {
    await requestStoragePermission();
    await file.writeAsString(content);
  }
}
