import 'dart:convert';
import 'dart:io';

import 'package:bots_no_tdd/resources/Strings.dart';

import 'Network.dart';
import 'NetworkRequestError.dart';
import 'NetworkRequestResult.dart';

class API {

  static Network _network = Network("http://10.0.2.2:5001/vn-iif/us-central1/");
  static Network _networkForStream = Network("https://api.instantwebtools.net/v1/");

  static Future<NetworkRequestResult> callAddUser<T>(String name, String comment, {dynamic Function(T data) onSuccess, Function(NetworkRequestError) onError, T Function(String) converter}) =>
    _call(_addUser(name, comment), onSuccess: onSuccess, onError: onError, converter: converter);

  static Future<NetworkRequestResult> callUpdateUser<T>(String id, String name, String comment, {dynamic Function(T data) onSuccess, Function(NetworkRequestError) onError, T Function(String) converter}) =>
    _call(_updateUser(id, name, comment), onSuccess: onSuccess, onError: onError, converter: converter);

  static Future<NetworkRequestResult> callDeleteUser<T>(String id, {dynamic Function(T data) onSuccess, Function(NetworkRequestError) onError, T Function(String) converter}) =>
    _call(_deleteUser(id), onSuccess: onSuccess, onError: onError, converter: converter);

  static Future<NetworkRequestResult> callGetUsers<T>({dynamic Function(T data) onSuccess, Function(NetworkRequestError) onError, T Function(String) converter}) =>
    _call(_getUsers(), onSuccess: onSuccess, onError: onError, converter: converter);

  static Future<NetworkRequestResult> callHello<T>({dynamic Function(T data) onSuccess, Function(NetworkRequestError) onError, T Function(String) converter}) =>
    _call(_hello(), onSuccess: onSuccess, onError: onError, converter: converter);

  static Future<NetworkRequestResult> callStream<T>(int page, {dynamic Function(T data) onSuccess, Function(NetworkRequestError) onError, T Function(String) converter}) =>
    _call(_getPage(page), onSuccess: onSuccess, onError: onError, converter: converter);

  static Future<NetworkRequestResult> _call<T>(Future<NetworkRequestResult> method, {dynamic Function(T data) onSuccess, Function(NetworkRequestError) onError, T Function(String) converter}) {
    assert(onSuccess != null);
    assert(onError != null);
    return method.then((res) {
      if (res.isError()) {
        onError(_humanReadableError(res.error));
      } else {
        dynamic data = res.success;
        if (converter != null) {
          try {
            data = converter(data);
          } catch (e) {
            print("ERROR: $e");
            return NetworkRequestResult(error: NetworkRequestError(-1, e.toString()));
          }
        }
        onSuccess(data);
      }
      return res;
    });
  }

  static NetworkRequestError _humanReadableError(NetworkRequestError error) {
    if (error.body.contains("SocketException")) error.body = Strings.error_network;
    return error;
  }

  static Future<NetworkRequestResult> _addUser(String name, String comment) async {
    return await _network.post("highfive", {"name": name, "comment": comment});
  }
  static Future<NetworkRequestResult> _updateUser(String id, String name, String comment) async {
    return await _network.put("highfive/$id", {"name": name, "comment": comment});
  }
  static Future<NetworkRequestResult> _deleteUser(String id) async {
    return await _network.delete("highfive/$id");
  }
  static Future<NetworkRequestResult> _getUsers() async {
    return await _network.get("highfive");
  }
  static Future<NetworkRequestResult> _hello() async {
    return await _network.get("hello");
  }
  static Future<NetworkRequestResult> _getPage(int page) async {
    return await _networkForStream.get("passenger?page=$page&size=7");
  }


}