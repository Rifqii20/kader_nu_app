import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kader_nu/models/jamaah_model.dart';

class JamaahProvider with ChangeNotifier {
  List<Jamaah> _jamaahs = [];
   bool _isLoading = false;
  String? _errorMessage;

  List<Jamaah> get jamaahs => _jamaahs;
   bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchJamaahs() async {
    final url = 'https://kadernu.brandone.my.id/api/jamaah';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _jamaahs = data.map((json) => Jamaah.fromJson(json)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load jamaahs');
    }
  }

  Future<void> addJamaah(Jamaah jamaah) async {
    final url = 'https://kadernu.brandone.my.id/api/jamaah';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(jamaah.toJson()),
    );

    if (response.statusCode == 201) {
      _jamaahs.add(Jamaah.fromJson(json.decode(response.body)));
      notifyListeners();
    } else {
      throw Exception('Failed to add jamaah');
    }
  }

  Future<void> updateJamaah(Jamaah jamaah) async {
    final url = 'https://kadernu.brandone.my.id/api/jamaah/${jamaah.id}';
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(jamaah.toJson()),
    );

    if (response.statusCode == 200) {
      final index = _jamaahs.indexWhere((j) => j.id == jamaah.id);
      if (index != -1) {
        _jamaahs[index] = Jamaah.fromJson(json.decode(response.body));
        notifyListeners();
      }
    } else {
      throw Exception('Failed to update jamaah');
    }
  }

  Future<void> deleteJamaah(int id) async {
    final url = 'https://kadernu.brandone.my.id/api/jamaah/$id';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      _jamaahs.removeWhere((jamaah) => jamaah.id == id);
      notifyListeners();
    } else {
      throw Exception('Failed to delete jamaah');
    }
  }
}
