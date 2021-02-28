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
    final res = array.map(fromMap).toList();
    res.sort((u1, u2) => u2.updated.compareTo(u1.updated));
    return res;
  }
}