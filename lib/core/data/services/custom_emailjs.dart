// lib/custom_emailjs.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class CustomEmailJS {
  static String _publicKey = '';
  static String? _privateKey;
  static String _host = 'api.emailjs.com';

  static void init({
    required String publicKey,
    String? privateKey,
    String? host,
  }) {
    _publicKey = publicKey;
    _privateKey = privateKey;
    _host = host ?? 'api.emailjs.com';
  }

  static Future<void> send({
    required String serviceID,
    required String templateID,
    required Map<String, dynamic> templateParams,
  }) async {
    final url = Uri.https(_host, 'api/v1.0/email/send');
    final body = json.encode({
      'service_id': serviceID,
      'template_id': templateID,
      'user_id': _publicKey,
      'accessToken': _privateKey,
      'template_params': templateParams,
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'origin': 'http://localhost', // Add the origin header here
      },
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send email: ${response.body}');
    }
  }
}
