// lib/providers/aset_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kader_nu/models/aset_model.dart';
import 'package:kader_nu/providers/auth_provider.dart';
import 'package:provider/provider.dart';


class AsetProvider with ChangeNotifier {
  List<Aset> _aset = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Aset> get aset => _aset;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchAset(BuildContext context) async {
    _setLoading(true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    final url = 'https://kadernu.brandone.my.id/api/aset';

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
        _aset = data.map((json) => Aset.fromJson(json)).toList();
      } else {
        _setError('Failed to load aset');
      }
    } catch (e) {
      _setError('An error occurred');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> addAset(BuildContext context, Aset aset) async {
    _setLoading(true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    final url = 'https://kadernu.brandone.my.id/api/aset';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(aset.toJson()),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        _aset.add(Aset.fromJson(responseData['data']));
      } else {
        _setError('Failed to add aset');
      }
    } catch (e) {
      _setError('An error occurred');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> updateAset(BuildContext context, Aset aset) async {
    _setLoading(true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    final url = 'https://kadernu.brandone.my.id/api/aset/${aset.id}';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(aset.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final index = _aset.indexWhere((a) => a.id == aset.id);
        if (index != -1) {
          _aset[index] = Aset.fromJson(responseData['data']);
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

  Future<void> deleteAset(String token, int id) async {
    _setLoading(true);
    final url = 'https://kadernu.brandone.my.id/api/aset/$id';

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        _aset.removeWhere((aset) => aset.id == id);
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

  String generateKodeAset(List<Aset> aset) {
    int lastNumber = 0;
    if (aset.isNotEmpty) {
      lastNumber = aset
          .map((aset) => int.parse(aset.kodeAset.substring(1)))
          .reduce((value, element) => value > element ? value : element);
    }
    int newNumber = lastNumber + 1;
    return '0' + newNumber.toString().padLeft(4, '0');
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
