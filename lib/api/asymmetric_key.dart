import 'dart:convert';
import 'package:kms/config.dart';
import 'package:kms/models/asymmetric_key.dart';
import 'package:kms/models/page_data.dart';
import 'package:http/http.dart' as http;

Future<PageData<AsymmetricKey>?> getAsymmetricKeys(page, pageSize) async {
  var url =
      Uri.http(baseUrl, 'system/key/api/', {'page': page, 'page_size': pageSize});
  try {
    var res = await http.get(url, headers: {
      'Authorization':
          'Bearer $JWT',
      'Content-Type': 'application/json'
    }).timeout(const Duration(seconds: 5));
    Utf8Decoder utf8decoder = const Utf8Decoder();
    PageData<AsymmetricKey> data = PageData<AsymmetricKey>.fromJson(
        jsonDecode(utf8decoder.convert(res.bodyBytes)), (json) => AsymmetricKey.fromJson(json));
    return data;
  } catch (e) {
    print(e);
    return null;
  }
}
