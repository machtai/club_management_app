import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "https://ql-clb.onrender.com/api";

  // Method to handle registration
  Future<Map<String, dynamic>> register(String user, String pwd, String email, String phone, String addr) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user': user,
        'pwd': pwd,
        'email': email,
        'phone': phone,
        'addr': addr,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Return the response body
    } else {
      throw Exception('Failed to register');
    }
  }

  // Method to handle login
  Future<Map<String, dynamic>> login(String user, String pwd) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user': user,
        'pwd': pwd,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Return the response body
    } else {
      throw Exception('Failed to login');
    }
  }
}
