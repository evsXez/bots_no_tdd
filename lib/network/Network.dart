import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import 'NetworkRequestError.dart';
import 'NetworkRequestResult.dart';

class Network {

  // String get server => "http://localhost:5001/vn-iif/us-central1/";
  String get server => "http://10.0.2.2:5001/vn-iif/us-central1/";

  static int requestCounter = 0;


  // static HttpClient _httpsClient() => HttpClient(context: SecurityContext.defaultContext)
  //     ..badCertificateCallback = (X509Certificate cert, String host, int port) {
  //       print("bad cert!"); //TODO: ask why cert is bad
  //       return true; 
  //     }
  //     ..connectionTimeout = Duration(seconds: RELEASE_MODE ? 30 : 5);
  static var client = IOClient(_httpClient());

  static HttpClient _httpClient() => HttpClient()
      ..connectionTimeout = Duration(seconds: 10);


  Future<NetworkRequestResult> get(String path) async {
    final counter = requestCounter++;
    debugPrint("$_tf>>> [$counter]: GET \"${server+path}\"");
      
    try {
      final res = client.get(server + path);
      return NetworkRequestResult.fromResponse(await res, counter: counter);
    } catch (e) {
      return NetworkRequestResult(error: NetworkRequestError(-1, "$e"), counter: counter);
    }
  }

  // Future<NetworkRequestResult> getHttpRaw(String path) async {
  //   if (!_multiplyCallBlocker.isCallAllowed(path)) return resultMultiplyBlocked;

  //   final counter = requestCounter++;
  //   if (Consts.SHOW_NETWORK_TRAFFIC) debugPrint("$_tf>>> [$counter]: GET \"$path\"");
      
  //   final client = _getClientHttp();
  //   try {
  //     final res = client.get(path);
  //     return NetworkRequestResult.fromResponse(await res, counter: counter);
  //   } catch (e) {
  //     _closeClient(client);
  //     return NetworkRequestResult(error: NetworkRequestError(-1, "$e"), counter: counter);
  //   } finally {
  //     _closeClient(client);
  //   }
  // }

  // Map<String,String> _maybeJson(Map<String,String> original, dynamic body) {
  //   if (body is String) {
  //     try { 
  //       json.decode(body); 
  //       original.addAll({"Content-Type": "application/json"});
  //     } catch (e) {}
  //   }
  //   return original;
  // }

  Future<NetworkRequestResult> post(String path, dynamic body) async {
    final counter = requestCounter++;
    debugPrint("$_tf>>> [$counter]: POST \"${server+path}\" BODY: $body");

    try {
      final res = await client.post(
          server + path,
          body: body,
        );
      return NetworkRequestResult.fromResponse(res, counter: counter);
    } catch (e) {
      return NetworkRequestResult(error: NetworkRequestError(-1, "$e"), counter: counter);
    }
  }

  Future<NetworkRequestResult> put(String path, dynamic body) async {
    final counter = requestCounter++;
    debugPrint("$_tf>>> [$counter]: PUT \"${server+path}\" BODY: $body");

    try {
      final res = await client.put(
          server + path,
          body: body,
        );
      return NetworkRequestResult.fromResponse(res, counter: counter);
    } catch (e) {
      return NetworkRequestResult(error: NetworkRequestError(-1, "$e"), counter: counter);
    }
  }

  // void _saveCookie(http.Response res) {
  //   final key = res.headers.keys.firstWhere((it) => it.toLowerCase() == "set-cookie", orElse: ()=>null);
  //   if (key != null) {
  //     _cookie = res.headers[key];
  //     if (Consts.SHOW_NETWORK_TRAFFIC) print("COOKIE SAVED: $_cookie");
  //   }
  // }

  // void clearCookies() => _cookie = null;
  // void setDebugCookie(String s) {
  //   print("DEBUG: setDebugCookie: $s");
  //   _cookie = s;
  //   if (Consts.SHOW_NETWORK_TRAFFIC) print("COOKIE REPLACED(SET DEBUG): $_cookie");
  // }

}




//time print
double get _tfCurrent => DateTime.now().millisecondsSinceEpoch/1000;
double _tfLast = _tfCurrent;
String get _tf {
  final current = _tfCurrent;
  final diff = current - _tfLast;
  _tfLast = current;
  return "(+${diff.toStringAsPrecision(4)}sec) ";
}


