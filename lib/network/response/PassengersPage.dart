import 'dart:convert';

import 'package:bots_no_tdd/data/Passenger.dart';
import 'package:bots_no_tdd/network/response/PassengerResponse.dart';

class PassengersPage {

  int page;
  final int totalPassengers;
  final int totalPages;
  final List<Passenger> list;

  PassengersPage(this.totalPassengers, this.totalPages, this.list);

  static PassengersPage fromJson(String source) {
    final dynamic obj = json.decode(source);
    return PassengersPage(
      obj['totalPassengers'],
      obj['totalPages'],
      PassengerResponse.fromArray(obj['data']),
    );

  }

}