import 'package:http/http.dart';

class HttpService {
  HttpService._();

  /// Singleton to ensure only one class instance is created
  static final HttpService _instance = HttpService._();
  factory HttpService() => _instance;

  /// Get request from the API and return `Response` data.
  static Future<Response> getRequest({
    required String url,
    Map<String, String>? headers,
  }) async {
    Response response = await get(
      Uri.parse(url),
      headers: headers ?? {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw 'Unable to get request.';
    }
  }

  static Future<Response> postRequest({
    required String url,
    Object? body,
    Map<String, String>? headers,
  }) async {
    Response response = await post(
      Uri.parse(url),
      body: body,
      headers: headers ??
          {
            'Content-Type': 'application/json; charset=UTF-8',
          },
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw 'Unable to get request.';
    }
  }
}
