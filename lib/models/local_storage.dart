import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Storage {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> _localFile(String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  static Future<String> read(String fileName) async {
    try {
      final file = await _localFile(fileName);
      final data = await file.readAsString();
      return data;
    } catch (error) {
      throw error;
    }
  }

  static Future<File> write(String fileName, String data) async {
    try {
      final file = await _localFile(fileName);
      return file.writeAsString(data);
    } catch (error) {
      throw error;
    }
  }
}
