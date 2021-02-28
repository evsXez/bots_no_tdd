import 'dart:convert';

class HelloResponse {

  static String fromJson(String source) {
    final Map<dynamic,dynamic> obj = json.decode(source);
    return obj['message'];

  }

}