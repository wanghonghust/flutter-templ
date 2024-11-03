import 'dart:convert';
import 'package:kms/config.dart';
import 'package:kms/models/logs.dart';
import 'package:kms/models/page_data.dart';
import 'package:http/http.dart' as http;

Future<PageData<Log>?> getLogs(page, pageSize) async {
  var url =
      Uri.http(baseUrl, 'system/log/', {'page': page, 'page_size': pageSize});
  try {
    var res = await http.get(url, headers: {
      'Authorization':
          'Bearer $JWT',
      'Content-Type': 'application/json'
    }).timeout(const Duration(seconds: 5));
    Utf8Decoder utf8decoder = const Utf8Decoder();
    PageData<Log> data = PageData<Log>.fromJson(
        jsonDecode(utf8decoder.convert(res.bodyBytes)), (json) => Log.fromJson(json));
    return data;
  } catch (e) {
    return null;
  }
}
