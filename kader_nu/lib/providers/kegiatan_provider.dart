import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kader_nu/models/kegiatan_model.dart';
import 'package:kader_nu/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class KegiatanProvider with ChangeNotifier {
  List<Kegiatan> _kegiatan = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Kegiatan> get kegiatan => _kegiatan;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchKegiatan(BuildContext context) async {
    _setLoading(true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    final url = 'https://kadernu.brandone.my.id/api/kegiatan';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];
        _kegiatan = data.map((json) => Kegiatan.fromJson(json)).toList();
      } else {
        _setError('Failed to load kegiatan');
      }
    } catch (e) {
      _setError('An error occurred');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> addKegiatan(BuildContext context, Kegiatan kegiatan) async {
    _setLoading(true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    final url = 'https://kadernu.brandone.my.id/api/kegiatan';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(kegiatan.toJson()),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        _kegiatan.add(Kegiatan.fromJson(responseData['data']));
      } else {
        _setError('Failed to add kegiatan');
      }
    } catch (e) {
      _setError('An error occurred');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> updateKegiatan(BuildContext context, Kegiatan kegiatan) async {
    _setLoading(true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    final url = 'https://kadernu.brandone.my.id/api/kegiatan/${kegiatan.id}';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(kegiatan.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final index = _kegiatan.indexWhere((k) => k.id == kegiatan.id);
        if (index != -1) {
          _kegiatan[index] = Kegiatan.fromJson(responseData['data']);
        }
      } else {
        _setError('Failed to update kegiatan');
      }
    } catch (e) {
      _setError('An error occurred');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> deleteKegiatan(String token, int id) async {
    _setLoading(true);
    final url = 'https://kadernu.brandone.my.id/api/kegiatan/$id';

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        _kegiatan.removeWhere((kegiatan) => kegiatan.id == id);
      } else {
        _setError('Failed to delete kegiatan');
      }
    } catch (e) {
      _setError('An error occurred');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void _setError(String? errorMessage) {
    _errorMessage = errorMessage;
    notifyListeners();
  }
}
