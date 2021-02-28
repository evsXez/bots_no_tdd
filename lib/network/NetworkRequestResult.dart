import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

import 'NetworkRequestError.dart';
import 'Network.dart';



class NetworkRequestResult {
  final String success;
  final NetworkRequestError error;
  final int counter;

  NetworkRequestResult({this.success, this.error, this.counter}) {
    if (counter == null) return; //skip

    if (isError()) {
      developer.log("$Network._tf<<< [$counter]: $error");
    } else {
      // final jsonString = json.decode(success);
      final decodedJson = json.decode(success);
      final encodedJson = json.encode(decodedJson);
      //developer.log("$_tf<<< [$counter]: ${encodedJson}");
      
      final showLog = true;//success.length < 1000;
      debugPrint("$Network._tf<<< [$counter]: ${showLog ? "" : "< some big output >"}");
      if (showLog) _printWrapped(encodedJson); 
    }
  }

  void _printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); 
    pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
  }

  bool isError() => error != null;

  factory NetworkRequestResult.fromResponse(http.Response response, {int counter, bool isJson = true}) {
    String body() => isJson ? response.body : Utf8Codec().decode(response.bodyBytes);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return NetworkRequestResult(
        success: body(),//json.encode(response.body),
        counter: counter,
      );
    } else {
      return NetworkRequestResult(
        error: NetworkRequestError(response.statusCode, response.body),
        counter: counter,
      );
    }
  }


}