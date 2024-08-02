// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? get token => _token;
  String? _role;
  String? get role => _role;

  Future<void> register(String nama, String email, String password, String role) async {
    final url = Uri.parse('https://kadernu.brandone.my.id/api/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nama': nama,
        'email': email,
        'password': password,
        'password_confirmation': password,
        'role': role,
      }),
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      _token = responseData['data']['token'];
      _role = responseData['data']['user']['role'];
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', _token!);
      prefs.setString('role', _role!);
      notifyListeners();
    } else {
      final errorData = json.decode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to register');
    }
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse('https://kadernu.brandone.my.id/api/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      _token = responseData['data']['token'];
      _role = responseData['data']['user']['role'];
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', _token!);
      prefs.setString('role', _role!);
      notifyListeners();
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> logout() async {
    final url = Uri.parse('https://kadernu.brandone.my.id/api/logout');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 200) {
      _token = null;
      _role = null;
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
      prefs.remove('role');
      notifyListeners();
    } else {
      throw Exception('Failed to logout');
    }
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token')) {
      return;
    }
    _token = prefs.getString('token');
    _role = prefs.getString('role');
    notifyListeners();
  }

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  void setRole(String role) {
    _role = role;
    notifyListeners();
  }
}