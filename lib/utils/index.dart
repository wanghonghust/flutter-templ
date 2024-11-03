import 'package:path_provider/path_provider.dart';

class Utils {
  static Future<String> getFileUrl(String fileName) async {
    final directory = await getDownloadsDirectory();
    return "${directory?.path}/$fileName";
  }
}