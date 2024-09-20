import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'https://localhost:7141/';

  Future<void> registerUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'), // Adjust this endpoint if different
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      print('Register response status: ${response.statusCode}');
      print('Register response body: ${response.body}');

      if (response.statusCode == 201) { // Adjust this status code if different
        print('User registered successfully');
      } else {
        throw Exception('Registration failed: ${response.body}');
      }
    } catch (e) {
      print('Registration error: $e');
      throw Exception('Registration failed: $e');
    }
  }

  Future<String> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'), // Adjust this endpoint if different
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200) { // Adjust this status code if different
        final responseData = json.decode(response.body);
        final token = responseData['token']; // Adjust this key if different
        await _saveAuthData(token, email);
        return token;
      } else {
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      print('Login error: $e');
      throw Exception('Login failed: $e');
    }
  }

  Future<void> logout() async {
    // Implement logout logic
    // This might involve clearing stored tokens, making an API call, etc.
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Be cautious with this, as it clears all SharedPreferences data
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') != null;
  }

  Future<String?> getLoggedInUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }

  Future<void> _saveAuthData(String token, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('userEmail', email);
  }
}