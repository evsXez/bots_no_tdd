import 'dart:convert';

class NetworkRequestError {

  static const int STATUS_BLOCKED_MULTIPLY_CALL = -101;

  int status;
  String body;

  NetworkRequestError(this.status, this.body);

  String toString() {
    try {
      final decodedJson = json.decode(body);
      final encodedJson = json.encode(decodedJson);
      return "ERROR [server, status: $status] $encodedJson";
    } catch (e) {
      return "ERROR [http, status: $status]: $body";
    }
  }

  String get serverMessage {
    try {
      return json.decode(body)['message'];
    } catch (e) {
      return body;
    }
  }

  String get errorMessageForUser {
    if (status != null) return "Status: $status\nReason: $serverMessage";
    return "$body";
  }

}