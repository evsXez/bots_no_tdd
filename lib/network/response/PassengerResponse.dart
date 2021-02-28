import 'dart:convert';

import 'package:bots_no_tdd/data/Passenger.dart';

class PassengerResponse {

  static Passenger fromMap(dynamic obj) {
    var airline = obj['airline'];
    if (airline is List<dynamic>) airline = airline.first;

    return Passenger(
      obj['name'],
      airline['logo'],
      obj['trips'],
    );
  }

  static List<Passenger> fromArray(List<dynamic> array) {
    return array.map(fromMap).toList();
  }

}