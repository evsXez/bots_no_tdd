import 'dart:convert';

import 'package:bots_no_tdd/data/User.dart';

class UserResponse {

  static User fromMap(dynamic obj) {
    // final obj = json.decode(source);
    return User(
      obj['name'],
      obj['comment'],
      updated: obj['updated'],
      id: obj['id']
    );
  }

  static List<User> fromList(String source) {
    final List<dynamic> array = json.decode(source);
    return array.map(fromMap).toList();
  }
}