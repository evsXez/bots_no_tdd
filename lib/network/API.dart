import 'dart:convert';
import 'dart:io';

import 'package:bots_no_tdd/resources/Strings.dart';

import 'Network.dart';
import 'NetworkRequestError.dart';
import 'NetworkRequestResult.dart';

class API {

  static Network _network = Network();

  static Future<NetworkRequestResult> callAddUser<T>(String name, String comment, {dynamic Function(T data) onSuccess, Function(NetworkRequestError) onError, T Function(String) converter}) =>
    _call(_addUser(name, comment), onSuccess: onSuccess, onError: onError, converter: converter);

  static Future<NetworkRequestResult> callUpdateUser<T>(String id, String name, String comment, {dynamic Function(T data) onSuccess, Function(NetworkRequestError) onError, T Function(String) converter}) =>
    _call(_updateUser(id, name, comment), onSuccess: onSuccess, onError: onError, converter: converter);

  static Future<NetworkRequestResult> callGetUsers<T>({dynamic Function(T data) onSuccess, Function(NetworkRequestError) onError, T Function(String) converter}) =>
    _call(_getUsers(), onSuccess: onSuccess, onError: onError, converter: converter);

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
    return await _network.put("highfive", {"id": id, "name": name, "comment": comment});
  }
  static Future<NetworkRequestResult> _getUsers() async {
    return await _network.get("highfive");
  }


}