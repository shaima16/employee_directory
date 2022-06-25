import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileService {
  static Future<String> getApplicationDataPath() async {
    return (await getApplicationSupportDirectory()).path;
  }
}
