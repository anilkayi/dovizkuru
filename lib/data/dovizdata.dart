import 'dart:convert';

import 'package:dovizkuru/model/dovizmodel.dart';
import 'package:http/http.dart' as http;

const apikey = 'c95b652f6a8cd270608e5e28';

class DovizApiData {
  Future<Doviz> getCurrentDoviz(String para) async {
    var url =
        Uri.parse('https://v6.exchangerate-api.com/v6/$apikey/latest/$para');

    var response = await http.get(url);
    var body = jsonDecode(response.body);
    return Doviz.fromMap(body);
  }
}
