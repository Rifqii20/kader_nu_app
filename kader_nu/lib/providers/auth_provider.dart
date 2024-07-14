// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:kader_nu/models/auth_model.dart';
import 'package:kader_nu/services/api_service.dart';

class AuthProvider with ChangeNotifier {
  String _token = '';
  String _role = '';
  bool _isAuthenticated = false;

  String get token => _token;
  String get role => _role;
  bool get isAuthenticated => _isAuthenticated;

  final ApiService apiService = ApiService();

  Future<void> login(String email, String password) async {
    try {
      AuthResponse authResponse = await apiService.login(email, password);
      _token = authResponse.token;
      _role = authResponse.role;
      _isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> register(String nama, String email, String password, String role) async {
    try {
      AuthResponse authResponse = await apiService.register(nama, email, password, role);
      _token = authResponse.token;
      _role = authResponse.role;
      _isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void logout() {
    _token = '';
    _role = '';
    _isAuthenticated = false;
    notifyListeners();
  }
}
